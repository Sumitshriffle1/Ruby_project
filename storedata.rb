require 'csv'
require_relative 'user.rb'
require_relative 'userdashboard.rb'
class StoreData
  attr_accessor :users, :products, :orders
  def initialize
    @users = []
    @menu=UserDashboard.new
    load_users_from_csv
  end

  def validate_username(username)
    if username.empty?
      false
    elsif users.any? { |user| user.username == username }
      puts "Username already exists."
      false
    else
      true
    end
  end

  def validate_password(password)
    if password.length >= 5 &&  password =~ /[0-9]/
      true
    else
      puts "\n The password must be at least 5 characters long."
      false
    end
  end


  def register(username, password)
    if validate_username(username) && validate_password(password)
      user = User.new(username, password)
      @users << user

      puts "Registration successful! Please login."
      save_users_to_csv
    else
      puts "Invalid username or password. \n\n Please try again."
    end
  end

  def save_users_to_csv
    CSV.open('users.csv', 'w') do |csv|
      csv << ['username', 'password']
      @users.each do |user|
        csv << [user.username, user.password]
      end
    end
  end

  def load_users_from_csv
    CSV.foreach('users.csv', headers: true) do |row|
      @users << User.new(row['username'], row['password'])
    end
  end

  def login(username, password)
    user = users.find { |u| u.username == username && u.password == password }
    if user
      puts "Login successful! Welcome, #{user.username}!"
      @menu.show_dashboard(user)
    else
      puts "Invalid username or password"
    end
  end
end

