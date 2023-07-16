Rails.application.routes.draw do
  resources :tweets
  post "/tweets/:id/retweets", to: "tweets#retweet", as: :retweets
end
