require 'simplecov'
# SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'csv'
require_relative "../lib/transaction"
require_relative "../lib/transaction_repository"
require_relative "../lib/sales_engine"

class TransactionRepositoryTest < Minitest::Test

  attr_reader :engine, :repository

  def setup
    @engine = SalesEngine.new("./test/fixtures")
    engine.startup
    @repository = engine.transaction_repository
  end
  def test_it_finds_all_repositoryansactions
    result = repository.transactions
    assert_equal result, repository.find_all
  end

  def test_it_can_find_by_id
    result = repository.transactions["1"]
    assert_equal result, repository.find_by_id(1)
  end

  def test_it_finds_single_match_by_invoice_id
    result = repository.transactions["3"]
    assert_equal result, repository.find_by_invoice_id("4")
  end

  def test_it_finds_single_match_by_credit_card_number
    result = repository.transactions["12"]
    assert_equal result, repository.find_by_credit_card_number(4017503416578382)
  end

  def test_it_finds_single_match_by_credit_card_exp_date
    result = repository.transactions["1"]
    assert_equal result, repository.find_by_credit_card_exp_date('1234')
  end

  def test_it_works_when_there_are_no_exp_dates
    result = nil
    assert_equal result, repository.check_cc_exp_date_for_nil("")
  end

  def test_if_finds_single_match_for_result_status
    result = repository.transactions["1"]
    assert_equal result, repository.find_by_result("success")
  end

  def test_it_can_find_customers_by_creation_date
    result = repository.transactions["1"]
    assert_equal result, repository.find_by_creation_date("2012-03-27 14:54:09 UTC")
  end

  def test_it_can_find_customers_by_updated_date
    result = repository.transactions["1"]
    assert_equal result, repository.find_by_updated_date("2012-03-27 14:54:09 UTC")
  end

  def test_it_finds_all_matches_for_credit_card_number
    result = 4
    assert_equal result, repository.find_all_by_credit_card(4017503416578382).length
  end

  def test_it_finds_all_matches_for_credit_card_exp
    result = 2
    assert_equal result, repository.find_all_by_credit_card_exp("1234").length
  end

  def test_it_finds_all_matches_by_result
    result = 11
    assert_equal result, repository.find_all_by_result("success").length
  end

  def test_it_finds_all_matches_by_creation_date
    assert_equal 13, repository.find_all_by_updated_date("2012-03-27 14:54:10 UTC").count
  end

  def test_it_finds_all_matches_by_updated_date
    assert_equal 13, repository.find_all_by_updated_date("2012-03-27 14:54:10 UTC").count
  end

  def test_if_finds_successful_transactions
    assert_equal 11, repository.successful_transactions.count
  end
end
