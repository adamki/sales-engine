require "date"
require 'bigdecimal'

class Merchant

  attr_reader :id,
              :name,
              :created_at,
              :updated_at,
              :repository


  def initialize(parameters, repository)
    @id                             = parameters[:id].to_i
    @name                           = parameters[:name]
    @created_at                     = Date.parse(parameters[:created_at])
    @updated_at                     = Date.parse(parameters[:updated_at])
    @repository                     = repository
  end

  def items
    repository.find_items_for_merchant(id)
  end

  def invoices
    repository.find_invoices_for_merchant(id)
  end

  def total_revenue
    successful_invoices.flat_map do |invoice|
      invoice.invoice_items.flat_map do |invoice_item|
        # (invoice_item.unit_price * invoice_item.quantity.to_i) / 100
        invoice_item.total 
      end
    end.reduce(:+)
  end

  def successful_invoices_items_by_date(date)
    successful_invoices_by_date(date).flat_map do |invoice|
      invoice.invoice_items
    end
  end

  def revenue_by_date(date)
    successful_invoices_items_by_date(date).inject(0) do |total,invoice_item|
      total += invoice_item.total
      total
    end
  end



  def successful_invoices
    # invoices.select {|invoice| invoice.transactions.any?{|transaction| transaction.success?}}
    successful_transactions.flat_map {|transaction| repository.find_all_invoices_by_invoice_id(transaction.invoice_id)}
  end

  def transactions
    invoices.flat_map {|invoice| repository.find_all_transactions_by_invoice_id(invoice.id)}
  end

  def successful_transactions
    transactions.select {|transaction| transaction.success? }
  end

  def unsuccessful_invoices(invoice_collection)
    invoice_collection.select {|invoice| invoice.transactions.any?{|transaction| transaction.result == "failed"}}
  end

  def successful_invoices_by_date(date)
    successful_invoices.select do |invoice|
      invoice.created_at == date
    end
  end

  def revenue(date = nil)
    if date == nil
      total_revenue
    else
      revenue_by_date(date)
    end
  end

  def favorite_customer_id
    a = successful_invoices.map do |invoice|
      invoice.customer_id
    end
    a.uniq.max_by{ |id| a.count( id ) }
  end

  def favorite_customer
    repository.sales_engine.customer_repository.find_by_id(favorite_customer_id)
  end

  def items_sold
    successful_invoices(invoices).flat_map do |invoice|
      invoice.invoice_items.flat_map do |invoice_item|
        invoice_item.unit_price
      end
    end.reduce(:+)
  end

  def most_quantity
    repository.find_quantity_from(successful_invoices).reduce(:+)
  end

  def paid_invoice_items
    successful_invoices.flat_map do |invoice|
      invoice.invoice_items
    end
  end

  def merchant_items_sold
   paid_invoice_items.map do |invoice_item|
     invoice_item.quantity
   end.reduce(:+)
 end

 def pending_invoices
    invoices - successful_invoices
 end

  def customers_with_pending_invoices
    pending_invoices.flat_map do |invoice|
      repository.find_customer_by_customer_id(invoice.customer_id)
    end
  end
end
