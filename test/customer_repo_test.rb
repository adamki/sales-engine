require 'simplecov'
# SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'csv'
require_relative "../lib/customer"
require_relative "../lib/customer_repository"
require_relative "../lib/sales_engine"


class CustomerRepositoryTest < Minitest::Test

  attr_reader :engine, :repository

  def setup
    @engine = SalesEngine.new("./test/fixtures")
    engine.startup
    @repository = engine.customer_repository
  end

  def test_it_finds_all_customers
    result = repository.customers
    assert_equal result, repository.find_all
    assert_equal Hash, result.class
  end

  def test_it_can_find_by_id
    result = repository.customers["1"]
    assert_equal result, repository.find_by_id(1)
  end

  def test_it_finds_single_match_for_first_name
    result = repository.customers["1"]
    assert_equal result, repository.find_by_first_name( "Joey")
  end

  def test_it_finds_single_match_for_last_name
    result = repository.customers["6"]
    assert_equal result, repository.find_by_last_name("Kuhn")
  end

  def test_it_can_find_customers_by_creation_date
    result = repository.customers["8"]
    assert_equal result, repository.find_by_creation_date("2012-03-27 14:54:11 UTC")
  end

  def test_it_can_find_customers_by_updated_date
    result = repository.customers["8"]
    assert_equal result, repository.find_by_updated_date("2012-03-27 14:54:11 UTC")
  end

  def test_it_finds_all_matches_for_first_name
    assert_equal 1, repository.find_all_by_first_name("Joey").length
  end

  def test_it_find_all_matches_for_last_name
    assert_equal 1, repository.find_all_by_last_name( "Ondricka").length
  end

  def test_it_finds_all_matches_by_creation_date
    assert_equal 6, repository.find_all_by_creation_date("2012-03-27 14:54:10 UTC").count
  end

  def test_it_finds_all_matches_by_updated_date
    assert_equal 1, repository.find_all_by_updated_date("2012-03-27 14:54:09 UTC").count
  end

  def test_that_finds_all_returns_empty_array_when_no_matches_are_found
    result = []
    assert_equal result, repository.find_all_by_first_name("Adam")
    assert_equal result, repository.find_all_by_last_name( "Minewrath")
    assert_equal result, repository.find_all_by_updated_date("2012-03-27 12:59:59 UTC")
    assert_equal result, repository.find_all_by_creation_date("2012-03-27 12:59:59 UTC")
  end

end
