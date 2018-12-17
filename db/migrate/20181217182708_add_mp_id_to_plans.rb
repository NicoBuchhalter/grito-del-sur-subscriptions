class AddMpIdToPlans < ActiveRecord::Migration[5.1]
  def change
    add_column :plans, :mp_id, :string
  end
end
