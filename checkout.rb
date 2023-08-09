require 'csv'

class Checkout
  ATTEMPTS = 3

  def checkout(user)
    count = 0
    puts 'Enter your shipping details:'

    begin
      puts 'Address:'
      user.shipping_details[:address] = gets.chomp
      if user.shipping_details[:address].empty? || user.shipping_details[:address].strip.empty?
        puts'Shipping address cannot be empty!'
        raise
      end
    rescue => e
      count += 1
      if count >= ATTEMPTS
        puts 'Maximum invalid input attempts for address reached. Returning to the main menu.'
        return
      else
        puts e.message
        retry
      end
    end

    begin
      puts 'City:'
      user.shipping_details[:city] = gets.chomp
      if user.shipping_details[:city].empty? || user.shipping_details[:city].strip.empty?
        puts 'City cannot be empty!'
        raise
        unless user.shipping_details[:city].match?(/\A[a-zA-Z]+\z/)
          puts 'Invalid city! City should contain only alphabetic characters.'
          raise
        end
      end
    rescue => e
      count += 1
      if count >= ATTEMPTS
        puts 'Maximum invalid input attempts for city reached. Returning to the main menu.'
        return
      else
        puts e.message
        retry
      end
    end

    begin
      puts 'Enter your payment details:'
      puts 'Card number:'
      user.payment_details[:card_number] = gets.chomp
      if user.payment_details[:card_number].empty? || user.payment_details[:card_number].strip.empty?
        puts 'Card number cannot be empty!'
        raise
      end
      unless user.payment_details[:card_number].match?(/\A\d+\z/)
        puts 'Invalid card number! Card number should contain only digits.'
      raise
      end
      unless user.payment_details[:card_number].length == 8
        puts 'Invalid card number! Card number should be exactly 8 digits.'
      end
    rescue => e
      count += 1
      if count >= ATTEMPTS
        puts 'Maximum invalid input attempts for card number reached. Returning to the main menu.'
        return
      else
        puts e.message
        retry
      end
    end

    begin
      puts 'CVV:'
      user.payment_details[:cvv] = gets.chomp
      if user.payment_details[:cvv].empty? || user.payment_details[:cvv].strip.empty?
        puts'CVV cannot be empty!'
        raise
      end
      unless user.payment_details[:cvv].match?(/\A\d+\z/)
        puts 'Invalid CVV! CVV should contain only digits.'
        raise
        unless user.payment_details[:cvv].length == 3
          puts'Invalid CVV! CVV should be exactly 3 digits.'
          raise
        end
      end
    rescue Exception => e
      count += 1
      if count >= ATTEMPTS
        puts 'Maximum invalid input attempts for CVV reached. Returning to the main menu.'
        return
      else
        puts e.message
        retry
      end
    end

    order = {
      cart: user.cart,
      shipping_details: user.shipping_details
    }
    user.order_history << order
    CSV.open('order_history.csv', 'a+') do |csv|
      order[:cart].each do |product|
        csv << [
          user.username,
          product.name,
          product.quantity,
          product.quantity * product.price,
          order[:shipping_details][:address],
          order[:shipping_details][:city],
        ]
      end
    end
    puts 'Thank you for your order!'
  end
end
