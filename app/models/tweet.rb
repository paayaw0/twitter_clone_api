class Tweet < ApplicationRecord
  include ActiveModel::Validations

  has_one_attached :media

  validates_with TweetValidator
end
