class AddEmailConfirmedToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :email_confirmed, :boolean, null: false, default: false
  end
end
