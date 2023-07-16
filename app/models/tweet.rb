class Tweet < ApplicationRecord
  include ActiveModel::Validations

  has_one_attached :media

  has_many :retweets, -> { where is_retweet: true },
           dependent: :destroy,
           class_name: 'Tweet',
           foreign_key: 'tweet_id'

  has_many :replies, -> { where is_reply: true },
           dependent: :destroy,
           class_name: 'Tweet',
           foreign_key: 'tweet_id'

  belongs_to :tweet, optional: true

  validates_with TweetValidator, unless: proc { |tweet| tweet.tweet_id.presence }
  validates :media, allow_blank: true, media_support: true, media: true
  validates :content, allow_blank: true, length: { maximum: 140, message: 'character limit of 140 exceeded!' }
end
