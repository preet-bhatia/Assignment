require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create(username:"testing", name:"Test", email:"testing@gmail.com", mobile:"9999988888", dob:"1992-01-31", password:"test")
  end

  test "should get new" do
    get new_user_url
    assert_response :success
  end


  test "should create user" do
    assert_difference('User.count', 1) do
      post users_url, params: { 
        user: { username:"newtesting", name:"Test", email:"newtesting@gmail.com", mobile:"9999988888", dob:"1992-01-31", password:"test" },
        address: {address1: "5th Block", district: "Bengaluru", state: "Karnataka", country: "India", postal_code: 542311}
      }
    end

    assert_redirected_to user_url(User.last)
  end

  test "should show user" do
    sign_in_as(@user)
    get user_url(@user)
    assert_response :success
  end
end
