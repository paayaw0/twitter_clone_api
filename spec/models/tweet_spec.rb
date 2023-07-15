require 'rails_helper'

RSpec.describe Tweet, type: :model do
  let(:tweet) { build(:tweet) }

  context 'test associations' do
    it { should have_one_attached(:media) }
    it { should have_many(:retweets).dependent(:destroy).class_name('Tweet').with_foreign_key('tweet_id') }
    it { should belong_to(:tweet).optional }
  end

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

  context 'character limit to content' do
    before do
      tweet.content = 'But I must explain to you how all this mistaken idea of denouncing pleasure
      and praising pain was born and I will give you a complete account of the system, and 
      expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. 
      No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not 
      know how to pursue pleasure rationally encounter consequences that are extremely painful. Nor again is there 
      anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally 
      circumstances occur in which toil and pain can procure him some great pleasure. To take a trivial example, which 
      of us ever undertakes laborious physical exercise, except to obtain some advantage from it? But who has any right 
      to find fault with a man who chooses to enjoy a pleasure that has no annoying consequences, or one who avoids a pain 
      that produces no resultant pleasure?'
    end

    it 'raise error when limit is exceeded' do
      expect{ tweet.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'tweet object should have error message' do
      tweet.save
      expect(tweet.errors.messages[:content].first).to eq('character limit of 140 exceeded!')
    end
  end

  context '2MB size limit on images' do
    let(:path) { File.open(Rails.root.join('sample_media', 'sample_image1.jpg')) }
    let(:image) { fixture_file_upload(path, 'image/jpeg') }

    before { tweet.media.attach(image) }

    it 'raises error when size limit is exceeded' do
      expect{ tweet.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'tweet object should have error message' do
      tweet.save
      expect(tweet.errors.messages[:media].first).to eq('image size exceeds the 2MB limit!')
    end
  end
end
