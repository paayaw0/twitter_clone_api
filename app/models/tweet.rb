class Tweet < ApplicationRecord
  include ActiveModel::Validations

  has_one_attached :media

  validates_with TweetValidator
  validates :media, allow_blank: true, media_support: true, media: true
  validates :content, allow_blank: true, length: { maximum: 140, message: 'character limit of 140 exceeded!' }
end
