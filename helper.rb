class Helper
  ATTEMPTS = 3

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

  def delete_product
    attempts = 0
    loop do
      name = get_valid_input('Enter the name of the product to delete:')
      return if name.nil?

      product = ProductList.products.find { |product| product.name.downcase == name.downcase }

      if product.nil?
        puts "Product with the name '#{name}' not found!"
        attempts += 1
      else
        ProductList.products.delete(product)
        puts "Product '#{name}' deleted successfully!"
        break
      end

      if attempts >= ATTEMPTS
        puts "Invalid product name! You've exceeded the maximum attempts."
        break
      end
    end
  end

  def view_order_history_admin
    csv_file = 'order_history.csv'
      if File.exist?(csv_file)
        puts 'Order History:'
        CSV.foreach(csv_file) do |row|
          puts "Username: #{row[0]}"
          puts "Product Name: #{row[1]}"
          puts "Quantity : #{row[2]}"
          puts "Total Amount: #{row[3]}"
          puts "Address: #{row[4]}"
          puts "City: #{row[5]}"
          puts '--'*20
        end
      else
        puts 'No orders found.'
      end
  end

  def delete_user
    users = []

    CSV.foreach('users.csv', headers: true) do |row|
      users << row['username']
    end

    if users.empty?
      puts "No users found in the system."
      return
    end

    puts "List of Users:"
    users.each_with_index do |username, index|
      puts "#{index + 1}. #{username}"
    end

    attempts = 0
    user_number = nil

    while attempts < ATTEMPTS
      user_number = get_valid_input("Enter the number of the user you want to delete:")
      return if user_number.nil?

      user_number = user_number.to_i

      if user_number < 1 || user_number > users.size
        attempts += 1
        puts "Invalid user number!"
      else
        break
      end
    end

    if attempts >= ATTEMPTS
      puts "Invalid user number! You've exceeded the maximum attempts."
      return
    end

    username_to_delete = users[user_number - 1]

    if confirm_deletion(username_to_delete)
      delete_user_from_csv(username_to_delete)
      puts "User '#{username_to_delete}' has been deleted successfully!"
    else
      puts "Deletion canceled."
    end
  end

  def confirm_deletion(username)
    puts "Are you sure you want to delete user '#{username}'? (yes/no)"
    confirmation = gets.chomp.downcase
    confirmation == 'yes'
  end

  def delete_user_from_csv(username)
    rows = []

    CSV.foreach('users.csv', headers: true) do |row|
      rows << row unless row['username'] == username
    end

    CSV.open('users.csv', 'w') do |csv|
      csv << ['username', 'password']
      rows.each do |row|
        csv << [row['username'], row['password']]
      end
    end
  end
end
