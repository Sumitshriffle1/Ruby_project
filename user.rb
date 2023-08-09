class User
  attr_accessor :username, :password, :cart, :shipping_details, :payment_details, :order_history

  def initialize(username, password)
    @username = username
    @password = password
    @cart = []
    @shipping_details = {}
    @payment_details = {}
    @order_history = []  
  end
end