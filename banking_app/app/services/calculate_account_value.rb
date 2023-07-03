class CalculateAccountValue
    attr_reader :account_number, :month_days

    def self.call(args)
        service = self.new(args)
        service.get_account_value
    end
    
    def initialize(args)
        @account_number = args[:account_number]
        @month_days = args[:month_days]
    end

    def get_account_value
        account = Account.find_by(account_number: @account_number)
        account_value = 0
        transactions = account.transactions.where(created_at:((Time.now - 3.hours).beginning_of_month..Time.now))
        if transactions.length > 0
            prev_amount = get_last_calculated_balance(transactions[0], account)
            prev_date = 1 
            for index in (0..transactions.length-1)
                current_date = transactions[index].created_at.strftime("%d").to_i
                if(index != transactions.length-1 && current_date != transactions[index+1].created_at.strftime("%d").to_i)
                    account_value += (current_date - prev_date) * prev_amount
                end
                prev_date = current_date
                prev_amount = transactions[index].current_balance 
            end
            account_value += (@month_days - prev_date + 1) * prev_amount
        else
            prev_amount = get_last_calculated_balance(nil, account) 
            account_value += prev_amount * @month_days
        end
        account_value
    end

    def get_last_calculated_balance(first_transaction, account)
        all_transactions = account.transactions
        if all_transactions[0]  == first_transaction 
            return 0
        else
            if first_transaction.nil?
                return all_transactions.last.current_balance
            else
                ind = all_transactions.find_index(first_transaction)
                return all_transactions[ind-1].current_balance
            end
        end
    end

end