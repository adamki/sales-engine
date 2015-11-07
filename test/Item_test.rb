require 'simplecov'
# SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'csv'
require 'bigdecimal'
require_relative "../lib/item"
require_relative "../lib/sales_engine"

class ItemTest < Minitest::Test

  attr_reader :engine, :repository

  def setup
    @engine = SalesEngine.new("./test/fixtures")
    engine.startup
    @repository = engine.item_repository
  end

  def test_it_can_access_id
		item = repository.find_by_id(1)
    assert_equal 1 , item[0].id
  end

  def test_it_can_access_item_name
    item = repository.find_by_name("Item Qui Esse")
    result = 1
    assert_equal result, item.id
  end

  def test_if_can_access_item_decription
    result = "Nihil autem sit odio inventore deleniti. Est laudantium ratione distinctio laborum. Minus voluptatem nesciunt assumenda dicta voluptatum porro."
    item = repository.find_by_description(result)
    assert_equal result, item.description
  end

  def test_it_can_access_item_unit_price
    price = BigDecimal.new("751.07")
    item = repository.find_by_unit_price(price)
    assert_equal 1, item.id
  end

  def test_it_can_access_item_merchant_id
    item = repository.find_by_merchant_id(1)
    assert_equal 1, item.id
  end

  def test_it_can_access_item_creation_date
    result = "2012-03-27 14:53:59 UTC"
    item = repository.find_by_creation_date(result)
    assert_equal 1, item.id
  end

  def test_it_can_access_item_upated_date
    result = "2012-03-27 14:53:59 UTC"
    item = repository.find_by_updated_date(result)
    assert_equal 1, item.id
  end

  def test_it_returns_a_merchant_associated_with_item
    item = repository.find_by_merchant_id(1)
    merchants = item.merchant
    assert_equal "Schroeder-Jerde", merchants.name
  end

  def test_invoice_dates
    item = repository.find_by_id(1)
    assert_equal Array, item[0].find_invoices.class
  end

  def test_invoice_date_calculator
    @engine = SalesEngine.new("./data")
    engine.startup
    item = repository.find_by_id(2)
    assert_equal 0, item[0].invoice_date_calculator.count
  end

end
