class AddCategoryIdToCategories < ActiveRecord::Migration
  def change
    add_column :forem_categories, :category_id, :integer
    add_index :forem_categories, :category_id
  end
end
