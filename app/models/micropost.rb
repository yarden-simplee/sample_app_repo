class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) } # Orders rails to retrieve the microposts from the dastabase by 'created_at' in descending order so that the newest post will be shown at the top
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate  :picture_size # Note the use of 'validate' instead of 'validates' when a custom validation

  private

  # Validates the size of an uploaded picture.
  def picture_size
  	if picture.size > 5.megabytes
  		errors.add(:picture, "should be less than 5MB")
  	end
  end

end
