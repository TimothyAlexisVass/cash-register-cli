# frozen_string_literal: true

require_relative '../../lib/product'

RSpec.describe Product do
  describe 'Product attributes' do
    let(:product_without_discount) do
      described_class.new(code: 'PR1', name: 'Product 1', price: 1.1)
    end
    let(:product_with_discount) do
      described_class.new(code: 'PR2', name: 'Product 2', price: 22.2, discount_type: :percentage,
                          discount_arguments: { percentage: 20 })
    end

    it 'has correct code for a product without discount' do
      expect(product_without_discount.code).to eq('PR1')
    end

    it 'has correct name for a product without discount' do
      expect(product_without_discount.name).to eq('Product 1')
    end

    it 'has correct price for a product without discount' do
      expect(product_without_discount.price).to eq(1.1)
    end

    it 'has no discount type for a product without discount' do
      expect(product_without_discount.discount_type).to be_nil
    end

    it 'has no discount arguments for a product without discount' do
      expect(product_without_discount.discount_arguments).to be_empty
    end

    it 'has correct code for a product with discount' do
      expect(product_with_discount.code).to eq('PR2')
    end

    it 'has correct name for a product with discount' do
      expect(product_with_discount.name).to eq('Product 2')
    end

    it 'has correct price for a product with discount' do
      expect(product_with_discount.price).to eq(22.2)
    end

    it 'has correct discount type for a product with discount' do
      expect(product_with_discount.discount_type).to eq(:percentage)
    end

    it 'has correct discount arguments for a product with discount' do
      expect(product_with_discount.discount_arguments).to eq(percentage: 20)
    end
  end
end
