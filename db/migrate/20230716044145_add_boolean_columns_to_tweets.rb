class AddBooleanColumnsToTweets < ActiveRecord::Migration[7.0]
  def change
    add_column :tweets, :is_retweet, :boolean, default: false
    add_column :tweets, :is_quote_tweet, :boolean, default: false
    add_column :tweets, :is_reply, :boolean, default: false
  end
end
