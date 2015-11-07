require 'csv'
require "pry"

class TransactionLoader

  def load_all(file ="./data/transactions.csv")
    CSV.open(file, headers: true, header_converters: :symbol)
  end

end
