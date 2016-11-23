class ChangeStatusType < ActiveRecord::Migration
  def up
    change_column_default(:lights, :status, nil)
    execute "ALTER TABLE lights ALTER COLUMN status TYPE integer USING CASE status WHEN 'on' THEN 1 ELSE 0 END"
  end

  def down
  end
end
