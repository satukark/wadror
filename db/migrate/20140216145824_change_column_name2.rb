class ChangeColumnName < ActiveRecord::Migration
  def change
  rename_column :beers, :style, :style_id
  end
end
