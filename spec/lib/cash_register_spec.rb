# frozen_string_literal: true

require 'json'
require_relative '../../lib/cash_register'

RSpec.describe CashRegister do
  let(:cash_register) { described_class.new }
  let(:product_data) do
    { code: 'PR1', name: 'Product 1', price: 10.0, discount_type: :buy_one_get_one_free }
  end

  before do
    allow(File).to receive(:read).with('data/products.json').and_return([product_data].to_json)
  end

  describe '#scan' do
    it 'adds the scanned product to the cart' do
      expect { cash_register.scan('PR1') }.to change { cash_register.cart['PR1'] }.from(nil).to(1)
    end

    it 'increments the quantity when scanning the same product multiple times' do
      33.times { cash_register.scan('PR1') }
      expect(cash_register.cart['PR1']).to eq(33)
    end
  end

  describe '#purchases' do
    it 'returns the total purchases amount without discounts' do
      cash_register.scan('PR1')
      cash_register.scan('PR1')
      expect(cash_register.purchases).to eq(20.0)
    end
  end

  describe '#discounts' do
    it 'returns the total discount amount' do
      cash_register.scan('PR1')
      cash_register.scan('PR1')
      expect(cash_register.discounts).to eq(10.0)
    end
  end

  describe '#total' do
    it 'returns the total amount after applying discounts' do
      cash_register.scan('PR1')
      cash_register.scan('PR1')
      expect(cash_register.total).to eq(10.0)
    end
  end
end
