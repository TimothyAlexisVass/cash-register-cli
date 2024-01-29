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
    return false unless products.key?(product_code)
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

  def humanize_string(snake_case_string)
    snake_case_string.split('_').join(' ').capitalize
  end

  def currency_format(amount)
    "#{format('%.2f', amount).rjust(8)} €"
  end

  def display_purchases
    puts "\n================== Purchases =================="
    @cart.each do |code, quantity|
      purchase_info(products[code], quantity)
    end
  end

  def purchase_info(product, quantity)
    print "#{product.name[..30].ljust(30)} "
    print "#{quantity.to_s.rjust(3)} "
    puts "× #{currency_format(product.price)}"
    puts "#{' ' * 36} #{currency_format(product.price * quantity)}"
  end

  def display_discounts
    puts '================== Discounts =================='
    @cart.each do |code, quantity|
      product = products[code]
      next unless product.discount_type

      discount_amount = send(product.discount_type, product:, quantity:, **product.discount_arguments)
      next unless discount_amount.positive?

      discount_info(product, discount_amount)
    end
  end

  def discount_info(product, discount_amount)
    print "#{product.code[..3].ljust(3)} "
    print "(#{humanize_string product.discount_type.to_s[..28]})".ljust(30)
    puts " - #{currency_format(discount_amount)}"
  end

  def display_total
    puts '==================   Total   =================='
    puts "Purchases:".ljust(37) + currency_format(purchases)
    puts "Discounts:".ljust(35) + "- #{currency_format(discounts)}"
  end

  def display_grand_total
    puts '-' * 47
    puts "\e[32mTotal amount due:".ljust(42) + "#{currency_format(total)}\e[0m\n\n"
  end

  def load_products
    products_data = JSON.parse(File.read('data/products.json'), symbolize_names: true)
    products_data.map do |product_data|
      [product_data[:code].upcase, Product.new(**product_data)]
    end.to_h
  end
end
