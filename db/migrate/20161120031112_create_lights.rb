class CreateLights < ActiveRecord::Migration
  def up
    create_table :lights do |t|
      t.string :section
      t.integer :light_id
      t.string :status, default: 'off'

      t.timestamps null: false
    end
  end

  def down
    drop_table :lights
  end
end
