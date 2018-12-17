class AddMpIdToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :mp_id, :string
  end
end
