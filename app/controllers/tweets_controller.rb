class TweetsController < ApplicationController
  before_action :set_tweet, only: %i[show update destroy retweet]

  def index
    @tweets = Tweet.all
    json_response(@tweets)
  end

  def show
    json_response(@tweet)
  end

  def create
    @tweet = Tweet.create!(tweet_params)
    json_response(@tweet, :created)
  rescue ActiveRecord::RecordInvalid => e
    json_response({ message: e.message }, :unprocessable_entity)
  end

  def update
    @tweet.update!(tweet_params)
    head :no_content
  rescue ActiveRecord::RecordInvalid => e
    json_response({ message: e.message }, :unprocessable_entity)
  end

  def destroy
    @tweet.destroy
    head :no_content
  end

  def retweet
    @retweet = @tweet.retweets.create!(tweet_params)
    json_response(@retweet, :created)
  rescue ActiveRecord::RecordInvalid => e
    json_response({ message: e.message }, :unprocessable_entity)
  end

  private

  def set_tweet
    @tweet = Tweet.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    json_response({ message: 'Tweet not found' }, :not_found)
  end

  def tweet_params
    params.permit(:content, :media)
  end
end
