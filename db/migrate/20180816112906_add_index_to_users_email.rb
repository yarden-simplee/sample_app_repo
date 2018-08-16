class AddIndexToUsersEmail < ActiveRecord::Migration[5.1]
  def change
  	# Enforce uniqueness at database level (and not just at memory level)
  	# This is to prevent a edge-scenario in which two Identical emails will
  	# make their way to the database despite uniqueness constraint at memory level
  	add_index :users, :email, unique: true # 'users' table, 'email' column, enforce uniqueness
  end
end
