class User < ApplicationRecord
    before_create :convert_downcase
    before_create :get_customer_id
    has_many :accounts, foreign_key: 'customer_id', primary_key: 'customer_id'
    has_one :address, foreign_key: 'customer_id', primary_key: 'customer_id'
    accepts_nested_attributes_for :address
    VALID_USERNAME_REGEX = /\A[a-zA-Z]+\z/
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :name, :dob, presence: true
    validates :mobile, length: { is: 10 } 
    validates :username, presence: true, length:{minimum:3, maximum:25}, format: { with: VALID_USERNAME_REGEX, message: "Only alphabets allowed" }
    validates :email, presence: true, length:{maximum:105}, format: {with: VALID_EMAIL_REGEX}
    validates_uniqueness_of :username, :email
    has_secure_password

    def convert_downcase
        self.email = email.downcase
        self.username = username.downcase
    end

    def get_customer_id
        # logic for setting customer_id
        arr = Array.new(26,0)
        arr[0] = 1
        for i in (1...26)
            arr[i]= arr[i-1]*2 + i +1
        end
        id = 0
        self.username.split("").each do |ele|
            id = id + arr[ele.downcase.ord - 97]
        end
        self.customer_id = id
    end
end
  