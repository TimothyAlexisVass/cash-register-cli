# frozen_string_literal: true

require_relative 'discounts'
require_relative 'product'

# The CashRegister class represents a simple cash register that can scan products,
# calculate purchases, apply discounts, and generate a receipt.
class CashRegister
  include Discounts

  def initialize
    @cart = {}
  end
end
