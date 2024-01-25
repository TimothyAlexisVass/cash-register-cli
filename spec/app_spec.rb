# frozen_string_literal: true

require_relative '../app'

RSpec.describe App do
  let(:app) { described_class.new }

  it { expect(1).to eq(1) }
end
