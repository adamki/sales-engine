require 'simplecov'
# SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'csv'
require_relative "../lib/invoice"
require_relative "../lib/invoice_repository"
require_relative "../lib/sales_engine"

class InvoiceRepositoryTest < Minitest::Test

  attr_reader :engine, :repository

  def setup
    @engine = SalesEngine.new("./test/fixtures")
    engine.startup
    @repository = engine.invoice_repository
  end

  def test_it_finds_all_customers
    result = repository.invoice
    assert_equal result, repository.find_all
    assert_equal Hash, result.class
  end

  def test_it_can_find_by_id

    result = repository.invoice["1"]
    assert_equal result, repository.find_by_id(1)
  end

  def test_it_can_find_by_customer_id
    result = repository.invoice["1"]
    assert_equal result, repository.find_by_customer_id(1)
  end

  def test_it_can_find_by_merchant_id
    result = repository.invoice["1"]
    assert_equal result, repository.find_by_merchant_id(26)
  end

  def test_it_can_find_by_creation_date
    result = repository.invoice["1"]
    assert_equal result, repository.find_by_creation_date(Date.parse("2012-03-25 09:54:09 UTC"))
  end

  def test_it_can_find_by_updated_date
    result = repository.invoice["1"]
    assert_equal result, repository.find_by_updated_date("2012-03-25 09:54:09 UTC")
  end
end
