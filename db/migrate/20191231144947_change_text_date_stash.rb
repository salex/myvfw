class ChangeTextDateStash < ActiveRecord::Migration[6.0]
  def change
    rename_column :stashes, :text_date, :text_data
  end
end
