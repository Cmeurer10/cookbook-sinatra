require 'csv'
require_relative 'recipe.rb'

class Cookbook
  attr_reader :recipes
  def initialize(csv_filepath)
    @csv_filepath = csv_filepath
    @recipes = []
    CSV.foreach(@csv_filepath) do |row|
      @recipes << Recipe.new(*row)
    end
  end

  def all
    return @recipes
  end

  def add_recipe(recipe)
    @recipes << recipe
    update_csv
  end

  def remove_recipe(recipe_index)
    @recipes.delete_at(recipe_index)
    update_csv
  end

  def mark_as_tested(recipe_index)
    @recipes[recipe_index].tested!
    update_csv
  end

  def display_full_recipe(recipe_index)
    View.display(@recipes[recipe_index].description)
  end

  private

  def update_csv
    CSV.open(@csv_filepath, 'w') do |writer|
      @recipes.each do |rec|
        writer << [rec.name, rec.description, rec.difficulty, rec.prep_time, rec.cooking_time, rec.tested]
      end
    end
  end
end
