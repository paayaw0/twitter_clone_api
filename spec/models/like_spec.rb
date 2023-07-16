require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:like) { build(:like) }

  context 'test associations' do
    it { should belong_to(:tweet) }
  end
end
