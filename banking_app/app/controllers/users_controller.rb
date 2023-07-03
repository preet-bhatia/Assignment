class UsersController < ApplicationController
    before_action :require_user, only: [:show]
    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        if @user.save
            SaveAddress.call(address_params(@user.customer_id))
            session[:user_id] = @user.customer_id
            flash[:notice] = "Welcome #{@user.name}, you have signed up successfully"
            redirect_to @user
        else
            render 'new'
        end
    end
    def show
        @accounts = current_user.accounts.where(account_type: ["saving", "current"])
    end


    private
    def user_params
        params.require(:user).permit(:name, :email, :username, :dob, :mobile, :password)
    end
    def address_params(user_customer_id)
        params.require(:address).permit(:address1, :district, :state, :country, :postal_code).merge(customer_id:user_customer_id)
    end
end
  