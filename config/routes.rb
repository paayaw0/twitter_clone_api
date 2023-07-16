Rails.application.routes.draw do
  resources :tweets
  resources :likes, only: [:create]
  resources :bookmarks, only: [:create]

  post '/tweets/:id/retweets', to: 'tweets#retweet', as: :retweets
  post '/tweets/:id/quote_tweets', to: 'tweets#quote_tweet', as: :quote_tweets
  post '/tweets/:id/replies', to: 'tweets#reply_tweet', as: :replies
end
