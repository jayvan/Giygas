desc 'Scrape gw2db for recipe data'
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
    puts "Fetching page \##{page_number}"
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
  output_name = page.search("#tab-creates .t").text.gsub("[s]", "").strip
  rarity_name = page.search("#tab-creates .gwitem").attribute('class').value.split(' ')[1].split('-').last
  rarity = Rarity.where(:name => rarity_name).first_or_create!
  profession_name = page.search("aside ul li a").text.strip
  profession = Profession.where(:name => profession_name).first_or_create!
  item_level = page.search(".//dd[@class='db-requiredLevel']").text.split(":").last.to_i
  output_item = Item.where(:name => output_name, :rarity_id => rarity.id, :level => item_level).first_or_create!
  recipe = Recipe.where(:item_id => output_item.id, :profession_id => profession.id).first

  if (recipe.present?)
    puts "Already know the recipe for: #{output_name}"
    return
  end

  recipe = Recipe.create( :level => level_requirement,
                          :profession_id => profession.id,
                          :item_id => output_item.id)

  ingredients = page.search('.db-ingredient').map{|ingredient| parse_ingredient_name(ingredient.text.strip)}
  puts "New level #{recipe.level} #{profession.name} recipe: #{recipe.item.name} lvl #{recipe.item.level} - #{recipe.item.rarity.name}(#{recipe.item.rarity.value})"
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
