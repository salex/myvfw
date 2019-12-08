class AddColToMarkup < ActiveRecord::Migration[6.0]
  def change
    add_column :markups, :leadin, :string
    add_column :markups, :date, :date
  end
end
