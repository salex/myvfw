class CreateStashes < ActiveRecord::Migration[6.0]
  def change
    create_table :stashes do |t|
      t.references :post, null: false, foreign_key: true
      t.string :type
      t.string :key
      t.date :date
      t.text :hash_data
      t.text :array_data
      t.text :text_date

      t.timestamps
    end
  end
end
