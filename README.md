# Cash Register App
## Description

This is a simple Cash Register application written in Ruby.
It allows users to add products to a cart, will automatically apply discounts and display a receipt.

## Features

* Add products to the cart.
* Displays a receipt of scanned items including discounts.
* Supports the following discounts:
  * Buy one get one free
  * Bulk purchase discount
  * Coffee addict
* Additional discounts can be added to `discounts.rb`.

## Getting Started

### Prerequisites
* Ruby 3.1.2
* RSpec 3.12.0 < 4.0

### Preliminary modifications
* Additional discount rules can be added to the Discounts module in `lib/discounts.rb`.

### Installation

#### Clone the repository:
```bash
git clone https://github.com/TimothyAlexisVass/cash-register-cli.git
cd cash-register-cli
```
#### Install dependencies:
```bash
bundle install
```

### Run tests:
```bash
bundle exec rspec
```

### Run the command line interface:
```bash
ruby app.rb
```

## File structure
```
├── lib
│ ├── cash_register.rb          Main logic for adding products to the cart and computing the total price.
│ ├── discounts.rb              Module containing methods for special pricing conditions.
│ └── product.rb                Class to represent a product with its code, name, price and discount details.
│
├── spec
│ ├── lib
│ │ ├── cash_register_spec.rb   Tests for the cash register class.
│ │ ├── discounts_spec.rb       Tests for the discounts module.
│ │ └── product_spec.rb         Tests for the product class.
│ │
│ └── app_spec.rb               Tests for the command line interface.
│
├── app.rb                      Command line interface for the application.
├── Gemfile                     File specifying gem dependencies for the project.
└── README.md                   This README file.
```

## Usage
* Run `ruby app.rb` to start the command line interface.
* Follow the on-screen instructions to add products to the cart and display the receipt.
