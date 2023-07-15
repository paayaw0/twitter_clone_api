class Tweet < ApplicationRecord
  include ActiveModel::Validations

  has_one_attached :media

  has_many :retweets, dependent: :destroy, class_name: 'Tweet', foreign_key: 'tweet_id'
  belongs_to :tweet, optional: true

  validates_with TweetValidator
  validates :media, allow_blank: true, media_support: true, media: true
  validates :content, allow_blank: true, length: { maximum: 140, message: 'character limit of 140 exceeded!' }
end
