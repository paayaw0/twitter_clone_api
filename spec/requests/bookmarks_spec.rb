require 'rails_helper'

RSpec.describe "Bookmarks", type: :request do
  let!(:tweet1) { create(:tweet, content: 'I love Rails') }

  describe 'POST #create' do
    let!(:valid_params)  { { tweet_id: tweet1.id } }

    before { post '/bookmarks', params: valid_params.to_json, headers: { "Content-Type": "Application/json" } }

    it 'should return 201 status code' do
      expect(response).to have_http_status(201)
    end

    it 'should return created bookmark' do
      expect(json_response['id']).to eq(tweet1.bookmarks.first.id)
      expect(json_response['tweet_id']).to eq(tweet1.id)
    end
  end
end
