class CreateGalleries < ActiveRecord::Migration
  def change
    create_table :galleries do |t|
      t.string :name
      t.string :client
      t.date :date
      t.text :notes
      t.string :original_name

      t.string :secret
      t.string :fragment

      t.timestamps
    end
    add_index :galleries, [:secret], :name => "index_galleries_on_secret", :unique => true
    add_index :galleries, [:date],   :name => "index_galleries_on_date"
  end
end
