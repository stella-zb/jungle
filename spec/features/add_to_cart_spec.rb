require 'rails_helper'

RSpec.feature "AddToCarts", type: :feature, js: true do

  before :each do
    @category = Category.create! name: 'Apparel'

    10.times do |n|
      @category.products.create!(
        name:  Faker::Hipster.sentence(3),
        description: Faker::Hipster.paragraph(4),
        image: open_asset('apparel1.jpg'),
        quantity: 10,
        price: 64.99
      )
    end
  end

  scenario "The cart is updated after click add button" do
    visit root_path

    find('.product > footer > .button_to', match: :first).click

    save_and_open_screenshot('update_cart.png')
    expect(page).to have_text 'My Cart (1)'
  end
end
