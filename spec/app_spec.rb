# frozen_string_literal: true

require_relative '../app'

RSpec.describe App do
  let(:app) { described_class.new }

  before do
    mock_products = {
      'A' => Product.new(code: 'A', name: 'Product A', price: 1.1),
      'B' => Product.new(code: 'B', name: 'Product B', price: 2.2, discount_type: 'buy_one_get_one_free')
    }

    allow(app.cash_register).to receive(:products).and_return(mock_products)
  end

  describe '#initialize' do
    it 'initializes a new App object with a CashRegister' do
      expect(app.instance_variable_get(:@cash_register)).to be_an_instance_of(CashRegister)
    end
  end

  describe '#run' do
    context 'with minimal output' do
      before do
        allow(app).to receive(:gets).and_return('exit')
      end

      it 'shows the available products heading' do
        expect { app.run }.to output(/=+ Available Products =+/).to_stdout
      end

      it 'shows the first available product' do
        expect { app.run }.to output(/A: Product A\s+1.10 €/).to_stdout
      end

      it 'shows the second available product' do
        expect { app.run }.to output(/B: Product B\s+2.20 €/).to_stdout
      end
    end

    context 'when requesting receipt with no purchases' do
      before do
        allow(app).to receive(:gets).and_return('receipt')
      end

      it 'does not show purchases' do
        expect { app.run }.not_to output(/Purchases/).to_stdout
      end

      it 'does not show discounts' do
        expect { app.run }.not_to output(/Discounts/).to_stdout
      end

      it 'does not show total' do
        expect { app.run }.not_to output(/Total/).to_stdout
      end
    end

    context 'when user inputs "exit" after scanning' do
      before do
        allow(app).to receive(:gets).and_return('a', 'exit')
      end

      it 'does not show purchases' do
        expect { app.run }.not_to output(/Purchases/).to_stdout
      end

      it 'does not show discounts' do
        expect { app.run }.not_to output(/Discounts/).to_stdout
      end

      it 'does not show total' do
        expect { app.run }.not_to output(/Total/).to_stdout
      end
    end

    context 'with discounts' do
      before do
        allow(app).to receive(:gets).and_return('a', 'b', 'b', 'receipt')
      end

      it 'applies discounts correctly' do
        expect { app.run }.to output(/B\s+\(Buy one get one free\)\s+-\s+2.20 €/).to_stdout
      end

      it 'shows the discounts heading' do
        expect { app.run }.to output(/=+ Discounts =+/).to_stdout
      end

      it 'shows the total heading' do
        expect { app.run }.to output(/=+   Total   =+/).to_stdout
      end

      it 'shows the total purchases' do
        expect { cash_register.receipt }.to output(/Purchases:\s+5.50 €/).to_stdout
      end

      it 'shows the total discounts' do
        expect { cash_register.receipt }.to output(/Discounts:\s+-\s+2.20 €/).to_stdout
      end

      it 'calculates the correct total amount due' do
        expect { app.run }.to output(/Total amount due:\s+3.30 €/).to_stdout
      end
    end

    context 'with no discounts' do
      before do
        allow(app).to receive(:gets).and_return('b', 'receipt')
      end

      it 'does not show any discounts' do
        expect { app.run }.not_to output(/Discounts/).to_stdout
      end

      it 'does not show the totals section' do
        expect { app.run }.not_to output(/=+   Total   =+/).to_stdout
      end

      it 'does not show the purchases in the totals section' do
        expect { app.run }.not_to output(/Purchases:/).to_stdout
      end

      it 'calculates the correct total amount due' do
        expect { app.run }.to output(/Total amount due:\s+2.20 €/).to_stdout
      end
    end

    context 'when interacting with the user' do
      it 'is case-insensitive when handling user input' do
        allow(app).to receive(:gets).and_return('A', 'b', 'ReCeIpT')

        expect { app.run }.to output(/Product A.*Product B/).to_stdout
      end

      it 'accepts comma- and space separated inputs' do
        allow(app).to receive(:gets).and_return('a a,b, b b', 'b', 'receipt')

        expect { app.run }.to(output(/2 Product A, 4 Product B/).to_stdout)
      end

      it 'shows an error message for an invalid product code' do
        allow(app).to receive(:gets).and_return('invalid', 'receipt')

        expect { app.run }.to output(/Invalid product code/).to_stdout
      end

      it 'confirms that the products were scanned' do
        allow(app).to receive(:gets).and_return('a b', 'receipt')
  
        expect { app.run }.to output(/Product A Scanned.+\n.+Product B Scanned/).to_stdout
      end

      it 'shows the cart content when products are scanned' do
        allow(app).to receive(:gets).and_return('a a b b b b', 'receipt')
        expect { app.run }.to output(/=+ Products in the cart =+\n2 Product A, 4 Product B/).to_stdout
      end
    end
  end
end
