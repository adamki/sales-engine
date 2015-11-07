require 'date'

class Transaction

  attr_reader :id,
              :invoice_id,
              :credit_card_number,
              :credit_card_expiration_date,
              :result,
              :created_at,
              :updated_at,
              :repository

  def initialize(parameters, repository)
    @id                             = parameters[:id].to_i
    @invoice_id                     = parameters[:invoice_id].to_i
    @credit_card_number             = parameters[:credit_card_number].to_i
    @credit_card_expiration_date    = parameters[:credit_card_expiration_date]
    @result                         = parameters[:result]
    @created_at                     = Date.parse(parameters[:created_at])
    @updated_at                     = Date.parse(parameters[:updated_at])
    @repository                     = repository
  end

  def invoice
    repository.find_invoice_by_transaction(invoice_id)
  end

  def success?
    result == "success"
  end

end
