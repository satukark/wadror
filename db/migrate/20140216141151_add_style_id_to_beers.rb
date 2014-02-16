class AddStyleIdToBeers < ActiveRecord::Migration
  def change
		rename_column :beers, :style_id, :style
  end
end
