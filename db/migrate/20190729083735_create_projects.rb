# frozen_string_literal: true

class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.string :name
      t.references :client, foreign_key: true, index: true

      t.timestamps
    end
  end
end
