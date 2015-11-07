require_relative 'item'
require_relative './item_loader'

class ItemRepository

  attr_reader :items, :sales_engine

  def initialize(rows, sales_engine)
    @items ||= load_items(rows)
    @sales_engine = sales_engine
  end

  def load_items(rows)
    @items = Hash.new(0)
    rows.map { |row|
       @items[row[:id]] = Item.new(row, self) }
    @items
  end

  def find_all
    items
  end

  def random
    items.values.sample
  end

  def find_by_id(id)
    matches = items.select {|key, value| value.id == id }.to_a
    matches.map {|key, value| value}
  end

  def find_by_name(name)
    items.detect { |key, value| value.name == name}.last
  end

  def find_by_description(description)
    items.detect { |key, value| value.description == description}.last
  end

  def find_by_unit_price(unit_price)
    items.detect do |key, value|
      (value.unit_price) /100 == unit_price
    end.last
  end

  def find_by_merchant_id(merchant_id)
    items.detect { |key, value| value.merchant_id == merchant_id }.last
  end

  def find_by_creation_date(date)
    items.detect { |key, value| value.created_at == date }.last
  end

  def find_by_updated_date(date)
    items.detect { |key, value| value.created_at == date }.last
  end

  def find_all_by_name(name)
    matches = items.select {|key, value| value.name.downcase == name.downcase }
    matches.map {|key, value| value}
  end

  def find_all_by_description(description)
    matches = items.select {|key, value| value.description.downcase == description.downcase }
    matches.map {|key, value| value}
  end

  def find_all_by_unit_price(unit_price)
    matches = items.select {|key, value| value.unit_price == unit_price.to_s}
    matches.map {|key, value| value}
  end

  def find_all_by_merchant_id(merchant_id)
    matches = items.select do |key, value|
      value.merchant_id == merchant_id
    end
    matches.map {|key, value| value}
  end

  def find_all_by_creation_date(created_at)
    matches = items.select {|key, value| value.created_at == created_at }.to_a
    matches.map {|key, value| value}
  end

  def find_all_by_updated_date(updated_at)
    matches = items.select {|key, value| value.updated_at == updated_at }.to_a
    matches.map {|key, value| value}
  end

  def find_merchant_by_item(merchant_id)
    sales_engine.find_merchant_by_item(merchant_id)
  end

  def find_invoice_items_by_item(id)
    sales_engine.find_invoice_items_by_item(id)
  end

  def inspect
    "#<#{self.class} #{@items.size} rows>"
  end

  def find_all_invoice_items_by_item_id(id)
    sales_engine.find_invoice_items_by_item(id)
  end

  def find_all_invoice_items_by_invoice_id(id)
    sales_engine.find_all_invoice_items_by_invoice_id(id)
  end

  def find_all_transactions_by_invoice_id(id)
    sales_engine.find_transactions_for_invoice(id)
  end

  def find_all_invoices_by_invoice_id(id)
    sales_engine.find_invoices_by_id(id)
  end
  def get_all_in_array
    find_all.map { |_, merchant| merchant}
  end

  def most_revenue(x)
    get_all_in_array.max_by(x){|item| item.total_revenue}
  end

end
