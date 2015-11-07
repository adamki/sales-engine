require_relative 'transaction'
require_relative './transaction_loader'

class TransactionRepository

  attr_reader :transactions, :sales_engine

  def initialize(rows, sales_engine)
    @transactions ||= load_transactions(rows)
    @sales_engine = sales_engine
  end

  def load_transactions(rows)
    @transactions = Hash.new(0)
    rows.map {|row| @transactions[row[:id]] = Transaction.new(row, self) }
    @transactions
  end

  def find_all
    transactions
  end

  def random
    transactions.values.sample
  end

  def find_by_id(id)
    transactions.detect { |key, value| value.id == id }.last
  end

  def find_by_invoice_id(invoice_id)
    transactions.detect { |key, value| value.invoice_id == invoice_id.to_i }.last
  end

  def find_by_credit_card_number(credit_card_number)
    transactions.detect do |key, value|
      value.credit_card_number == credit_card_number.to_i
    end.last
  end

  def check_cc_exp_date_for_nil(credit_card_expiration_date)
    if credit_card_expiration_date.length == 4
      find_by_credit_card_exp_date(credit_card_expiration_date)
    end
  end

  def find_by_credit_card_exp_date(credit_card_expiration_date)
    transactions.detect do |key, value|
      value.credit_card_expiration_date == credit_card_expiration_date
    end.last
  end

  def find_by_result(result)
    transactions.detect { |key, value| value.result == result }.last
  end

  def find_by_creation_date(date)
    transactions.detect { |key, value| value.created_at == date }.last
  end

  def find_by_updated_date(date)
    transactions.detect { |key, value| value.updated_at == date }.last
  end

  def find_all_by_invoice_id(invoice_id)
    matches = transactions.select do|key,value|
      value.invoice_id  == invoice_id
    end.to_a
    matches.map {|key, value| value}
  end

  def find_all_by_credit_card(number)
    matches = transactions.select{|key,value| value.credit_card_number == number }.to_a
    matches.map {|key, value| value}
  end

  def find_all_by_credit_card_exp(date)
    matches = transactions.select{|key,value| value.credit_card_expiration_date  == date  }.to_a
    matches.map {|key, value| value}
  end

  def find_all_by_result(status)
    matches = transactions.select{|key,value| value.result  == status  }.to_a
    matches.map {|key, value| value}
  end

  def find_all_by_creation_date(date)
    matches = transactions.select{|key,value| value.created_at   == date  }.to_a
    matches.map {|key, value| value}
  end

  def find_all_by_updated_date(date)
    matches = transactions.select{|key,value| value.updated_at== date  }.to_a
    matches.map {|key, value| value}
  end

  def find_invoice_by_transaction(invoice_id)
    sales_engine.find_invoice_by_transaction(invoice_id)
  end

  def successful_transactions
    transactions.map {|key, value| value}.select do |transaction|
    transaction if transaction.success?
    end
  end

  def create(data, invoice_id)
    parameters = {
      id: transactions.to_a.last[0].to_i + 1,
      invoice_id: invoice_id,
      credit_card_number: data[:credit_card_expiration_date],
      result: data[:result],
      created_at: Date.today.strftime("%F"),
      updated_at: Date.today.strftime("%F")
    }
  new_transaction = Transaction.new(parameters, self)
  transactions[:id] = new_transaction
  new_transaction
end
  def inspect
    "#<#{self.class} #{@transactions.size} rows>"
  end

end
