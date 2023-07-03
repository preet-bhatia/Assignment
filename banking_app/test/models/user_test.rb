require 'test_helper'

class UserTest < ActiveSupport::TestCase

    def setup
        @user = User.new(username:"testing", name:"Test", email:"testing@gmail.com", mobile:"9999988888", dob:"1992-01-31", password:"test")
    end 

    test "user should be valid" do
        assert @user.valid?
    end

    test "name should be present" do
        @user.name = " "
        assert_not @user.valid?
    end

    test "dob should be present" do
        @user.dob = " "
        assert_not @user.valid?
    end

    test "mobile should be present" do
        @user.mobile = " "
        assert_not @user.valid?
    end

    test "email should be present" do
        @user.email = " "
        assert_not @user.valid?
    end

    test "username should be present" do
        @user.username = " "
        assert_not @user.valid?
    end

    test "email should be unique" do
        @user.save
        @user2 = User.new(username:"testingaccount", name:"Test", email:"testing@gmail.com", mobile:"9999988888", dob:"1992-01-31", password:"test")
        assert_not @user2.valid?
    end

    test "username should be unique" do
        @user.save
        @user2 = User.new(username:"testing", name:"Test", email:"testing1@gmail.com", mobile:"9999988888", dob:"1992-01-31", password:"test")
        assert_not @user2.valid?
    end

    test "username should not be too long" do
        @user.username = "a"*26
        assert_not @user.valid?
    end

    test "username should not be too short" do
        @user.username = "aa"
        assert_not @user.valid?
    end

    test "email should not be too long" do
        @user.email = "a"*106
        assert_not @user.valid?
    end

    test "mobile should be exact 10 in length" do
        @user.mobile = "9"*9
        assert_not @user.valid?
    end

    test "email should be valid" do
        @user.email = "invalid"
        assert_not @user.valid?
    end

    test "username should have alphabets only" do
        @user.username = "test12"
        assert_not @user.valid?
    end
end