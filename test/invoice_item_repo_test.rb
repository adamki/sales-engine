require 'bigdecimal'
require 'simplecov'
# SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'csv'
require_relative '../lib/invoice_item'
require_relative '../lib/invoice_item_loader'
require_relative "../lib/sales_engine"

class InvoiceItemRepositoryTest < Minitest::Test

  attr_reader :engine, :repository

  def setup
    @engine = SalesEngine.new("./test/fixtures")
    engine.startup
    @repository = engine.invoice_item_repository
  end

  def test_it_finds_all_invoice_items
    result = repository.invoice_items
    assert_equal result, repository.find_all
    assert_equal Hash, result.class
  end

  def test_it_can_find_by_id
    result = repository.invoice_items["2"]
    assert_equal result, repository.find_by_id(2)
  end

  def test_it_can_find_by_item_id
    result = repository.invoice_items["1"]
    assert_equal result, repository.find_by_item_id(539)
  end

  def test_it_can_find_by_invoice_id
    result = repository.invoice_items["13"]
    assert_equal result, repository.find_by_invoice_id(3)
  end

  def test_it_can_find_by_quantity
    result = repository.invoice_items["21"]
    assert_equal result, repository.find_by_quantity(2)
  end

  def test_it_can_find_by_unit_price
    skip
    result = repository.invoice_items["21"]
    assert_equal result, repository.find_by_unit_price(BigDecimal.new("42203").to_f / 100)
  end

  def test_it_can_find_by_updated_date
    result = repository.invoice_items["1"]
    assert_equal result, repository.find_by_updated_date("2012-03-27 14:54:09 UTC")
  end

  def test_it_can_find_by_creation_date
    result = repository.invoice_items["1"]
    assert_equal result, repository.find_by_creation_date("2012-03-27 14:54:09 UTC")
  end

  def test_it_can_find_all_by_invoice_id
    assert_equal 8, repository.find_all_by_invoice_id(1)[0..19].count
  end

  def test_it_can_find_all_by_quantity
    assert_equal 1, repository.find_all_by_quantity(2)[0..19].count
  end

  def test_it_can_find_all_by_unit_price
    skip
    assert_equal 3, repository.find_all_by_unit_price(BigDecimal("72018")/100).to_f[0..19].count
  end

  def test_it_can_find_all_by_creation_date
    assert_equal 15, repository.find_all_by_creation_date("2012-03-27 14:54:09 UTC")[0..19].count
  end

  def test_it_can_find_all_by_updated_date
    assert_equal 15, repository.find_all_by_updated_date("2012-03-27 14:54:09 UTC")[0..19].count
  end

  def test_it_can_return_a_collection_of_invoices

  end

end
