require 'csv'
require "pry"

class InvoiceItemLoader

  def load_all(file ="./data/invoice_items.csv")
    CSV.open(file, headers: true, header_converters: :symbol)
  end

end
