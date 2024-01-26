# frozen_string_literal: true

require 'json'
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

  def scan(product_code)
    @cart[product_code] = @cart.fetch(product_code, 0) + 1
  end

  def purchases
    @cart.sum do |code, quantity|
      products[code].price * quantity
    end
  end

  def discounts
    @cart.sum do |code, quantity|
      product = products[code]
      next 0 unless product.discount_type

      send(product.discount_type, product:, quantity:, **product.discount_arguments)
    end
  end

  def total
    purchases - discounts
  end

  def receipt
    return unless purchases.positive?

    display_purchases
    if discounts.positive?
      display_discounts
      display_total
    end
    display_grand_total
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
