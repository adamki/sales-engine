require 'simplecov'
# SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'csv'
require_relative "../lib/invoice"
require_relative "../lib/sales_engine"

class InvoiceTest < Minitest::Test

  attr_reader :engine, :repository

  def setup
    @engine = SalesEngine.new("./test/fixtures")
    engine.startup
    @repository = engine.invoice_repository
  end

  def test_it_can_access_id
    invoice = repository.find_by_id(1)
    assert_equal 1 , invoice.id
  end

  def test_it_can_access_customer_id
    invoice = repository.find_by_id(8)
    assert_equal 1, invoice.customer_id
  end

  def test_it_can_access_merchant_id
    invoice = repository.find_by_merchant_id(38)
    assert_equal 38, invoice.merchant_id
  end

  def test_it_finds_invoices_by_customer_id
    assert_equal "Joey", repository.find_customer_by_id(1).first_name
  end

  def test_it_returns_a_collection_of_associated_transaction_instances
    invoice = repository.find_by_id(12)
    transactions = invoice.transactions
    assert_equal [11, 12 ,15], transactions.map {|invoice| invoice.id}
  end

  def test_it_returns_a_merchant_associated_with_an_invoice_id
    invoice = repository.find_by_id(21)
    merchant = invoice.merchant
    assert_equal "Pollich and Sons", merchant.name
  end

  def test_it_can_return_a_collection_of_associated_invoiceitems
    invoice = repository.find_by_id(1)
    invoice_item = invoice.invoice_items
    assert_equal 8, invoice.invoice_items.count
  end

  def test_it_can_return_a_collection_of_associated_items_by_way_of_invoice_items
    invoice = repository.find_by_id(4)
    invoice_item = invoice.items
    assert_equal Array, invoice_item.class
  end

  def test_it_can_return_an_instance_of_customer_for_id
    invoice = repository.find_by_customer_id(1)
    invoice_customer = invoice.customer
    assert_equal "Joey", invoice_customer.first_name
  end

end
