require 'csv'
require "pry"

class ItemLoader

  def load_all(file ="./data/items.csv")
    CSV.open(file, headers: true, header_converters: :symbol)
  end

end
