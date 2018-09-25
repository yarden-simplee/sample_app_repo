class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User" # We need to specify the class_name here because it and the association name don't match.
  belongs_to :followed, class_name: "User"
  validates :follower_id, presence: true
  validates :followed_id, presence: true
end
