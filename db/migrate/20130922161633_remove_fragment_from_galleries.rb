class RemoveFragmentFromGalleries < ActiveRecord::Migration
  def change
    remove_column :galleries, :fragment
  end
end
