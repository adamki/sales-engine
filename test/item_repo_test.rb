require 'simplecov'
# SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'csv'
require_relative "../lib/item"
require_relative "../lib/item_repository"
require_relative "../lib/sales_engine"


class ItemRepositoryTest < Minitest::Test

  attr_reader :engine, :repository

  def setup
    @engine = SalesEngine.new("./test/fixtures")
    engine.startup
    @repository = engine.item_repository
  end

  def test_it_finds_all_customers
    result = repository.items
    assert_equal result, repository.find_all
    assert_equal Hash, result.class
  end

  def test_it_finds_an_item_by_id
    result = repository.items["1"]
    assert_equal result, repository.find_by_id(1).first
  end

  def test_it_finds_an_item_by_its_name
    result = repository.items["1"]
    assert_equal result, repository.find_by_name("Item Qui Esse")
  end

  def test_it_finds_an_item_by_its_description
    description = "Iusto ratione illum. Adipisci est perspiciatis temporibus. Ducimus id dolorem voluptas eligendi repellat iure sit."
    result = repository.items["11"]
    assert_equal result, repository.find_by_description(description)
  end

  def test_it_finds_by_unit_price
    result = repository.items["2"]
    assert_equal result, repository.find_by_unit_price("67076")
  end

  def test_it_can_find_items_by_creation_date
    result = repository.items["1"]
    assert_equal result, repository.find_by_creation_date("2012-03-27 14:53:59 UTC")
  end

  def test_it_can_find_items_by_updated_date
    result = repository.items["1"]
    assert_equal result, repository.find_by_updated_date("2012-03-27 14:53:59 UTC")
  end

  def test_it_finds_all_items_by_name
    assert_equal 4, repository.find_all_by_name("Item Rerum Magni").length
  end

  def test_it_finds_all_items_by_description
    description = "Iusto ratione illum. Adipisci est perspiciatis temporibus. Ducimus id dolorem voluptas eligendi repellat iure sit."
    assert_equal 4, repository.find_all_by_description(description).length
  end

  def test_it_finds_all_items_by_unit_price
    assert_equal 4, repository.find_all_by_unit_price(13046).length
  end

  def test_it_finds_all_items_by_unit_price
    assert_equal 14, repository.find_all_by_merchant_id(1).length
  end

  def test_it_finds_all_matches_by_creation_date
    assert_equal 14, repository.find_all_by_creation_date("2012-03-27 14:53:59 UTC").count
  end

  def test_it_finds_all_matches_by_updated_date
    assert_equal 14, repository.find_all_by_updated_date("2012-03-27 14:53:59 UTC").count
  end

  def test_that_finds_all_returns_empty_array_when_no_matches_are_found
    result = []
    assert_equal result, repository.find_all_by_name("Item Quiche Esse")
    assert_equal result, repository.find_all_by_description( "Item Qui Esse Item Qui Esse")
    assert_equal result, repository.find_all_by_updated_date("2015-03-27 12:59:59 UTC")
    assert_equal result, repository.find_all_by_creation_date("2015-03-27 12:59:59 UTC")
  end

end
