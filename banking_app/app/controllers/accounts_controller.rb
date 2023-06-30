class AccountsController < ApplicationController
    def new
        @account = Account.new
    end
    def create
        @account = Account.new(account_params)
        @account.customer_id = current_user.customer_id
        if @account.save
            flash[:notice] = "Congrats , new account created with account number #{@account.account_number}"
            redirect_to @account
        else
            render 'new'
        end

    end
    def show
        @account = Account.find(params[:id])
        session[:account_number] = @account.account_number
    end
    private
    def account_params
        params.require(:account).permit(:account_type, :balance)
    end
end