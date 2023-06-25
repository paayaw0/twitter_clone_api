class Tweet < ApplicationRecord
  include ActiveModel::Validations

  has_one_attached :media

  validates_with TweetValidator
  validates :media, allow_blank: true, media_support: true
end
