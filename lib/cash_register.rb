# frozen_string_literal: true

require_relative 'discounts'
require_relative 'product'

# The CashRegister class represents a simple cash register that can scan products,
# calculate purchases, apply discounts, and generate a receipt.
class CashRegister
  include Discounts
  attr_reader :cart

  def initialize
    @cart = {}
  end

  def products
    @products ||= load_products
  end

  private

  def load_products
    products_data = JSON.parse(File.read('data/products.json'), symbolize_names: true)
    products_data.map do |product_data|
      product = Product.new(**product_data)
      [product.code, product]
    end.to_h
  end
end
