class Account < ApplicationRecord
    before_create :generate_account_number
    after_create :generate_atm_card 
    after_create :add_opening_balance_in_transaction
    validates :account_type, :balance, presence: true
    validate :validity_of_minimum_account_balance, on: :create
    validate :validity_of_age
    validates :balance, presence: true
    MINIMUM_CURRENT_ACCOUNT_BALANCE = 100000
    MINIMUM_SAVING_ACCOUNT_BALANCE = 10000
    MINIMUM_AGE_CURRENT_ACCOUNT = 18
    MINIMUM_TRANSACTIONS_CURRENT_ACCOUNT = 3
    PENALTY_FOR_LESS_TRANSACTIONS = 500
    INTEREST_RATE_FOR_SAVING_ACCOUNT = 6
    NRV_SAVING = 100000
    NRV_CURRENT = 500000
    NRV_PENALTY_SAVING = 1000
    NRV_PENALTY_CURRENT = 5000

    enum account_type: { saving: 0, current: 1, loan: 2}
    belongs_to :user, foreign_key: 'customer_id', primary_key: 'customer_id'
    has_one :loan_account_info, foreign_key: 'account_number', primary_key: 'account_number'
    has_many :transactions, foreign_key: 'account_number', primary_key: 'account_number'
    has_one :atm_card, foreign_key: 'account_number', primary_key: 'account_number'

    def generate_account_number
        token = ''
        10.times { token += rand(0..9).to_s}
        self.account_number = token
    end
    
    def generate_atm_card
        GenerateAtmCard.call(account_number: self.account_number) if self.account_type == 'saving'
    end
    
    def add_opening_balance_in_transaction
        if self.account_type != 'loan'
            transaction = Transaction.create(amount:self.balance, account_number:self.account_number, transaction_type:'deposit', current_balance:self.balance)
        end
    end
    def validity_of_minimum_account_balance
        minimum_account_balance = -1
        if self.account_type == 'saving'
            minimum_account_balance = MINIMUM_SAVING_ACCOUNT_BALANCE
        elsif self.account_type == 'current'
            minimum_account_balance = MINIMUM_CURRENT_ACCOUNT_BALANCE
        end
        errors.add(:balance, "can't be less than #{minimum_account_balance} for #{self.account_type.upcase} account") if self.balance < minimum_account_balance
    end
    def validity_of_age
        if self.account_type == 'current'
            errors.add(:account_type, " #{self.account_type.upcase} can't be allowed for users having age less than #{MINIMUM_AGE_CURRENT_ACCOUNT} years") if age_of_user(self.user.dob) < MINIMUM_AGE_CURRENT_ACCOUNT
        end
    end
    def age_of_user(dob)
        ((Time.zone.now - dob.to_time) / 1.year.seconds).floor
    end
    def min_transaction_for_current_accounts_per_month
        accounts = Account.where(account_type:'current')
        accounts.each do |account|
            transactions = account.transactions.where(transaction_type: ['deposit','bank_withdrawal'])
            if transactions.length < MINIMUM_TRANSACTIONS_CURRENT_ACCOUNT
                charge = -PENALTY_FOR_LESS_TRANSACTIONS
                transaction = Transaction.new(amount:charge,account_number:account.account_number, transaction_type: 4,current_balance:account.balance+charge)
                transaction.save
            end
        end
    end
    def calculate_interest_saving_account_per_month
        accounts = Account.where(account_type:'saving')
        number_of_days_in_month = (Time.now - 3.hours).end_of_month.day
        accounts.each do |account|
            p total_interest
            total_interest = get_account_value(account) * (INTEREST_RATE_FOR_SAVING_ACCOUNT/100) * (1/365)
            transaction = Transaction.new(amount:total_interest,account_number:account.account_number, transaction_type: 4,current_balance:account.balance+charge)
            transaction.save
        end
    end
    def calculate_nrv
        number_of_days_in_month = (Time.now - 3.hours).end_of_month.day
        accounts = Account.where(account_type: ['saving','current'])
        accounts.each do |account|
            nrv = get_account_value(account) / number_of_days_in_month
            if(account.account_type == 'saving' && nrv < NRV_SAVING)
                transaction = Transaction.new(amount:-NRV_PENALTY_SAVING,account_number:account.account_number, transaction_type: 4,current_balance:account.balance+charge)
                transaction.save
            elsif (account.account_type == 'current' && nrv < NRV_CURRENT)
                transaction = Transaction.new(amount:-NRV_PENALTY_CURRENT,account_number:account.account_number, transaction_type: 4,current_balance:account.balance+charge)
                transaction.save
            end
        end
    end
    
    def get_account_value(account, number_of_days_in_month)
        account_value = 0
        transactions = account.transactions.where(created_at:((Time.now - 3.hours).beginning_of_month..Time.now))
        if transactions.length > 0
            prev_amount = get_last_calculated_balance(transactions[0], account) 
            prev_date = 1 
            for index in (0...transaction.length-1)
                current_date = ransaction[index].created_at.strftime("%d").to_i
                if(current_date != transaction[index+1].created_at.strftime("%d").to_i)
                    account_value += (current_date - prev_date) * prev_amount
                    prev_date = current_date
                    prev_amount = transaction[index].current_balance 
                end
            end
            account_value = (number_of_days_in_month - prev_date + 1) * prev_amount
        else
            prev_amount = get_last_calculated_balance(nil, account) 
            account_value = prev_amount * number_of_days_in_month
        end
    end
    
    def get_last_calculated_balance(first_transaction, account)
        all_transactions = account.transactions
        if all_transactions[0]  == first_transaction 
            return 0
        else
            if first_transaction.nil?
                return all_transactions.last.current_balance
            else
                ind = all_transactions.find_index(first_transaction)
                return all_transactions[ind-1].current_balance
            end
        end
    end

end