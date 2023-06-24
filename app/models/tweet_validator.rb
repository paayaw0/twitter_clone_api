class TweetValidator < ActiveModel::Validator
  def validate(tweet)
    return unless tweet.content.nil? && tweet.media.blank?

    tweet.errors.add(:base, 'tweet can not be blank')
  end
end
