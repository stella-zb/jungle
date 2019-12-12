class Admin::DashboardController < ApplicationController
  def show
    @products = Product.all
  end
end
