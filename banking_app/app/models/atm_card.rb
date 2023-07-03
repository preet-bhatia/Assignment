class AtmCard < ApplicationRecord
    belongs_to :account, foreign_key: 'account_number', primary_key: 'account_number'
    validates :card_number, :cvv, :expiry_date, presence: true
end