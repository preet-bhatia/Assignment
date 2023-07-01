class UsersController < ApplicationController
    before_action :require_user, only: [:show]
    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        if @user.save
            SaveAddress.call(@user.get_address_params(params[:address]))
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
end
  