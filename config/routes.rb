Civiccommons::Application.routes.draw do

  devise_for :people,
             :controllers => { :registrations => 'registrations', :confirmations => 'confirmations' },
             :path_names => { :sign_in => 'login', :sign_out => 'logout', :password => 'secret', :confirmation => 'verification', :registration => 'register', :sign_up => 'new' }

  resources :events

  resources :ratings

  resources :contributions do
    # This is a GET for now since PA will redirect back with the required bits to create a PA
    # contribution. 
    get "create_from_pa", :on => :collection
  end
  match '/contributions/moderate/:id', :to => 'contributions#moderate_contribution', :as => 'moderate_contribution', :via => [:delete]

  resources :answers

  resources :issues do
    post 'create_contribution', :on => :member
  end

  resources :links

  match '/conversations/dialog/:id', :to=>'conversations#dialog', :via=>[:get]
  match '/contributions/create_confirmed_contribution', :to=>'contributions#create_confirmed_contribution', :via=>[:post]
  match '/conversations/node_conversation', :to=>'conversations#node_conversation', :via=>[:get]
  match '/conversations/node_permalink/:id', :to=>'conversations#node_permalink', :via=>[:get]
  match '/conversations/confirm_node_contribution', :to=>'conversations#confirm_node_contribution', :via=>[:put]  
  match '/conversations/new_node_contribution', :to=>'conversations#new_node_contribution', :via=>[:get]
  match '/conversations/edit_node_contribution', :to=>'conversations#edit_node_contribution', :via=>[:get]
  match '/conversations/update_node_contribution', :to=>'conversations#update_node_contribution', :via=>[:put]  
  match '/conversations/preview_node_contribution', :to=>'conversations#preview_node_contribution', :via=>[:post,:put]
  match '/conversations/rate_contribution', :to=>'conversations#rate_contribution'#, :via=>[:post]
  match '/conversations/rate', :to=>'conversations#rate', :via=>[:post]
  match '/subscriptions/subscribe', :to=>'subscriptions#subscribe', :via=>[:post]
  match '/subscriptions/unsubscribe', :to=>'subscriptions#unsubscribe', :via=>[:post]

  # Static pages
  get '/about', :to=>'static_pages#about'
  get '/faq', :to=>'static_pages#faq'
  get '/principles', :to=>'static_pages#principles'
  get '/team', :to=>'static_pages#team'
  get '/partners', :to=>'static_pages#partners'
  get '/terms', :to=>'static_pages#terms'
  get '/build-the-commons', :to=>'static_pages#build_the_commons'
  get '/contact-us', :to=>'static_pages#contact'
  get '/posters', :to=>'static_pages#poster'
  get '/poster', :to=>'static_pages#poster'
  get '/polls', :to => 'polls#index'
  post '/polls', :to => 'polls#create'
  
  resources :conversations
  resources :regions   
  namespace "admin" do
    resources   :articles
    resources   :conversations
    resources   :simple_conversations
    resources   :issues
    resources   :regions
    resources   :people do
      get 'proxies', :on => :collection
      put 'lock_access', :on => :member
      put 'unlock_access', :on => :member
    end
    root        :to => "dashboard#show"
  end
  

  namespace "api" do
    match "/:id/conversations", :to => "conversations#index", :via => [:get], :format => :json
    match "/:id/issues",        :to => "issues#index",        :via => [:get], :format => :json
    match "/:id/contributions", :to => "contributions#index", :via => [:get], :format => :json
    match "/people-aggregator/person/:id/subscriptions", :to => "subscriptions#index", :via => [:get], :format => :json
    get '/people-aggregator/person/:id/contributions', :to => 'contributions#index', :format => :json
    put '/people-aggregator/person/:people_aggregator_id', :to => 'people#update', :format => :json
  end


  resources :questions
  
  match '/top_items/newest', :to=>'top_items#newest', :as =>'newest_items'
  match '/top_items/highest_rated', :to=>'top_items#highest_rated', :as =>'highest_rated_items'
  match '/top_items/most_visited', :to=>'top_items#most_visited', :as =>'most_visited_items'

  match '/mockup/:template_name', :to => 'mockups#show', :as => 'mockup'

  match '/mockups_index', :to => 'mockups#index', :as => 'mockups_index'

  match '/mockups', :to => 'mockups#frameset', :as => 'mockups'
  match '/widget', :to => "widget#index"

  resources :people

  root :to => "homepage#show"
end
