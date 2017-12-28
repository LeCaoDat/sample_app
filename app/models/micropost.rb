class Micropost < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.micropost_models.max_length_content}
  validate  :picture_size
  scope :created_at_desc, ->{order created_at: :desc}
  mount_uploader :picture, PictureUploader

  private

  def picture_size
    return unless picture.size > Settings.micropost_models.max_size_image_file.megabytes
    errors.add :picture, I18n.t("shared.micropost_form.image_oversize")
  end
end
