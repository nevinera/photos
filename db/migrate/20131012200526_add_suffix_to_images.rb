class AddSuffixToImages < ActiveRecord::Migration
  def change
    add_column :images, :suffix, :string
  end
end
