require 'rails_helper'

RSpec.describe Tweet, type: :model do
  let(:tweet) { build(:tweet) }

  context 'a tweet should' do
    it 'not be valid' do
      expect(tweet).to_not be_valid
    end

    it 'tweet object should contain error' do
      tweet.save
      expect(tweet.errors.messages[:base].first).to eq 'tweet can not be blank'
    end

    it 'raise an ActiveRecord::Invalid Error for blank tweet' do
      expect { tweet.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    context 'should be valid with either attributes present' do
      it 'when only content is present' do
        tweet.content = 'some content'
        expect(tweet).to be_valid
      end

      it 'when only media is uploaded' do
        path = File.open(Rails.root.join('sample_media', 'sample_image.jpg'))
        image = fixture_file_upload(path, 'image/jpeg')
        tweet.media.attach(image)
        tweet.save

        expect(tweet).to be_valid
      end
    end
  end

  context 'media type validation' do
    context 'no support for' do
      let(:path) { File.open(Rails.root.join('sample_media', 'sample_csv.csv')) }
      let(:csv) { fixture_file_upload(path, 'text/csv') }

      before { tweet.media.attach(csv) }

      it 'csv files' do
        tweet.save

        expect(tweet).to_not be_valid
      end

      it 'raise error' do
        expect { tweet.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'tweet object should have error message' do
        tweet.save
        expect(tweet.errors.messages[:media].first).to eq 'is not a supported media type'
      end
    end

    context 'support for' do
      let(:path) { File.open(Rails.root.join('sample_media', 'sample_image.jpg')) }
      let(:image) { fixture_file_upload(path, 'image/jpeg') }

      it 'image files' do
        tweet.media.attach(image)
        tweet.save

        expect(tweet).to be_valid
      end
    end
  end
end
