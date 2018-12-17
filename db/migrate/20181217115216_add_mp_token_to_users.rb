class AddMpTokenToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :mp_token, :string
  end
end
