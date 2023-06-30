class LoanAccountInfosController < ApplicationController
    def new
        @loanaccount = LoanAccountInfo.new
    end
    
    def create
        @loanaccount = LoanAccountInfo.new(loan_account_params)
        account = Account.create(account_type:'loan', balance:0,customer_id:current_user.customer_id)
        @loanaccount.account_number = account.account_number
        if @loanaccount.save
            flash[:notice] = "Congrats , new loan account created with account number #{account.account_number}"
            redirect_to loan_account_info_path(account)
        else
            account.destroy
            render 'new'
        end
    end
    
    def show
        @account = Account.find(params[:id])
        session[:account_number] = @account.account_number
    end
    
    def index
        @loanaccounts = current_user.accounts.where(account_type:"loan")
    end
    
    private
    
    def loan_account_params
        params.require(:loan_account_info).permit(:loan_type, :amount, :duration)
    end
end