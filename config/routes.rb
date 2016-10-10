Rails.application.routes.draw do

  get 'game', to: 'game#play'

  get 'score', to: 'game#score'

  root to: 'game#play'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
