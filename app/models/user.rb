class User < ApplicationRecord
	before_save { self.email = email.downcase } # Prefixing with 'self' is optional only on the right hand side of the assignment
	validates :name, presence: true, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 255 },
					  format: { with: VALID_EMAIL_REGEX },
					  uniqueness: { case_sensitive: false } # Rails infers that uniqueness itself is 'true' from this listing
	has_secure_password
	validates :password, presence: true, length: { minimum: 6 }
end
