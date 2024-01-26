#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/cash_register'

# App class represents the main application for a simple cash register system.
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
    user_interaction_loop
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

  def user_interaction_loop
    loop do
      display_input_message
      @input = gets.chomp.gsub('"', '').downcase
      break if %w[receipt exit].include?(@input)

      @input.split(/,|\s+/).each do |code|
        scan_product(code.upcase.strip)
      end
      display_cart unless cart.empty?
    end
    @cash_register.receipt unless @input == 'exit'
  end

  def display_input_message
    puts 'Enter one or more comma- or space-separated product codes to scan.'
    puts 'Enter "receipt" to show receipt or "exit" to quit.'
  end

  def scan_product(code)
    if products.key?(code)
      @cash_register.scan(code)
      puts "\e[34m#{products[code].name} Scanned\e[0m"
    else
      terminal_sound
      puts "\e[31mInvalid product code. Please try again.\e[0m"
      display_available_products
    end
  end

  # Bell notification, works in most terminals
  def terminal_sound
    print "\a"
  end

  def display_cart
    puts '============= Products in the cart ============'
    puts cart.keys.map { |code| "#{cart[code]} #{products[code].name}" }.join(', ')
  end
end

if __FILE__ == $PROGRAM_NAME
  app = App.new
  app.run
end
