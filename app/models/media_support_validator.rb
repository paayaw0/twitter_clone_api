class MediaSupportValidator < ActiveModel::EachValidator
  SUPPORTED_MEDIA = ['image/jpg', 'image/png', 'image/jpeg'].freeze

  def validate_each(tweet, attribute, value)
    return if SUPPORTED_MEDIA.include?(value.attachment.blob.content_type)

    tweet.errors.add(attribute, 'is not a supported media type')
  end
end
