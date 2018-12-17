class AddMpIdToSubscriptions < ActiveRecord::Migration[5.1]
  def change
    add_column :subscriptions, :mp_id, :string
  end
end
