class CreatePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments do |t|
      t.integer :amount
      t.belongs_to :projects, foreign_key: true
      t.integer :creator_id, index: true

      t.timestamps
    end
  end
end