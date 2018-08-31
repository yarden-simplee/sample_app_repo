class User
  attr_accessor :name, :email

  def initialize(attributes = {})
  	name = attributes[:name]
    @first_name  = name.split(' ')[0]
    @last_name = name.split(' ')[1]
    @email = attributes[:email]
  end

  def full_name
  	"#{@first_name} #{@last_name}"
  end

  def formatted_email
    "#{self.full_name} <#{@email}>"
  end

  def alphabetical_name
  	"#{@last_name}, #{@first_name}"
  end
end