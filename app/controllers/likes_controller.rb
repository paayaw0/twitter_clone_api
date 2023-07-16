class LikesController < ApplicationController
  def create
    tweet = Tweet.find(likes_params[:tweet_id])

    like = tweet.likes.create!
    json_response(like, :created)
  rescue ActiveRecord::RecordInvalid => e
    json_response({ message: e.message }, :unprocessable_entity)
  end

  private

  def likes_params
    params.require(:like).permit(:tweet_id)
  end
end
