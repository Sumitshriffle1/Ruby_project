class Product
  attr_accessor :name, :price, :category, :quantity

  def initialize(name, price, category, quantity)
    @name = name
    @price = price
    @category = category
    @quantity = quantity
  end
end
