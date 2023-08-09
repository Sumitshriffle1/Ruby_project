require_relative 'helper.rb'
require_relative 'productlist'

class AdminDashboard
  ATTEMPTS = 3
  def initialize
    @categories = ['Electronics', 'Clothes', 'Furniture']
  end

  def show_dashboard
    loop do
      puts 'Admin Dashboard:'
      puts '1. List Products'
      puts '2. Add Product'
      puts '3. Delete Product'
      puts '4. Update Product'
      puts '5. Add Category'
      puts '6. View Orders'
      puts '7. Manage Users'
      puts '8. Logout'
      choice = gets.chomp.to_i

      case choice
      when 1
        ProductList.list_products
      when 2
        add_product
      when 3
        Helper.new.delete_product
      when 4
        update_product
      when 5
        add_category
      when 6
        Helper.new.view_order_history_admin
      when 7
        Helper.new.delete_user
      when 8
        puts 'Logged out from Admin Dashboard'
        break
      else
        puts 'Invalid choice!'
      end
    end
  end

  def get_valid_input(put)
    attempts = 0
    input = nil

    while attempts < ATTEMPTS
      puts put
      input = gets.chomp

      if input.empty? || input.strip.empty?
        attempts += 1
        puts 'Input cannot be empty!'
      else
        break
      end
    end

    if attempts >= ATTEMPTS
      puts "Invalid input! You've exceeded the maximum attempts."
      return nil
    end

    input
  end

  def add_category
    new_category = get_valid_input('Enter the new category:')
    return if new_category.nil?

    if @categories.include?(new_category)
      puts "Category '#{new_category}' already exists!"
      return
    end

    @categories << new_category

    puts "Category '#{new_category}' added successfully!"
    puts "\nUpdated Categories:"
    @categories.each_with_index do |category, index|
      puts "#{index + 1}. #{category}"
    end
  end

  def add_product
    name = get_valid_input('Enter the product name:')
    return if name.nil?

    if ProductList.products.any? { |product| product.name.downcase == name.downcase }
      puts "A product with the name '#{name}' already exists!"
      return
    end

    attempts = 0
    price = nil

    while attempts < ATTEMPTS
      begin
        print 'Enter the product price:'
        price = gets.chomp.to_i
        break
      rescue ArgumentError
        attempts += 1
        puts "Invalid input! Please enter a integer value."
      end
    end

    if attempts >= ATTEMPTS
      puts "Invalid input! You've exceeded the maximum attempts."
      return
    end

    category = get_valid_input('Enter the product category:')
    return if category.nil?

    if !@categories.include?(category)
      puts "Invalid category! Available categories: #{@categories.join(', ')}"
      return
    end

    quantity = get_valid_input('Enter the product quantity:')
    return if quantity.nil?

    quantity = quantity.to_i
    if quantity <= 0
      puts 'Invalid quantity! Quantity should be greater than 0.'
      return
    end

    new_product = Product.new(name, price, category, quantity)
    ProductList.products << new_product

    puts "#{new_product.name} added successfully!"
  end

  def update_product
    name = get_valid_input('Enter the name of the product to update:')
    return if name.nil?

    product = ProductList.products.find { |product| product.name.downcase == name.downcase }

    if product.nil?
      puts "Product with the name '#{name}' not found!"
    else
      new_name = get_valid_input("Enter the new name for the product (currently: #{product.name}):")

      attempts = 0
      new_price = nil

      while attempts < ATTEMPTS
        begin
          print 'Enter the product price:'
          new_price = gets.chomp.to_i
          break
        rescue ArgumentError
          attempts += 1
          puts "Invalid input! Please enter a integer value."
        end
      end

      return if attempts >= ATTEMPTS

      category = get_valid_input("Enter the category for the product (currently: #{product.category}):")

      categories = ['Electronics', 'Clothes', 'Furniture']

      unless categories.include?(category)
        puts "Invalid category! Available categories: #{categories.join(', ')}"
        return
      end

      product.name = new_name unless new_name.nil?
      product.price = new_price unless new_price.nil?
      product.category = category unless category.nil? || category.strip.empty?

      puts "Product '#{name}' updated successfully!"
    end
  end
end
