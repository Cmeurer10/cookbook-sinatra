require 'nokogiri'
require 'open-uri'

def scrape_online_cookbook(food, diff)
  if diff == 0
    file = "http://www.letscookfrench.com/recipes/find-recipe.aspx?aqt=#{food}"
  else
    file = "http://www.letscookfrench.com/recipes/find-recipe.aspx?aqt=#{food}&dif=#{diff}"
  end
  doc = Nokogiri::HTML(open(file))
  recipe_names = []
  doc.search(".m_titre_resultat").each do |ele|
    recipe_names << "#{ele.text.strip.downcase.gsub(' ', '_')}"
  end
  descriptions = []
  doc.search(".m_texte_resultat").each do |ele|
    descriptions << "#{ele.text.strip}"
  end
  difficulties = []
  doc.search(".m_detail_recette").each do |ele|
    difficulties << "#{ele.text.strip.downcase.match(/very\seasy|easy|moderate|difficult/)[0]}"
  end
  cooking_times = []
  prep_times = []
  doc.search(".m_detail_time").each do |ele|
    time_details = ele.text.strip.downcase.scan(/\d{1,3}/)
    prep_times << "#{time_details[0]} min"
    cooking_times << "#{time_details[1] ? time_details[1] : 0} min"
  end

  recipes = {}
  recipe_names.each_with_index do |ele, ind|
    recipes[ele] = { description: descriptions[ind],
                     difficulty: difficulties[ind],
                     prep_time: prep_times[ind],
                     cooking_time: cooking_times[ind] }
  end
  return recipes
end
