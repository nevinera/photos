class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.integer :gallery_id
      t.string :original_name
      t.integer :original_size
      t.integer :position
      t.timestamps
    end
    add_index :images, [:gallery_id, :position], :unique
  end
end
