class AddSeqToOfficer < ActiveRecord::Migration[6.0]
  def change
    add_column :officers, :seq, :integer
  end
end
