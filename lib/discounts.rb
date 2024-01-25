# frozen_string_literal: true

# The Discounts module provides methods for calculating various discounts.
module Discounts
  def buy_one_get_one_free(product:, quantity:)
    product.price * (quantity / 2).to_i
  end

  def bulk_purchase_discount
    # TODO: Add logic
  end

  def volume_ratio_discount
    # TODO: Add logic
  end
end
