# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

set :output, "/log/cron_log.log"

every 1.minute do
    runner "Account.calculate_interest_saving_account_per_month"
end

every 1.month do
    runner "Account.calculate_interest_saving_account_per_month"
end

every 1.month do
    runner "Account.min_transaction_for_current_accounts_per_month"
end

every 1.month do
    runner "Account.calculate_nrv"
end

every 1.day do
    runner "LoanAccountInfo.add_interest_for_loan_accounts"
end