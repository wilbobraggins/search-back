class CreateLookups < ActiveRecord::Migration[5.2]
  def change
    create_table :lookups do |t|
      t.text :search
      t.string :url
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
