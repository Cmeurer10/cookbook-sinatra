require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require_relative("cookbook.rb")
require_relative('view.rb')
require_relative('parsing.rb')
require "csv"

csv_file   = File.join(__dir__, 'recipes.csv')
$cookbook  = Cookbook.new(csv_file)

set :bind, '0.0.0.0'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

# index page
get '/' do
  @recipes = View.list($cookbook.all)
  erb :index
end

# Deleting a recipe
get '/recipes/delete' do
  @recipes = View.list($cookbook.all)
  erb :delete
end

get '/recipes/delete/:ind' do
  index = params[:index].to_i
  $cookbook.remove_recipe(index)
  redirect "/"
end

# Marking a recipe as tested
get '/recipes/mark' do
  @recipes = View.list($cookbook.all)
  erb :mark
end

get '/recipes/mark/:ind' do
  index = params[:index].to_i
  $cookbook.mark_as_tested(index)
  redirect "/"
end

# Search for a new recipe
get '/recipes/search' do
  erb :search_form
end

post '/search' do
  ingredient = params[:ingredient]
  difficulty = params[:difficulty]
  if difficulty.respond_to?('to_i') && ((0..4).include? difficulty.to_i)
    recipe_hash = scrape_online_cookbook(ingredient, difficulty)
    recipes = []
    recipe_hash.each do |k, v|
      k = k.split('_').map{ |ele| ele.capitalize }.join(' ')
      recipes << Recipe.new(k, v[:description], v[:difficulty], v[:prep_time], v[:cooking_time])
      recipes.each { |recipe| $cookbook.add_recipe(recipe) }
    end
  else
    redirect '/'
  end
  redirect '/'
end
