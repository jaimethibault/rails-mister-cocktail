class AddApikeyToCocktails < ActiveRecord::Migration[5.0]
  def change
    add_column :cocktails, :apikey, :string
  end
end
