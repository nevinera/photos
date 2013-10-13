class AddStateToGalleries < ActiveRecord::Migration
  def change
    add_column :galleries, :state, :string, :default => 'waiting'
  end
end
