require 'csv'
require_relative 'customer_repository'
require_relative 'customer_loader'
require_relative 'merchant_repository'
require_relative 'merchant_loader'
require_relative 'item_repository'
require_relative "item_loader"
require_relative 'transaction_repository'
require_relative "transaction_loader"
require_relative "invoice_repository"
require_relative "invoice_loader"
require_relative "invoice_item_repository"
require_relative "invoice_item_loader"

class SalesEngine

  attr_reader   :customer_data,    :customer_repository,
                :merchant_data,    :merchant_repository,
                :invoice_data,     :invoice_repository,
                :item_data,        :item_repository,
                :invoice_item_data,:invoice_item_repository,
                :transaction_data, :transaction_repository

  def initialize(directory = "./data")
    @customer_data        = CustomerLoader.new.load_all("#{directory}/customers.csv")
    @merchant_data        = MerchantLoader.new.load_all("#{directory}/merchants.csv")
    @invoice_data         = InvoiceLoader.new.load_all("#{directory}/invoices.csv")
    @item_data            = ItemLoader.new.load_all("#{directory}/items.csv")
    @transaction_data     = TransactionLoader.new.load_all("#{directory}/transactions.csv")
    @invoice_item_data    = InvoiceItemLoader.new.load_all("#{directory}/invoice_items.csv")
  end

  def startup
    @customer_repository      ||= CustomerRepository.new(@customer_data, self)
    @merchant_repository      ||= MerchantRepository.new(@merchant_data, self)
    @invoice_repository       ||= InvoiceRepository.new(@invoice_data, self)
    @transaction_repository   ||= TransactionRepository.new(@transaction_data, self)
    @item_repository          ||= ItemRepository.new(@item_data, self)
    @invoice_item_repository  ||= InvoiceItemRepository.new(@invoice_item_data, self)
  end

  def find_customer_by_id(id)
    customer_repository.find_by_id(id)
  end

  def find_items_for_merchant(merchant_id)
    item_repository.find_all_by_merchant_id(merchant_id)
  end

  def find_invoices_for_merchant(merchant_id)
    invoice_repository.find_all_by_merchant_id(merchant_id)
  end

  def find_transactions_for_invoice(id)
    transaction_repository.find_all_by_invoice_id(id)
  end

  def find_merchant_for_invoice(merchant_id)
    merchant_repository.find_by_id(merchant_id)
  end

  def find_merchant_by_item(merchant_id)
    merchant_repository.find_by_id(merchant_id)
  end

  def find_invoice_by_transaction(invoice_id)
    invoice_repository.find_by_id(invoice_id)
  end

  def find_invoices_by_customer(id)
    invoice_repository.find_all_by_customer_id(id)
  end

  def find_all_invoice_items_by_invoice_id(id)
    invoice_repository.find_all_by_invoice_id(id)
  end

  def find_invoices_by_id(invoice_id)
    invoice_repository.find_by_id(invoice_id)
  end

  def find_item_by_invoice(item_id)
    item_repository.find_by_id(item_id)
  end

  def find_invoice_item_by_invoice_id(id)
    invoice_item_repository.find_all_by_invoice_id(id)
  end

  def find_item_by_invoice_item_id(item_id)
    item_id = item_id.flat_map do |item|
      item_repository.find_by_id(item.item_id)
    end
  end

  def find_customer_by_invoice(customer_id)
    customer_repository.find_by_id(customer_id)
  end

  def find_invoice_items_by_item(id)
    invoice_item_repository.find_all_by_item_id(id)
  end

  def find_favorite_merchant(id)
    merchant_repository.find_by_id(id)
  end

  def find_invoices_by_id(id)
    invoice_repository.find_by_id(id)
  end

  def charge_credit_card(data, invoice_id)
    transaction_repository.create(data, invoice_id)
  end

end

if __FILE__ == $0
  engine = SalesEngine.new
  engine.startup
  require "pry";binding.pry
end
