require 'date'
require 'bigdecimal'

class Item

  attr_reader :id,
              :name,
              :description,
              :unit_price,
              :merchant_id,
              :created_at,
              :updated_at,
              :repository

  def initialize(parameters, repository)
    @id           = parameters[:id].to_i
    @name         = parameters[:name]
    @description  = parameters[:description]
    @unit_price   = BigDecimal.new(parameters[:unit_price])
    @merchant_id  = parameters[:merchant_id].to_i
    @created_at     = Date.parse(parameters[:created_at])
    @updated_at     = Date.parse(parameters[:updated_at])
    @repository   = repository

  end

  def merchant
    repository.find_merchant_by_item(merchant_id)
  end

  def invoice_items
    repository.find_invoice_items_by_item(id)
  end

  def find_invoices
    invoice_items.map do |invoice_item|
      invoice_item.invoice
    end
  end

  def invoice_dates
    find_invoices.map do |invoice|
      invoice.created_at
    end
  end



  def invoice_date_calculator
    invoice_dates.inject(Hash.new(0)) do |hash, date|
      hash[date] += 1; hash
    end
  end

  def best_day
    best_day = invoice_date_calculator.max_by do |date, calc|
      calc
    end
    best_day[0]
  end


  def invoice_items
    repository.find_all_invoice_items_by_item_id(id)
  end

  def invoices
    invoice_items.flat_map do |invoice_item|
      repository.find_all_invoice_items_by_item_id(invoice_item.id)
    end.uniq
  end

  def transactions
    invoices.flat_map do |invoice|
      repository.find_all_transactions_by_invoice_id(invoice.id)
    end
  end

  def successful_transactions
    transactions.select {|transaction| transaction.success?}
  end

  def successful_invoices
    successful_transactions.flat_map do |transaction|
      repository.find_all_invoices_by_invoice_id(transaction.invoice_id)
    end
  end

  def successful_invoice_items
    successful_invoices.flat_map do |invoice|
      repository.find_all_invoice_items_by_item_id(invoice.id)
    end
  end

  def filtered_invoice_items
    successful_invoice_items.select do |invoice_item|
      invoice_item.item_id == id
    end
  end

  def total_revenue
    filtered_invoice_items.inject(0) do |total, invoice_item|
      total += invoice_item.total
      total
    end
  end

end
