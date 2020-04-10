# frozen_string_literal: true

module TextInterface
    
  def new_username
    puts 'Please enter your name:'
    gets.chomp
  end
      
  def username_rule
    puts 'Please use only letters for your name'
  end
      
  def welcome(name)
    puts "#{name}, welcome to Black Jack! Let's play!"
  end
end
