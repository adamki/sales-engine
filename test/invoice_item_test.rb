require 'simplecov'
# SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'csv'
require_relative "../lib/invoice_item"
require_relative "../lib/sales_engine"

class InvoiceItemTest < Minitest::Test

  attr_reader :engine, :repository

  def setup
    @engine = SalesEngine.new("./test/fixtures")
    engine.startup
    @repository = engine.invoice_item_repository
  end

  def test_it_can_access_id
    invoice_item = repository.find_by_id(1)
    assert_equal 1 , invoice_item.id
  end

  def test_it_can_access_item_id
    invoice_item = repository.find_by_id(1)
    assert_equal 539, invoice_item.item_id
  end

  def test_it_can_access_invoice_id
    invoice_item = repository.find_by_id(8)
    assert_equal 1, invoice_item.invoice_id
  end

  def test_it_can_access_by_quantity
    invoice_item = repository.find_by_id(1)
    assert_equal 5, invoice_item.quantity
  end

  def test_it_can_access_by_unit_price
    invoice_item = repository.find_by_id(1)
    assert_equal 136.35, invoice_item.unit_price.to_f / 100
  end

  def test_it_can_access_by_creation_date
    invoice_item = repository.find_by_id(20)
    assert_equal "2012-03-27 14:54:10 UTC", invoice_item.created_at
  end

  def test_it_can_access_by_updated_date
    invoice_item = repository.find_by_id(20)
    assert_equal "2012-03-27 14:54:10 UTC", invoice_item.updated_at
  end

  def test_it_can_return_an_instance_of_invoice
    invoice_item = repository.find_by_invoice_id(1)
    invoices = invoice_item.invoice
    assert_equal 1, invoice_item.id
  end

  def test_it_can_return_an_instance_of_item
    invoice_item = repository.find_by_item_id(4)
    item = invoice_item.item
    assert_equal "Item Nemo Facere", item.name
  end

end
