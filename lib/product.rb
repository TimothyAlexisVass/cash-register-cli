# frozen_string_literal: true

# The Product class represents a product with optional discount information.
class Product
  attr_reader :code, :name, :price, :discount_type, :discount_arguments

  def initialize(code:, name:, price:, discount_type: nil, discount_arguments: {})
    @code = code
    @name = name
    @price = price
    @discount_type = discount_type&.to_sym
    @discount_arguments = discount_arguments
  end
end
