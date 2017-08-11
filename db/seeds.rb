require 'open-uri'
require 'json'

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts 'Cleaning database...'
puts 'Cleaning doses...'
Dose.destroy_all
puts 'Cleaning ingredients...'
Ingredient.destroy_all
puts 'Cleaning cocktails...'
Cocktail.destroy_all

puts 'Creating ingredients...'
url = 'http://www.thecocktaildb.com/api/json/v1/1/list.php?i=list'
ingredient_list_serialized = open(url).read
ingredient_list = JSON.parse(ingredient_list_serialized)
ingredient_list["drinks"].each do |ingredient|
  Ingredient.create(name: ingredient["strIngredient1"].downcase)
end
# creating missing ingredients from API by hand
missing_ingr = ["daiquiri mix", "carrot", "pina colada mix", "maraschino liqueur", "olive brine", "pineapple syrup", "aperol", "olive"]
missing_ingr.each do |ing_name|
  Ingredient.create(name: ing_name)
end
puts 'Ingredients created...'

puts 'Creating cocktails...'
url = 'http://www.thecocktaildb.com/api/json/v1/1/filter.php?c=Cocktail'
cocktail_list_serialized = open(url).read
cocktail_list = JSON.parse(cocktail_list_serialized)
cocktail_list["drinks"].each do |cocktail|
  unless (cocktail["strDrinkThumb"].nil? || cocktail["idDrink"].nil?)
    c = Cocktail.new(name: cocktail["strDrink"], apikey: cocktail["idDrink"])
    c.remote_photo_url = cocktail["strDrinkThumb"]
    c.save
  end
end
puts 'Cocktails created...'

puts 'Creating doses...'
#loop on the cocktails present in the DB
Cocktail.all.each do |cocktail|
  #for each cocktail:
  #get its apikey
  key = cocktail.apikey
  #call the API with this ID
  url = "http://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=#{key}"
  dose_list_serialized = open(url).read
  dose_list = JSON.parse(dose_list_serialized)["drinks"].first
  #create dose i
  for i in (1..3) do
    unless (dose_list["strMeasure#{i}"].strip.nil? || dose_list["strIngredient#{i}"].strip.nil? || dose_list["strIngredient#{i}"].strip == "")
      description = dose_list["strMeasure#{i}"]
      cocktail_id = cocktail.id
      ingredient_name = dose_list["strIngredient#{i}"].downcase
      ingredient_id = Ingredient.find_by(name: ingredient_name).id
      Dose.create(description: description, cocktail_id: cocktail_id, ingredient_id: ingredient_id)
    end
  end

end

puts 'Doses created...'

