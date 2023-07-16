class BookmarksController < ApplicationController
  def create
    tweet = Tweet.find(bookmarks_params[:tweet_id])

    bookmark = tweet.bookmarks.create!
    json_response(bookmark, :created)
  rescue ActiveRecord::RecordInvalid => e
    json_response({ message: e.message }, :unprocessable_entity)
  end

  private

  def bookmarks_params
    params.require(:bookmark).permit(:tweet_id)
  end
end
