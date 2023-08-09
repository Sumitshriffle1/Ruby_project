require_relative 'cart'
require_relative 'admindashboard'
require_relative "storedata.rb"
require "io/console"

class Main
  MAX_ATTEMPTS = 3
  def initialize
    @storedata=StoreData.new
    @menu = AdminDashboard.new
  end

  def main
    puts "------Welcome to MyStore.com-------"
    loop do
      display_menu
      choice = gets.chomp.to_i
      case choice
      when 1
        registration
      when 2
        login
      when 3
        puts "\nExiting...."
        sleep 1
        puts "Thank you for visiting Mystore.com", "==" * 30, "\n"
        break
      else
        puts "Sorry invalid input"
      end
      puts
    end
  end

  def display_menu
    puts "1. Register"
    puts "2. Login"
    puts "3. Exit"
    print "Please select an option: "
  end

  def registration
    attempt = 0
    while attempt < MAX_ATTEMPTS
      print "Enter username: "
      username = gets.chomp
      if username.empty?
        attempt += 1
        puts "Username cannot be blank. Please try again."
      else
        break
      end
    end
    return if attempt == MAX_ATTEMPTS

    attempt = 0
    while attempt < MAX_ATTEMPTS
      print "Enter your email: "
      email = gets.chomp.strip.downcase
      return if email == '0'

      if email.match?(/\A[a-z][\w\d+\-.]+@[\w\d\-]+\.[a-z]{2,3}\z/)
        break
      else
        attempt += 1
        puts "\nInvalid email id! Please enter again.\n\n"
      end
    end
    return if attempt == MAX_ATTEMPTS

    attempt = 0
    while attempt < MAX_ATTEMPTS
      print "Enter password: "
      password = ''
      while char = STDIN.getch
        break if char == "\r" || char == "\n"
        if char == "\u007F" || char == "\b"
          if password.length > 0
            print "\b \b"
            password.chop!
          end
        else
          print '*'
          password += char
        end
      end

      if !password.empty?
        @storedata.register(username, password)
        break
      else
        attempt += 1
        puts "\nPassword cannot be blank. Please try again.\n\n"
      end
    end
  end

  def login
    attempt = 0
    while attempt < MAX_ATTEMPTS
      print "Enter username: "
      username = gets.chomp
      if username.empty?
        attempt += 1
        puts "Username cannot be blank. Please try again."
      else
        break
      end
    end
    return if attempt == MAX_ATTEMPTS

    attempt = 0
    while attempt < MAX_ATTEMPTS
      print "Enter password: "
      password = ''
      while char = STDIN.getch
        break if char == "\r" || char == "\n"
        if char == "\u007F" || char == "\b"
          if password.length > 0
            print "\b \b"
            password.chop!
          end
        else
          print '*'
          password += char
        end
      end

      if !password.empty?
        if username == "admin" && password == "admin@123"
          @menu.show_dashboard
        else
          puts
          @storedata.login(username, password)
        end
        break
      else
        attempt += 1
        puts "\nPassword cannot be blank. Please try again.\n\n"
      end
    end
  end
end
store = Main.new
store.main
