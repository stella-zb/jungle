require 'rails_helper'

RSpec.feature "ProductDetails", type: :feature, js: true do

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

  scenario "They see first product detail after click the product image" do
    visit root_path

    find('.product > header > a', match: :first).click
    
    page.has_css?('.product-detail')

    sleep 1.0

    save_and_open_screenshot('product_page_header.png')
    expect(page).to have_css '.product-detail'
  end

  scenario "They see first product detail after click the detail button" do
    visit root_path

    find('.product > footer > a', match: :first).click
    
    page.has_css?('.product-detail')

    save_and_open_screenshot('product_page_button.png')
    expect(page).to have_css '.product-detail'
  end
end
