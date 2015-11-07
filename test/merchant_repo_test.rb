require 'date'
require 'simplecov'
# SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'csv'
require_relative "../lib/merchant"
require_relative "../lib/merchant_repository"
require_relative "../lib/sales_engine"

class MerchantRepositoryTest < Minitest::Test

  attr_reader :engine, :repository

  def setup
    @engine = SalesEngine.new("./test/fixtures")
    engine.startup
    @repository = engine.merchant_repository
  end

  def test_it_finds_all_merchants
    result = repository.merchants
    assert_equal result, repository.find_all
    assert_equal Hash, result.class
  end

  def test_it_can_find_by_id
    result = repository.merchants["1"]
    assert_equal result, repository.find_by_id(1)
  end

  def test_it_finds_single_match_for_first_name
    result = repository.merchants["5"]
    assert_equal result, repository.find_by_name("Williamson Group")
  end

  def test_it_can_find_customers_by_creation_date
    result = repository.merchants["10"]
    assert_equal result, repository.find_by_creation_date(Date.parse("2012-03-27 14:54:00 UTC"))
  end

  def test_it_can_find_customers_by_updated_date
    result = repository.merchants["10"]
    assert_equal result, repository.find_by_updated_date("2012-03-27 14:54:00 UTC")
  end

  def test_it_can_find_all_merchants_by_name
    assert_equal 2 , repository.find_all_by_name("Williamson Group").count
  end

  def test_it_finds_all_merchants_by_creation_date
    assert_equal 5, repository.find_all_by_creation_date("2012-03-27 14:54:00 UTC").count
  end

  def test_it_finds_all_matches_by_updated_date
    skip
    assert_equal 5, repository.find_all_by_updated_date("2012-03-27 14:54:00 UTC").count
  end

  def test_it_can_determine_top_merchant_by_total_revenue
    assert_equal 8, repository.most_revenue(1).first.id
  end

  def test_it_can_return_the_merchants_with_the_most_items_sold
    assert_equal 15, repository.most_items(1).first.id
  end
end
