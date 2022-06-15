class User < ActiveRecord::Base
  has_many :accounts
  has_many :banks, through: :accounts

  # returns one user instance for the user who has the highest total account balances Advanced
  def self.number_one
    # get hash with user_id keys and sum balance values
    balances_by_user = Account.group(:user_id).sum(:balance) 
    # get the user id of the user with the highest total account balance
    user_id_with_highest_balance = balances_by_user.max.first
    # get the user that matches the id from the previous step
    User.find(user_id_with_highest_balance)
    # user_id_with_highest_balance = Account.group(:user_id).sum(:balance).max.first
    # User.find(user_id_with_highest_balance)
  end

  def total_balance
    self.accounts.sum(:balance)
  end

  def balance_by_account_type(account_type)
    self.accounts.where(account_type: account_type).sum(:balance)
  end

  def main_banks
    # naive solution without full AR support
=begin
    amounts_by_balance = {}
    self.accounts.each do |account|
      if amounts_by_balance[account.bank_id]
        amounts_by_balance[account.bank_id] += account.balance
      else
        amounts_by_balance[account.bank_id] = account.balance
      end
    end
=end
    # AR Query based solution
    accounts_by_balance = self.accounts.group(:bank_id).sum(:balance)

=begin
    either way, we end up with a hash containing
    bank ids as keys and the total balance 
    deposited in that bank as values
    so we filter only those whose balance is 
    greater than 30000 and the keys are the
    corresponding bank ids
=end
    main_bank_ids = accounts_by_balance.filter do |bank_id, balance|
      balance > 30000
    end.keys
    # Return all banks where the id is one of the ids above
    Bank.where(id: main_bank_ids)
  end


  def international_funds
=begin
    We want to get accounts back, but we 
    need inforation about the bank the 
    account belongs to. To get it, we can
    use the includes method and pass in bank.
    From there, we can add a where clause.
    In this case, we want accounts at banks
    not in the user's country of residence. 
    Once we have those, we can calculate the 
    sum of their balances
=end
    international_banks = Bank.where.not(country: country_of_residence)
    self.accounts.where(bank: international_banks).sum(:balance)
  end
end