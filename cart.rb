require 'csv'
require_relative 'productlist.rb'
class Cart
  ATTEMPTS = 3
  def add_to_cart(user)
    puts 'Enter the index of the category to view products:'
    puts '1. Electronics'
    puts '2. Clothes'
    puts '3. Furniture'
    category_choice = gets.chomp.to_i

    products = case category_choice
      when 1
        ProductList.products_by_category('Electronics')
      when 2
        ProductList.products_by_category('Clothes')
      when 3
        ProductList.products_by_category('Furniture')
      else
        puts 'Invalid category choice!'
        return
    end

    if products.empty?
      puts 'No products found for the selected category!'
      return
    end

    attempts = 0
    product_index = nil
    while attempts < ATTEMPTS
      puts 'Enter the index of the product to add to your cart:'
      product_index = gets.chomp.to_i - 1

      if product_index < 0 || product_index >= products.length
        attempts += 1
        puts 'Invalid product index!'
      else
        break
      end
    end

    if attempts >= ATTEMPTS
      puts "Invalid product index! You've exceeded the maximum attempts."
      return
    end

    selected_product = products[product_index]

    puts 'Enter the quantity to add to your cart:'
    quantity = gets.chomp.to_i

    attempts = 0
    while quantity <= 0 && attempts < ATTEMPTS
      puts 'Invalid quantity! Please enter a valid quantity .'
      quantity = gets.chomp.to_i
      attempts += 1
    end

    if quantity <= 0
      puts "Invalid quantity! You've exceeded the maximum attempts."
      return
    end

    if quantity > selected_product.quantity
      puts 'Insufficient quantity!'
      return
    end

    selected_product.quantity -= quantity

    product_in_cart = selected_product.dup
    product_in_cart.quantity = quantity

    user.cart << product_in_cart
    puts "#{quantity} #{selected_product.name} added to your cart!"
    total_amount = selected_product.price * quantity
    puts "Total amount: $#{total_amount}"
  end

  def view_cart(user)
    puts 'Your Cart:'
    if user.cart.empty?
      puts 'Your cart is empty.'
    else
      total_amount = 0
      user.cart.each do |product|
        total_price = product.price * product.quantity
        total_amount += total_price
        puts "Name: #{product.name}, Price: #{product.price}, Quantity: #{product.quantity}, Total Price: $#{total_amount}"
      end
    end
  end

  def view_order_history(user)
    csv_file = 'order_history.csv'
    if File.exist?(csv_file)
      puts 'Order History:'
      CSV.foreach(csv_file) do |row|
        if user.username == row[0]
          puts "Username: #{row[0]}"
          puts "Product Name: #{row[1]}"
          puts "Quantity : #{row[2]}"
          puts "Total Amount: #{row[3]}"
          puts "Address: #{row[4]}"
          puts "City: #{row[5]}"
          puts '--'*20
        end
      end
    else
      puts 'No orders found.'
    end
  end
end
