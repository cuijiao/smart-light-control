class AddFieldsIntoLightsTable < ActiveRecord::Migration
  def change
    add_column :lights, :chip_id, :integer
    add_column :lights, :chip_port, :integer
  end
end
