require 'rails_helper'

RSpec.describe Tweet, type: :model do
  let(:tweet) { build(:tweet) }

  context "a tweet should" do
    it "not be valid" do
      expect(tweet).to_not be_valid
    end

    it "tweet object should contain error" do
      tweet.save
      expect(tweet.errors.messages[:base].first).to eq "tweet can not be blank"
    end

    it "raise an ActiveRecord::Invalid Error for blank tweet" do
      expect { tweet.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "should be valid with either attributes present" do
      tweet.content = "some content"
      expect(tweet).to be_valid
    end
  end
end
