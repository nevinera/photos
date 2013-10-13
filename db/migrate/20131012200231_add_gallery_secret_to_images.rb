class AddGallerySecretToImages < ActiveRecord::Migration
  def change
    add_column :images, :gallery_secret, :string
  end
end
