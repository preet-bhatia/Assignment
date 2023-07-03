require 'test_helper'

class AddressTest < ActiveSupport::TestCase

    def setup
        @user = User.create(username:"testing", name:"Test", email:"testing@gmail.com", mobile:"9999988888", dob:"1992-01-31", password:"test")
        @address = Address.new(address1:"5th Block", district:"BENGALURU", state: "KARNATAKA", country:"INDIA", postal_code:"546008", customer_id:@user.customer_id)
    end 

    test "address should be valid" do
        assert @address.valid?
    end

    test "address1 field should be present" do
        @address.address1 = " "
        assert_not @address.valid?
    end

    test "district should be present" do
        @address.district = " "
        assert_not @address.valid?
    end

    test "state should be present" do
        @address.state = " "
        assert_not @address.valid?
    end

    test "country should be present" do
        @address.country = " "
        assert_not @address.valid?
    end

    test "postal_code should be present" do
        @address.postal_code = " "
        assert_not @address.valid?
    end

    test "postal_code should be exact 6 in length" do
        @address.postal_code = "9"*3
        assert_not @address.valid?
    end

    test "for each address user must exist" do
        @address1 = Address.new(address1:"5th Block", district:"BENGALURU", state: "KARNATAKA", country:"INDIA", postal_code:"546008")
        assert_not @address1.valid?
    end
end