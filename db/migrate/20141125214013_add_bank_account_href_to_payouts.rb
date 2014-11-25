class AddBankAccountHrefToPayouts < ActiveRecord::Migration
  def change
    add_column :payouts, :bank_account_href, :string
  end
end
