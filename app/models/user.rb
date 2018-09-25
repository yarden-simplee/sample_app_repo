class User < ApplicationRecord
	has_many :microposts, dependent: :destroy # The 'dependent' clause makes sure a user's microposts are destroyed along with it
	has_many :active_relationships, class_name:  "Relationship", # We have to tell rails the class name here specfically because the class is named 'Relationship' and we name the association 'active_relationship'. They don't match. 
                                  	foreign_key: "follower_id",
                                  	dependent:   :destroy
    has_many :passive_relationships, class_name:  "Relationship", # # We have to tell rails the class name here specfically because the class is named 'Relationship' and we name the association 'passive_relationship'. They don't match. 
    								 foreign_key: "followed_id",
    								 dependent:   :destroy  
   	has_many :following, through: :active_relationships, source: :followed # Since we want to use 'following' instead of 'followeds' for readability, we override the default using the 'source' parameter that specifies that the source of the 'following' array is the set of followed ids
   	has_many :followers, through: :passive_relationships, source: :follower # Here, the ':source' key could actually be omitted. Rails will singularize "followers" and automatically look for the foreign key 'follower_id'
	attr_accessor :remember_token, :activation_token, :reset_token
	before_save :downcase_email # automatically called before each 'create' and 'update' operation on the database
	before_create :create_activation_digest # automatically called only before 'create' operations on the database
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
	def authenticated?(attribute, token)
		# 'send' (in fact its 'self.send' but 'self can be omitted in this context')
		# is a method that receives a method name, either in symbol or string format,
		# and applies it to the base argument (in this case, 'self').
		# String interpolation is used because we only know whether it's 
		# the user's remember token or activation token at run time. Symbols are interpolated as strings.
		digest = send("#{attribute}_digest")
		return false if digest.nil?
		BCrypt::Password.new(digest).is_password?(token)
	end

	# Forgets a user
	def forget
		update_attribute(:remember_digest, nil)
	end

	# Activates an account.
	def activate
		update_columns(activated: true, activated_at: Time.zone.now)
	end

	# Sends activation email.
	def send_activation_email
		UserMailer.account_activation(self).deliver_now
	end

	# Sends password reset email.
	def send_password_reset_email
	  UserMailer.password_reset(self).deliver_now
	end

	# Sets the password reset attributes
	def create_reset_digest
		self.reset_token = User.new_token
		update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
	end

	# Returns true if a password reset has expired.
	def password_reset_expired?
		reset_sent_at < 2.hours.ago
	end

	# Returns a user's status feed.
	def feed
		# Using a sub-select is more efficient. The entire query is performed in the database.
		following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    	Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
	end

	# Follows a user
	def follow(other_user)
		following << other_user # Appends 'other_user' to the end of the array
	end

	# Unfollows a user
	def unfollow(other_user)
		following.delete(other_user)
	end

	# Returns true if the current user is following the other user.
	def following?(other_user)
		following.include?(other_user)
	end

	private

	# Converts email to all lower-case.
	def downcase_email
		self.email.downcase!
	end

	# Creates and assigns the activation token and digest
	def create_activation_digest
		self.activation_token = User.new_token
		# Since the user model has an 'activation_digest' attribute,
		# the following will be automatically saved to the database upon user creation
		self.activation_digest = User.digest(activation_token)
	end

end
