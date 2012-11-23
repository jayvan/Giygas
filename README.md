Giygas
======

Giygas is a web based application that crawls a Guild Wars 2 database and the Guild Wars 2 market and displays profitable crafting recipes.

Setup
=====

1. Clone this repository

2. Run `bundle install` to get all of the gems

3. Set up your config/database.yml and gemfile for the database you want to use. I use Postgres since that's what the production environment runs on.

4. run `rake db:create; rake db:migrate`

5. run `rails server` to launch the server

Crawling data
=============

Note: I developed this quite a while ago, and while it worked very well, I prefer doing dungeons with friends to make gold instead of crafting. The APIs for the marketplace may have changed, so these instructions may or may not be successfull for you. If you do find you have to tweak the scrape scripts, please send a pull request so that others can scrape easily!

Recipes
-------

Run `rake scrape_recipes` to fetch all of the recipes

Prices
------

Set your GW2_EMAIL and GW2_PASSWORD environment variables to your Guild Wars 2 email and password respectively. Then run `rake scrape_prices`.
