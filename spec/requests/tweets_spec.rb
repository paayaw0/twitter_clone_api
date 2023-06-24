require 'rails_helper'

RSpec.describe 'Tweets', type: :request do
  let!(:tweet1) { create(:tweet, content: 'I love Rails') }
  let!(:tweet2) { create(:tweet, content: 'Ruby is awesome') }

  describe 'GET #index' do
    before { get '/tweets' }

    it 'should return all valid tweets' do
      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq(Tweet.all.size)
    end

    it 'should return a 200 status code' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET #show' do
    before { get "/tweets/#{tweet1.id}" }

    context 'for an existing tweet' do
      it 'should return a tweet with the correct id' do
        expect(json_response['id']).to eq(tweet1.id)
      end

      it 'should return a 200 status code' do
        expect(response).to have_http_status(200)
      end
    end

    context 'for a non-existing tweet' do
      let(:id) { 100 }

      before { get "/tweets/#{id}" }

      it 'should return status code of 404' do
        expect(response).to have_http_status(404)
      end

      it 'should return not found message' do
        expect(json_response['message']).to eq('Tweet not found')
      end
    end
  end

  describe 'POST #create' do
    context 'for valid params' do
      valid_params = { content: 'I want to explore the internals of Ruby' }

      before { post '/tweets', params: valid_params.to_json, headers: { "Content-Type": 'Application/json' } }

      it 'should return 201 status for code' do
        expect(response).to have_http_status(201)
      end

      it 'should return created tweet' do
        expect(json_response['content']).to eq(valid_params[:content])
      end
    end

    context 'for invalid params' do
      before { post '/tweets', params: {}.to_json, headers: { "Content-Type": 'Application/json' } }

      it 'should return status code of unprocessable_entity' do
        expect(response).to have_http_status(422)
      end

      it 'should return failure to create tweet message' do
        expect(json_response['message']).to eq('Validation failed: tweet can not be blank')
      end
    end
  end

  describe 'PATCH #update' do
    context 'for valid params' do
      valid_params = { content: 'I love Ruby on Rails!!!' }

      before do
        patch "/tweets/#{tweet1.id}", params: valid_params.to_json, headers: { "Content-Type": 'Application/json' }
      end

      it 'return 204 status code' do
        expect(response).to have_http_status(204)
      end

      it 'record should be updated' do
        expect(tweet1.reload.content).to eq(valid_params[:content])
      end
    end

    context 'for invalid params' do
      before do
        patch "/tweets/#{tweet1.id}", params: { content: nil }.to_json, headers: { "Content-Type": 'Application/json' }
      end

      it 'return 204 status code' do
        expect(response).to have_http_status(422)
      end

      it 'record should not be updated' do
        expect(tweet1.reload.content).to_not be_nil
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'should successfully delete tweet' do
      expect { delete "/tweets/#{tweet1.id}" }.to change(Tweet, :count).by(-1)
    end

    it 'should return 204 status code' do
      delete "/tweets/#{tweet1.id}"
      expect(response).to have_http_status(204)
    end
  end
end
