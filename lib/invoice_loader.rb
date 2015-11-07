require 'csv'
require "pry"

class InvoiceLoader

  def load_all(file ="./data/invoices.csv")
    CSV.open(file, headers: true, header_converters: :symbol)
  end

end
