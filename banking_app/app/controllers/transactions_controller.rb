class TransactionsController < ApplicationController
    before_action :generate_transaction, only: [:deposit, :withdrawal, :transfer]
    before_action :create_transaction, only: [:debit, :credit]
    
    def deposit
    end
    
    def withdrawal
    end
    
    def transfer
    end
    
    def debit
        if @transaction.save
            flash[:notice] = "Congrats , successfully debited"
            redirect_to current_account
        else
            @transaction.amount = @transaction.amount.abs
            if @transaction.transaction_type == 'transfer' 
                render 'transfer'
            else
                render 'withdrawal'
            end
        end
    end
    
    def credit
        if @transaction.save
            if current_account.account_type == 'loan'
                flash[:notice] = "Congrats , successfully depoisted installment to loan account"
                redirect_to loan_account_info_path(current_account.id)
            else
                flash[:notice] = "Congrats , successfully credited"
                redirect_to current_account
            end
        else
            render 'deposit'
        end
    end
    
    def index
        @transactions = current_account.transactions
    end
    private

    def transaction_params
        params.require(:transaction).permit(:transaction_type, :amount,:account_related)
    end

    def generate_transaction
        @transaction = Transaction.new
    end
    
    def create_transaction
        @transaction = Transaction.new(transaction_params)
        if(@transaction.transaction_type != 'deposit')
            @transaction.amount = -1 * @transaction.amount
        end
        @transaction.account_number = current_account.account_number
        @transaction.current_balance = current_account.balance + @transaction.amount
    end
end