class Transaction < ApplicationRecord
    after_save :update_account_balance
    after_save :update_receiver_balance
    after_save :max_transactions_for_card 
    after_save :transaction_charge_current_account
    validates :amount, :transaction_type, :current_balance, presence: true
    validate :amount_cannot_be_greater_than_balance
    validate :transfer_account_not_exist
    validate :validity_of_loan_installment
    validate :max_day_limit_for_saving_account
    validate :max_limit_for_card_withdrawal
    enum transaction_type: { deposit: 0, bank_withdrawal: 1, atm_withdrawal: 2, transfer: 3, charge: 4}
    belongs_to :account, foreign_key: 'account_number', primary_key: 'account_number'
    MAX_DAY_LIMIT_SAVING_ACCOUNT = 50000
    MAX_LIMIT_FOR_CARD = 20000
    TRANSACTION_CHARGE_CURRENT_ACCOUNT = 0.005
    def update_account_balance
       self.account.update(balance:self.current_balance)
    end
    def update_receiver_balance
        if self.transaction_type == "transfer" && self.amount < 0
            receiver = self.account_related
            account = Account.find_by(account_number:receiver)
            transaction =  Transaction.new(amount:self.amount.abs, account_number:receiver, transaction_type:'transfer',account_related:self.account_number)
            transaction.current_balance = transaction.amount + account.balance
            transaction.save
        end
    end
    def amount_cannot_be_greater_than_balance
        if self.transaction_type != "deposit"
            errors.add(:amount, "can't be greater than account balance") if current_account(self.account_number).balance < self.amount.abs
        end
    end
    def validity_of_loan_installment
        account  = self.account
        if account.account_type == 'loan'
            errors.add(:amount, "can't be greater than 10% of total loan amount") if self.amount > (account.loan_account_info.amount * 0.1)
        end
    end
    def max_day_limit_for_saving_account
        if self.account.account_type == 'saving' && ( self.transaction_type == 'bank_withdrawal' || self.transaction_type == 'atm_withdrawal')
            transactions = self.account.transactions.where(created_at: (Time.now.midnight..Time.now), transaction_type: ['atm_withdrawal','bank_withdrawal'])
            byebug
            total_amount = 0.0
            transactions.each do |transaction|
                total_amount+=transaction.amount.abs
            end
            errors.add(:transaction_type, " #{self.transaction_type.upcase} not possible as daily limit of #{MAX_DAY_LIMIT_SAVING_ACCOUNT} will exceed") if (total_amount+ self.amount.abs) >  MAX_DAY_LIMIT_SAVING_ACCOUNT
        end
    end
    def max_limit_for_card_withdrawal
        if self.transaction_type == 'atm_withdrawal'
            errors.add(:amount, " can't be greater than  #{MAX_LIMIT_FOR_CARD}") if self.amount.abs >  MAX_LIMIT_FOR_CARD
        end
    end

    def max_transactions_for_card
        if self.account.account_type == 'saving' && self.transaction_type == 'atm_withdrawal'
            transactions = self.account.transactions.where(created_at: (Time.new(Time.now.year, Time.now.month)..Time.now), transaction_type: 'atm_withdrawal')
            if transactions.length > 5
                transaction = Transaction.new(amount:-500,account_number:self.account_number, transaction_type: 4,current_balance:self.current_balance-500)
                transaction.save        
            end
        end
    end
    def transaction_charge_current_account
        if self.account.account_type == 'current' && self.transaction_type != 'charge'
            charge = -[TRANSACTION_CHARGE_CURRENT_ACCOUNT * (self.amount.abs), 500].min.round(2)
            transaction = Transaction.create(amount:charge,account_number:self.account_number, transaction_type: 4,current_balance:self.current_balance+charge)
        end
    end
    def transfer_account_not_exist
        if self.transaction_type == "transfer"
            errors.add(:account_related, "does not exist") if !Account.find_by(account_number: self.account_related)
        end
    end
    def current_account(number)
        current_account = Account.find_by(account_number: number)
    end
end