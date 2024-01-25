# frozen_string_literal: true

require_relative '../../lib/cash_register'

RSpec.describe CashRegister do
  let(:cash_register) { described_class.new }

  it { expect(1).to eq(1) }
end
