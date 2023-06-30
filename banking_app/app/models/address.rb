class Address < ApplicationRecord
    belongs_to :user, foreign_key: 'customer_id', primary_key: 'customer_id'
    validates :address1, :district, :state, :country, presence: true
    validates :postal_code, presence: true, length: { is: 6 }
    before_save :update_address_fields
    
    def update_address_fields
        self.district.upcase!
        self.state.upcase!
        self.country.upcase!
    end
end