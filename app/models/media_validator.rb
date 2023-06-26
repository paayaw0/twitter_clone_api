class MediaValidator < ActiveModel::EachValidator
  def validate_each(tweet, attribute, value)
    return unless value.attachment.blob.byte_size > 2.megabytes

    tweet.errors.add attribute, 'image size exceeds the 2MB limit!'
  end
end
