Civiccommons::Application.routes.draw do
  devise_for :people,
             :controllers => { :registrations => 'registrations' },
             :path_names => { :sign_in => 'login', :sign_out => 'logout', :password => 'secret', :confirmation => 'verification', :unlock => 'unblock', :registration => 'register', :sign_up => 'new' }

  resources :events

  resources :ratings

  resources :comments

  resources :answers

  resources :issues

  resources :conversations  do
    member do
      post :create_post
    end
    resources :post_comments
  end

  match '/conversations/rate', :to=>'conversations#rate', :via=>[:post]
  
  resources :post_comments  
  resources :post_questions  
  
  resources :questions
  
  match '/top_items/newest', :to=>'top_items#newest', :as =>'newest_items'
  match '/top_items/highest_rated', :to=>'top_items#highest_rated', :as =>'highest_rated_items'
  match '/top_items/most_visited', :to=>'top_items#most_visited', :as =>'most_visited_items'

  match '/mockup/:template_name', :to => 'mockups#show', :as => 'mockup'

  match '/mockups_index', :to => 'mockups#index', :as => 'mockups_index'

  match '/mockups', :to => 'mockups#frameset', :as => 'mockups'


  resources :people

  root :to => "homepage#show"
end
