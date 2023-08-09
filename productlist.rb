require_relative 'product.rb'
class ProductList
  @products = [
    Product.new('Phone', 5000, 'Electronics', 10),
    Product.new('Laptop', 8000, 'Electronics', 5),
    Product.new('Headphones', 800, 'Electronics', 10),
    Product.new('T-Shirt', 200, 'Clothes', 20),
    Product.new('Jeans', 300, 'Clothes', 20),
    Product.new('Dress', 250, 'Clothes', 15),
    Product.new('Sofa', 10000, 'Furniture', 5),
    Product.new('Bed', 15000, 'Furniture', 5),
    Product.new('Table', 1000, 'Furniture', 10)
  ]

  def self.products
    @products
  end

  def self.products_by_category(category)
    @products.select { |product| product.category == category }
  end

  def self.list_products
    puts 'Product Listing:'
    categories = @products.map(&:category).uniq

    categories.each do |category|
      puts "Category: #{category}"
      category_products = @products.select { |product| product.category == category }
      category_products.each_with_index do |product, index|
        puts "#{index + 1}. Name: #{product.name}, Price: #{product.price}, Quantity: #{product.quantity}"
      end
      puts
    end
  end

  def self.search
    count = 0
    begin
      puts 'Enter the product name to search:'
      search_term = gets.chomp.downcase

      if search_term.empty? || search_term.strip.empty?
        raise Exception, 'Product name cannot be empty!'
      end

      found_products = @products.select { |product| product.name.downcase.include?(search_term) }

      if found_products.empty?
        puts 'No products found with the given name!'
      else
        puts 'Search Results:'
        found_products.each do |product|
          puts "Name: #{product.name}, Price: #{product.price}, Category: #{product.category}, Quantity: #{product.quantity}"
        end
      end
    rescue Exception => e
      count += 1
      if count >= 3
        puts 'Maximum invalid input attempts reached. Returning to the main menu.'
        return
      else
        puts e.message
        puts "Invalid input. Remaining attempts: #{3 - count}"
        retry
      end
    end
  end
end

