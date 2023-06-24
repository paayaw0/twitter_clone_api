class TweetsController < ApplicationController
  before_action :set_tweet, only: %i[show update destroy]

  def index
    @tweets = Tweet.all
    render json: @tweets, status: :ok
  end

  def show
    render json: @tweet, status: :ok
  end

  def create
    @tweet = Tweet.create!(tweet_params)
    render json: @tweet, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { message: e.message }, status: :unprocessable_entity
  end

  def update
    @tweet.update!(tweet_params)
    head :no_content
  rescue ActiveRecord::RecordInvalid => e
    render json: { message: e.message }, status: :unprocessable_entity
  end

  def destroy
    @tweet.destroy
    head :no_content
  end

  private

  def set_tweet
    @tweet = Tweet.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { message: 'Tweet not found' }, status: :not_found
  end

  def tweet_params
    params.permit(:content, :media)
  end
end
