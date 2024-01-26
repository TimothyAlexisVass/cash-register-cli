#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/cash_register'

# App class represents the main application for this simple cash register system.
# Users can view available products, scan products, and generate a receipt.
# The application uses the CashRegister class to handle product scanning,
# purchase calculation, and discount application.
class App
  attr_reader :cash_register

  def initialize
    @cash_register = CashRegister.new
  end

  def run
    display_available_products
  end

  private

  def products
    @products ||= @cash_register.products
  end

  def cart
    @cart ||= @cash_register.cart
  end

  def display_available_products
    puts "\n============== Available Products ============="
    products.each do |code, product|
      puts "#{code}: #{product.name.ljust(31)} #{format('%.2f', product.price).rjust(8)} €"
    end
    puts
  end
end

if __FILE__ == $PROGRAM_NAME
  app = App.new
  app.run
end
