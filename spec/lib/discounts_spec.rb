# frozen_string_literal: true

require_relative '../../lib/product'
require_relative '../../lib/discounts'

RSpec.describe Discounts do
  include described_class
  let(:product) do
    Product.new(code: 'PR1', name: 'Product 1', price: 11.1)
  end

  describe 'Buy One Get One Free Discount' do
    it 'applies no discount for single item' do
      expect(buy_one_get_one_free(product:, quantity: 1)).to eq(0)
    end

    it 'applies one freebie for two items' do
      expect(buy_one_get_one_free(product:, quantity: 2)).to eq(11.1)
    end

    it 'applies one freebie for three items' do
      expect(buy_one_get_one_free(product:, quantity: 3)).to eq(11.1)
    end

    it 'applies two freebies for four items' do
      expect(buy_one_get_one_free(product:, quantity: 4)).to eq(22.2)
    end
  end

  describe 'Bulk Purchase Discount' do
    it 'applies no discount for quantity below limit' do
      expect(bulk_purchase_discount(product:, quantity: 5, discount_limit: 6,
                                    discounted_price: 10.1)).to eq(0)
    end

    it 'applies discounted price for quantity equal to limit' do
      expect(bulk_purchase_discount(product:, quantity: 7, discount_limit: 7,
                                    discounted_price: 9.6)).to eq(10.5)
    end

    it 'applies discounted price for quantity above limit' do
      expect(bulk_purchase_discount(product:, quantity: 15, discount_limit: 8,
                                    discounted_price: 9.1)).to eq(30.0)
    end
  end

  describe 'Volume Ratio Discount' do
    it 'applies no discount for quantity below limit' do
      expect(volume_ratio_discount(product:, quantity: 5, discount_limit: 10,
                                   discounted_ratio: '3/5')).to eq(0)
    end

    it 'applies discounted price for quantity equal to limit' do
      expect(volume_ratio_discount(product:, quantity: 10, discount_limit: 10,
                                   discounted_ratio: '2/3')).to eq(37.0)
    end

    it 'applies discounted price for quantity above limit' do
      expect(volume_ratio_discount(product:, quantity: 15, discount_limit: 10,
                                   discounted_ratio: '3/4')).to eq(41.63)
    end
  end
end
