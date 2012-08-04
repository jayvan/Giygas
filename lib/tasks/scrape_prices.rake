desc 'Scrape gw2 marketplace for recipe data'
task :scrape_recipes => :environment do
  if ENV['email'].blank? or ENV['password'].blank?
    puts "You must specify an email address and password"
    exit
  end
  start_crawl
end

def start_crawl
  @agent = Mechanize.new
  page = @agent.get('https://tradingpost-live.ncplatform.net/login')
  login_form = page.form_with :class => "login-panel"
  login_form.field_with(:name => "email").value = ENV['email']
  login_form.field_with(:name => "password").value = ENV['password']
  page = agent.submit login_form
end
