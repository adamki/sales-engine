require 'csv'
require 'simplecov'
# SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require_relative "../lib/customer"
require_relative "../lib/sales_engine"

class CustomerTest < Minitest::Test

  attr_reader :engine, :repository

  def setup
    @engine = SalesEngine.new("./test/fixtures")
    engine.startup
    @repository = engine.customer_repository
  end

  def test_it_can_access_customer_id
    customer = repository.find_by_id(1)
    assert_equal 1 , customer.id
  end

  def test_it_can_access_customers_first_name
    customer = repository.find_by_first_name("joey")
    assert_equal 1, customer.id
  end

  def test_it_can_access_customers_last_name
    customer = repository.find_by_last_name("Ondricka")
    assert_equal 1, customer.id
  end

  def test_it_can_access_customers_creation_date
    customer = repository.find_by_creation_date("2012-03-27 14:54:09 UTC")
    assert_equal 1, customer.id
  end

  def test_it_can_access_customers_updated_date
    customer = repository.find_by_updated_date("2012-03-27 14:54:09 UTC")
    assert_equal 1, customer.id
  end

  def test_it_returns_a_collection_of_invoices_for_a_given_customer
    customer = repository.find_by_id(1)
    invoices = customer.invoices
    assert_equal [26, 75, 78, 33, 41, 76, 44, 38], invoices.map {|invoices| invoices.merchant_id}
  end

  def test_it_returns_a_collection_of_transactions_for_a_given_customer
    customer = repository.find_by_id(2)
    assert_equal 3, customer.transactions.size
  end

  def test_it_can_find_successful_transactions
    customer = repository.find_by_id(1)
    assert_equal 7, customer.successful_transactions.count
  end

  def test_it_can_find_successful_invoices_and_output_merchant_ids
    customer = repository.find_by_id(1)
    assert_equal 18, customer.find_successful_invoices.count
  end

  def test_it_can_sort_successfully
    customer = repository.find_by_id(1)
    assert_equal 26,
    customer.sort_successful_ids.flatten.count
  end

  def test_it_finds_favorite_merchant
    @engine = SalesEngine.new("./data")
    engine.startup
    customer = repository.find_by_id(2)
    assert_equal "Dicki-Bednar", customer.favorite_merchant.name
  end

  # def test_it_finds_favorite_merchant_deux
  #   customer = repository.find_by_id(2)
  #   assert_equal "Dicki-Bednar", customer.favorite_merchant.name
  # end


end
