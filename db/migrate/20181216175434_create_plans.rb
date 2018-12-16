class CreatePlans < ActiveRecord::Migration[5.1]
  def change
    create_table :plans do |t|
      t.string :description
      t.integer :frequency
      t.string :frequency_type
      t.float :transaction_amount

      t.timestamps
    end
  end
end
