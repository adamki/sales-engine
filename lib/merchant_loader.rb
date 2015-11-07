require 'csv'
require "pry"

class MerchantLoader

  def load_all(file ="./data/merchants.csv")
    CSV.open(file, headers: true, header_converters: :symbol)
  end

end
