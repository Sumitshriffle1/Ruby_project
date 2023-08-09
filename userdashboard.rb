require_relative 'productlist.rb'
require_relative 'cart.rb'
require_relative 'checkout.rb'
class UserDashboard
  def show_dashboard(user)
    loop do
      puts 'User Dashboard:'
      puts '1. List Products'
      puts '2. Search Product'
      puts '3. Add to Cart'
      puts '4. View Cart'
      puts '5. Checkout'
      puts '6. View Order History'
      puts '7. Logout'
      choice = gets.chomp.to_i

      case choice
      when 1
        ProductList.list_products
      when 2
        ProductList.search
      when 3
        Cart.new.add_to_cart(user)
      when 4
        Cart.new.view_cart(user)
      when 5
        Checkout.new.checkout(user)
      when 6
        Cart.new.view_order_history(user)
      when 7
        puts 'Logged out from User Dashboard.'
        break
      else
        puts 'Invalid choice!'
      end
      puts
    end
  end
end
