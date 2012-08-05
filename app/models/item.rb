class Item < ActiveRecord::Base
  attr_accessible :buy_value, :name, :sell_value, :rarity_id, :level
  has_and_belongs_to_many :recipes
  has_many :items_recipes, :dependent => :destroy
  belongs_to :rarity

  def api_url
    query = "https://tradingpost-live.ncplatform.net/ws/search.json?text=#{name}&levelmin=#{level || 0}&levelmax=#{level || 80}"
    if rarity.present?
      query += "&rarity=#{rarity.value}"
    end

    return query
  end
end
