# frozen_string_literal: true

# The Discounts module provides methods for calculating various discounts.
module Discounts
  def buy_one_get_one_free(product:, quantity:)
    product.price * (quantity / 2).to_i
  end

  def bulk_purchase_discount(product:, quantity:, discount_limit:, discounted_price:)
    quantity >= discount_limit ? quantity * (product.price - discounted_price) : 0
  end

  def volume_ratio_discount(product:, quantity:, discount_limit:, discounted_ratio:)
    return 0 if quantity < discount_limit

    effective_price_numerator, denominator = discounted_ratio.split('/').map(&:to_i)
    numerator = denominator - effective_price_numerator

    (product.price * quantity * numerator / denominator).round(2)
  end
end
