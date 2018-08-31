class User < ApplicationRecord
	attr_accessor :remember_token
	before_save { self.email = email.downcase } # Prefixing with 'self' is optional only on the right hand side of the assignment
	validates :name, presence: true, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 255 },
					  format: { with: VALID_EMAIL_REGEX },
					  uniqueness: { case_sensitive: false } # Rails infers that uniqueness itself is 'true' from this listing
	has_secure_password
	validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
	# The 'allow_nil' clause will allow users to omit the password when updating details
	# New users will still have to submit a valid password upon signing up because
	# of the built-in validation in 'has_secure_password'
	

	# Returns the has digest of the given string.
	# Although different digests will be returned for identical inputs,
	# If the original token is identical then upon authentication at the 'authendicated?'
	# method below both digests will return true for the original token
	def User.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
													  BCrypt::Engine.cost
		BCrypt::Password.create(string, cost: cost)
	end

	# Returns a random token
	def User.new_token
		SecureRandom.urlsafe_base64 # a 22-character random token
	end

	# Remembers a user in the database for use in presistent sessions
	def remember
		self.remember_token = User.new_token
		# 'update_attribute' relieves me of the requirement to provide password when updating
		update_attribute(:remember_digest, User.digest(remember_token))
	end

	# Returns true if the given token matches the digest
	def authenticated?(remember_token)
		# 'remember_digest' is in fact 'self.remember_digest' and is generated automatically
		# by active record based on the name of the corresponding database column
		return false if remember_digest.nil?
		BCrypt::Password.new(remember_digest).is_password?(remember_token)
	end

	# Forgets a user
	def forget
		update_attribute(:remember_digest, nil)
	end
end
