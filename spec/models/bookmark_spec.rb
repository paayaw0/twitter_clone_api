require 'rails_helper'

RSpec.describe Bookmark, type: :model do
  let(:bookmark) { build(:bookmark) }

  context 'test associations' do
    it { should belong_to(:tweet) }
  end
end
