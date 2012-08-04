desc 'Scrape wiki.guildwars2.com for recipe data'
task :scrape_recipes => :environment do
  start_crawl
end

def start_crawl
  @agent = Mechanize.new
  # Request the wiki search page for the given profession
  page_number = 1
  recipe_page_url = 'http://www.gw2db.com/recipes?page=%d'
  
  loop do
    page = @agent.get(recipe_page_url % page_number)
    break if page.search(".alert.no-results").any?
    parse_recipe_list(page)
    page_number += 1
  end
end

def parse_recipe_list(page)
  puts "Parsing page: #{page.title}"
  links = page.search(".col-name .listing-icon").map{|link| Mechanize::Page::Link.new(link, @agent, page)}
  level_requirements = page.search("tbody tr td:nth-child(2)").map{|n| n.text.strip.to_i}

  links.each_with_index do |link, index|
    parse_recipe(link.click, level_requirements[index])
  end
end

def parse_recipe(page, level_requirement)
  output_name = page.search(".db-description > .db-summary .db-title").text.gsub("[s]", "").strip
  output_item = Item.where(:name => output_name).first_or_create!
  recipe = Recipe.where(:item_id => output_item.id).first

  if (recipe.present?)
    puts "Already know the recipe for: #{output_name}"
    return
  end

  profession_name = page.search("aside ul li a").text.strip
  profession = Profession.where(:name => profession_name).first_or_create!

  recipe = Recipe.create( :level => level_requirement,
                          :profession_id => profession.id,
                          :item_id => output_item.id)

  ingredients = page.search('.db-ingredient').map{|ingredient| parse_ingredient_name(ingredient.text.strip)}
  puts "New level #{recipe.level} #{profession.name} recipe: #{recipe.item.name}"
  ingredients.each do |ingredient_data|
    ingredient = Item.where(:name => ingredient_data[:name]).first_or_create!
    ItemsRecipes.create(:recipe_id => recipe.id, :item_id => ingredient.id, :quantity => ingredient_data[:quantity])
    puts "  #{ingredient[:name]} x#{ingredient_data[:quantity]}"
  end

end

def parse_ingredient_name(name)
  return {
    :name => ingredient_name(name),
    :quantity => ingredient_quantity(name)}
end

def ingredient_quantity(name)
  if name =~ /^[0-9]*X/
    return name.split("X").first.to_i
  else
    return 1
  end
end

def ingredient_name(name)
  if name =~ /^[0-9]*X/
    name = name[(name.index("X") + 1)..-1]
  end 
  return name.gsub("[s]", "").strip
end
