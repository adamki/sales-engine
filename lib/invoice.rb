require 'date'

class Invoice
  attr_reader :id,
              :customer_id,
              :merchant_id,
              :status,
              :created_at,
              :updated_at,
              :repository

  def initialize(parameters, repository)
    @id             = parameters[:id].to_i
    @customer_id    = parameters[:customer_id].to_i
    @merchant_id    = parameters[:merchant_id].to_i
    @status         = parameters[:status]
    @created_at     = Date.parse(parameters[:created_at])
    @updated_at     = Date.parse(parameters[:updated_at])
    @repository     = repository
  end

  def transactions
    repository.find_transactions_for_invoice(id)
  end

  def merchant
    repository.find_merchant_for_invoice(merchant_id)
  end

  def invoice_items
    repository.find_invoice_item_by_invoice_id(id)
  end

  def items
    item_id = invoice_items
    repository.find_item_by_invoice_item_id(item_id)
  end

  def customer
    repository.find_customer_by_invoice(customer_id)
  end

  def charge(input)
    repository.charge_credit_card(input, id)
  end

  def revenue
    invoice_items.reduce(0) do |acc , ii|
      acc + ii.total_price
    end
  end


end
