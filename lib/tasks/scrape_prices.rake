desc 'Scrape gw2 marketplace for recipe data'
task :scrape_prices => :environment do
  if ENV['GW2_EMAIL'].blank? or ENV['GW2_PASSWORD'].blank?
    puts "You must specify an email address and password"
    exit
  end
  crawl_prices
end

def crawl_prices
  @agent = Mechanize.new
  page = @agent.get('https://account.guildwars2.com/login?redirect_uri=http://tradingpost-live.ncplatform.net/authenticate')
  login_form = page.form_with :class => "login-panel"
  login_form.field_with(:name => "email").value = ENV['GW2_EMAIL']
  login_form.field_with(:name => "password").value = ENV['GW2_PASSWORD']
  search_page = @agent.submit login_form
  Item.find_each do |item|
    search_item(item)
  end
end

def search_item(item)
  print "Crawling for #{item.name}..."
  response = @agent.get(item.api_url)
  json = JSON.parse(response.body)
  if json['results'].empty?
    item.sell_value = 0
    item.buy_value = 0
    item.save
    puts " Not available on the marketplace"
  else
    item_data = json['results'][0]
    item.sell_value = item_data['max_offer_unit_price']
    item.buy_value = item_data['min_sale_unit_price']
    item.image_url = item_data['img']
    item.save
    puts " Purchase for #{item.buy_value} -- Sell for #{item.sell_value}"
  end
end
