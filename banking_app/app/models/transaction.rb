class Transaction < ApplicationRecord
    before_save :round_off_to_two_digits
    after_save :update_account_balance
    after_save :update_receiver_balance
    after_save :max_transactions_for_card 
    after_save :transaction_charge_current_account
    validates :amount, :transaction_type, :current_balance, presence: true
    validate :amount_cannot_be_greater_than_balance
    validate :transfer_account_not_exist
    validate :validity_of_loan_installment
    validate :validate_saving_account_transaction
    validate :validate_current_account_transaction
    enum transaction_type: { deposit: 0, bank_withdrawal: 1, atm_withdrawal: 2, transfer: 3, charge: 4}
    belongs_to :account, foreign_key: 'account_number', primary_key: 'account_number'
    
    MAX_DAY_LIMIT_SAVING_ACCOUNT = 50000
    MAX_LIMIT_FOR_CARD = 20000
    TRANSACTION_CHARGE_CURRENT_ACCOUNT = 0.005

    def self.create_transaction(transaction_params, account)
        transaction = Transaction.new(transaction_params)
        if(transaction.transaction_type != 'deposit')
            transaction.amount = -1 * transaction.amount
        end
        transaction.account_number = account.account_number
        transaction.current_balance = account.balance + transaction.amount
        transaction
    end

    def round_off_to_two_digits
        self.amount = self.amount.round(2)
        self.current_balance = self.current_balance.round(2)
    end
    
    def update_account_balance
       self.account.update(balance:self.current_balance)
    end
    
    def update_receiver_balance
        if self.transaction_type == "transfer" && self.amount < 0
            receiver = self.account_related
            account = get_account_by_account_number(self.account_related)
            transaction =  Transaction.new(amount:self.amount.abs, account_number:receiver, transaction_type:'transfer',account_related:self.account_number)
            transaction.current_balance = transaction.amount + account.balance
            transaction.save
        end
    end
    def amount_cannot_be_greater_than_balance
        if self.transaction_type != "deposit" && self.amount < 0
            errors.add(:amount, "can't be greater than account balance") if get_account_by_account_number(self.account_number).balance < self.amount.abs
        end
    end

    def validity_of_loan_installment
        account  = self.account
        if account.account_type == 'loan'
            errors.add(:amount, "can't be greater than 10% of total loan amount") if self.amount > (account.loan_account_info.amount * 0.1)
        end
    end

    def validate_saving_account_transaction
        if self.transaction_type == 'atm_withdrawal' && self.amount.abs >  MAX_LIMIT_FOR_CARD
            errors.add(:amount, " can't be greater than  #{MAX_LIMIT_FOR_CARD}")
        elsif self.account.account_type == 'saving' && ( self.transaction_type == 'bank_withdrawal' || self.transaction_type == 'atm_withdrawal')
            transactions = self.account.transactions.where(created_at: (Time.now.midnight..Time.now), transaction_type: ['atm_withdrawal','bank_withdrawal'])
            total_amount = 0.0
            transactions.each do |transaction|
                total_amount+=transaction.amount.abs
            end
            errors.add(:base, " Withdrawal not possible as you already withdrawn #{total_amount} from daily limit of #{MAX_DAY_LIMIT_SAVING_ACCOUNT}") if (total_amount+ self.amount.abs) >  MAX_DAY_LIMIT_SAVING_ACCOUNT
        end
    end

    def validate_current_account_transaction
        if self.account.account_type == 'current'
            charge = [TRANSACTION_CHARGE_CURRENT_ACCOUNT * (self.amount.abs), 500].min
            if ((self.transaction_type == 'bank_withdrawal' || self.transaction_type == 'transfer')  && self.current_balance < charge )
                errors.add(:base, "Transaction not possible as account does not have enough balance for transaction charge")
            end
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
            charge = -[TRANSACTION_CHARGE_CURRENT_ACCOUNT * (self.amount.abs), 500].min
            transaction = Transaction.create(amount:charge,account_number:self.account_number, transaction_type: 4,current_balance:self.current_balance+charge)
        end
    end
    def transfer_account_not_exist
        if self.transaction_type == "transfer"
            errors.add(:base, "To Account does not exist") if !Account.find_by(account_number: self.account_related)
        end
    end
    def get_account_by_account_number(number)
        Account.find_by(account_number: number)
    end
end