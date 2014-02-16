class RemoveColumnFromBeer < ActiveRecord::Migration
  def change
      remove_column :beers, :oldstyle_
  end
end
