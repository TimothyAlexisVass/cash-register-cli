# frozen_string_literal: true

require 'json'
require_relative '../../lib/cash_register'

RSpec.describe CashRegister do
  let(:cash_register) { described_class.new }
  let(:product_data) do
    { code: 'PR1', name: 'Product 1', price: 10.0, discount_type: :buy_one_get_one_free }
  end

  before do
    allow(File).to receive(:read).with('data/products.json').and_return([product_data].to_json).once
  end

  describe '#products' do
    it 'loads and returns products from the products.json file' do
      expect(cash_register.products).to be_a(Hash).and include(
        'PR1' => an_instance_of(Product).and(
          have_attributes(
            code: 'PR1',
            name: 'Product 1',
            price: 10.0,
            discount_type: :buy_one_get_one_free
          )
        )
      )
    end
    
    it 'memoizes the products' do
      expect(cash_register.products).to eq cash_register.products
    end
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

  describe '#receipt' do
    context 'with purchases and discounts' do
      before do
        cash_register.scan('PR1')
        cash_register.scan('PR1')
      end

      it 'includes the purchases heading' do
        expect { cash_register.receipt }.to output(/=+ Purchases =+/).to_stdout
      end

      it 'includes the product in the receipt' do
        expect { cash_register.receipt }.to output(/Product 1\s+2 ×\s+10.00 €/).to_stdout
      end

      it 'includes the subtotal' do
        expect { cash_register.receipt }.to output(/^\s+20.00 €/).to_stdout
      end

      it 'includes the discounts heading' do
        expect { cash_register.receipt }.to output(/=+ Discounts =+/).to_stdout
      end

      it 'shows the discount correctly' do
        expect { cash_register.receipt }.to output(/PR1 \(Buy one get one free\)\s+-\s+10.00 €/).to_stdout
      end

      it 'shows the total heading' do
        expect { cash_register.receipt }.to output(/=+   Total   =+/).to_stdout
      end

      it 'shows the total purchases' do
        expect { cash_register.receipt }.to output(/Purchases:\s+20.00/).to_stdout
      end

      it 'shows the total discounts' do
        expect { cash_register.receipt }.to output(/Discounts:\s+-\s+10.00/).to_stdout
      end

      it 'shows the total amount due' do
        expect { cash_register.receipt }.to output(/Total amount due:\s+10.00/).to_stdout
      end
    end

    context "with purchases but no discounts" do
      before do
        cash_register.scan('PR1')
      end

      it 'does not show any discounts when there are none' do
        expect { cash_register.receipt }.not_to output(/Discounts/).to_stdout
      end

      it 'does not show the total heading' do
        expect { cash_register.receipt }.not_to output(/=+   Total   =+/).to_stdout
      end

      it 'does not show the purchases in the totals section' do
        expect { cash_register.receipt }.not_to output(/Purchases:/).to_stdout
      end

      it 'shows the total amount due' do
        expect { cash_register.receipt }.to output(/Total amount due:\s+10.00/).to_stdout
      end
    end

    it 'does not print the receipt when there are no purchases' do
      expect { cash_register.receipt }.not_to output.to_stdout
    end
  end
end
