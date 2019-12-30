class AddExpiresToMarkup < ActiveRecord::Migration[6.0]
  def change
    add_column :markups, :expires, :date
  end
end
