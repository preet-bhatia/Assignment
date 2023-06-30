class LoanAccountInfo < ApplicationRecord
    enum loan_type: { home: 0, car: 1, personal: 2, business: 3}
    belongs_to :account, foreign_key: 'account_number', primary_key: 'account_number'
    validate :check_eligibility_for_loan_account
    validates :loan_type, :amount, :duration, presence: true
    MINIMUM_AGE_LIMIT = 25
    HOME_LOAN_INTEREST_RATE = 7
    CAR_LOAN_INTEREST_RATE = 8
    PERSONAL_LOAN_INTEREST_RATE = 12
    BUSINESS_LOAN_INTEREST_RATE = 15
    COMPOUNDING_RATE = 2

    def check_eligibility_for_loan_account
        if self.account.user.accounts.find_by(account_type: ['saving', 'current']).nil?
            errors.add(:base, "You are not allowed to create loan accounts as you are not having any saving or current account")
        elsif age_of_user(self.account.user.dob) < MINIMUM_AGE_LIMIT
            errors.add(:base, "You are not allowed to create loan accounts as you are not having minimum age #{MINIMUM_AGE_LIMIT} years")
        end
    end

    def age_of_user(dob)
        ((Time.zone.now - dob.to_time) / 1.year.seconds).floor
      end

    def add_interest_for_loan_accounts
        accounts = Account.where(account_type:'loan')
        accounts.each do |account|
            loan_info = account.loan_account_info
            if loan_info.updated_at + 6.month  > Time.now
                interest = 0
                case  loan_info.loan_type
                    when 'home'  
                        interest = HOME_LOAN_INTEREST_RATE
                    when 'car'  
                        interest = CAR_LOAN_INTEREST_RATE
                    when 'business' 
                        interest = BUSINESS_LOAN_INTEREST_RATE
                    when 'personal' 
                        interest = PERSONAL_LOAN_INTEREST_RATE
                    else  
                        interest = 0
                end  
                value = loan_account_info.amount * (1 + interest.to_f / (100 * COMPOUNDING_RATE))**(loan_info.duration * COMPOUNDING_RATE)
                loan_info.amount = value
                loan_info.save
            end
        end
    end
end