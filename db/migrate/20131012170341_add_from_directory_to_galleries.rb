class AddFromDirectoryToGalleries < ActiveRecord::Migration
  def change
    add_column :galleries, :from_directory, :string
  end
end
