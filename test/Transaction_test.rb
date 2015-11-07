require 'simplecov'
# SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'csv'
require_relative "../lib/transaction"
require_relative "../lib/sales_engine"

class TransactionTest < Minitest::Test

  attr_reader :engine, :repository

  def setup
    @engine = SalesEngine.new("./test/fixtures")
    engine.startup
    @repository = engine.transaction_repository
  end

  def test_it_can_access_id
    tran = repository.find_by_id(1)
    assert_equal 1, tran.id
  end

  def test_it_can_access_invoice_id
    tran = repository.find_by_invoice_id("1")
    assert_equal 1, tran.invoice_id
  end

  def test_it_can_access_by_cc_number
    tran = repository.find_by_credit_card_number(4580251236515201)
    assert_equal 4580251236515201, tran.credit_card_number
  end

  def test_it_can_access_by_result
    tran = repository.find_by_result("failed")
    assert_equal 11, tran.id
  end

  def test_it_can_access_by_created_at_date
    tran = repository.find_by_creation_date("2012-03-27 14:54:10 UTC")
    assert_equal 3, tran.id
  end

  def test_it_can_access_by_updated_at_date
    tran = repository.find_by_updated_date("2012-03-27 14:54:10 UTC")
    assert_equal 3, tran.id
  end

  def test_it_can_return_invoice_for_given_transaction
    tran = repository.find_by_invoice_id(1)
    invoice = tran.invoice
    assert_equal 26, invoice.merchant_id
  end

end
