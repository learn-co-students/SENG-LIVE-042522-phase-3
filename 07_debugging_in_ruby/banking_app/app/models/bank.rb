class Bank < ActiveRecord::Base
  has_many :accounts
  has_many :users, through: :accounts

  def open_account(user, label, account_type, opening_deposit)
    Account.create(
      balance: opening_deposit,
      label: label,
      account_type: account_type,
      user_id: user.id,
      bank_id: self.id
    )
  end

  def accounts_summary(user)
    self.accounts.where(user: user).map(&:summary)
  end

  def blacklist(user)
    Account.where(user_id: user.id, bank_id: self.id).destroy_all
  end
end