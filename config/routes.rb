Civiccommons::Application.routes.draw do

  devise_for :people,
             :controllers => { :registrations => 'registrations', :confirmations => 'confirmations' },
             :path_names => { :sign_in => 'login', :sign_out => 'logout', :password => 'secret', :confirmation => 'verification', :unlock => 'unblock', :registration => 'register', :sign_up => 'new' }

  resources :events

  resources :ratings

  resources :contributions do
    # This is a GET for now since PA will redirect back with the required bits to create a PA
    # contribution. 
    get "create_from_pa", :on => :collection
  end

  resources :answers

  resources :issues do
    post 'create_contribution', :on => :member
  end

  resources :links

  match '/conversations/node_conversation', :to=>'conversations#node_conversation', :via=>[:get]
  match '/conversations/create_node_contribution', :to=>'conversations#create_node_contribution', :via=>[:put]  
  match '/conversations/new_node_contribution', :to=>'conversations#new_node_contribution', :via=>[:get]
  match '/conversations/preview_node_contribution', :to=>'conversations#preview_node_contribution', :via=>[:post]
  match '/conversations/rate_contribution', :to=>'conversations#rate_contribution'#, :via=>[:post]
  match '/conversations/rate', :to=>'conversations#rate', :via=>[:post]
  match '/subscriptions/subscribe', :to=>'subscriptions#subscribe', :via=>[:post]
  match '/subscriptions/unsubscribe', :to=>'subscriptions#unsubscribe', :via=>[:post]

  # Static pages
  match '/about', :to=>'static_pages#about', :via=>[:get]
  match '/faq', :to=>'static_pages#faq', :via=>[:get]
  
  resources :conversations
  resources :regions   
  namespace "admin" do
    resources   :articles
    resources   :conversations
    resources   :issues
    resources   :regions
    resources   :people do
      get 'proxies', :on => :collection
    end
    root        :to => "dashboard#show"
  end
  

  namespace "api" do
    match "/:id/conversations", :to => "conversations#index", :via => [:get], :format => :json
    match "/:id/issues", :to => "issues#index", :via => [:get], :format => :json
    match "/:id/contributions", :to => "contributions#index", :via => [:get], :format => :json
    match "/:id/subscriptions", :to => "subscriptions#index", :via => [:get], :format => :json
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
