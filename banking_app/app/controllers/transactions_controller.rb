class TransactionsController < ApplicationController
    before_action :require_user
    before_action :require_account
    before_action :generate_transaction, only: [:deposit, :withdrawal, :transfer]
    
    def deposit
    end
    
    def withdrawal
        validate_account_type(['loan'])
    end
    
    def transfer
        validate_account_type(['saving','loan'])
    end
    
    def debit
        @transaction = Transaction.create_transaction(transaction_params, @current_account)
        if @transaction.save
            flash[:notice] = "Congrats , successfully debited"
            redirect_to @current_account
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
        @transaction = Transaction.create_transaction(transaction_params, @current_account)
        if @transaction.save
            if @current_account.account_type == 'loan'
                flash[:notice] = "Congrats , successfully depoisted installment to loan account"
                redirect_to account_path(@current_account)
            else
                flash[:notice] = "Congrats , successfully credited"
                redirect_to @current_account
            end
        else
            render 'deposit'
        end
    end
    
    def index
        @transactions = @current_account.transactions
    end
    private

    def transaction_params
        params.require(:transaction).permit(:transaction_type, :amount,:account_related)
    end

    def generate_transaction
        @transaction = Transaction.new
    end

    def validate_account_type(invalid_account_types)
        if invalid_account_types.include?(@current_account.account_type)
            flash[:alert] = "Requested facility not found for this account"
            redirect_to @current_account
        end
    end
end