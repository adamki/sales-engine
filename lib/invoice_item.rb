class InvoiceItem
  attr_reader :id,
              :item_id,
              :invoice_id,
              :quantity,
              :unit_price,
              :created_at,
              :updated_at,
              :repository,
              :total

  def initialize(parameters, repository)
    @id             = parameters[:id].to_i
    @item_id        = parameters[:item_id].to_i
    @invoice_id     = parameters[:invoice_id].to_i
    @quantity       = parameters[:quantity].to_i
    @unit_price     = BigDecimal.new((parameters[:unit_price].to_i))/100
    @created_at     = Date.parse(parameters[:created_at]).to_date
    @updated_at     = Date.parse(parameters[:updated_at]).to_date
    @repository     = repository
    @total          =( @unit_price * @quantity)
  end

  def invoice
    repository.find_invoices_by_id(invoice_id)
  end

  def item
    repository.find_item_by_invoice(item_id).last
  end

  def total_price
    quantity * (unit_price / 100)
  end

end
