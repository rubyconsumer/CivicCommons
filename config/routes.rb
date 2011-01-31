Civiccommons::Application.routes.draw do

  #Application Root
  root to: "homepage#show"

  #Devise Routes
  devise_for :people,
             :controllers => { :registrations => 'registrations', :confirmations => 'confirmations', :sessions => 'sessions' },
             :path_names => { :sign_in => 'login', :sign_out => 'logout', :password => 'secret', :confirmation => 'verification', :registration => 'register', :sign_up => 'new' }

  devise_scope :person do
    match '/people/ajax_login', :to=>'sessions#ajax_create', :via=>[:post]
  end

#Custom Matchers
  #Contributions

  get '/contributions/create_from_pa',                 to: 'contributions#create_from_pa',                   as: 'create_contribution_from_pa'
  post '/contributions/create_confirmed_contribution', to: 'contributions#create_confirmed_contribution',    as: 'create_confirmed_contribution'
  delete '/contributions/moderate/:id',                to: 'contributions#moderate_contribution',            as: 'moderate_contribution'
  delete '/contributions/:id',                         to: 'contributions#destroy',                          as: 'contribution'
  
 #Conversations
  get '/conversations/',                               to: 'conversations#index',                            as: 'conversations'
  get '/conversations/preview_node_contribution',      to: 'conversations#preview_node_contribution'
  get '/conversations/node_conversation',              to: 'conversations#node_conversation'
  get '/conversations/new_node_contribution',          to: 'conversations#new_node_contribution'
  get '/conversations/edit_node_contribution',         to: 'conversations#edit_node_contribution'
  get '/conversations/node_permalink/:id',             to: 'conversations#node_permalink'
  get '/conversations/:id',                            to: 'conversations#show',                             as: 'conversation'
  put '/conversations/update_node_contribution',       to: 'conversations#update_node_contribution'
  put '/conversations/confirm_node_contribution',      to: 'conversations#confirm_node_contribution'
  #Subscriptions
  post '/subscriptions/subscribe',                     to: 'subscriptions#subscribe'
  post '/subscriptions/unsubscribe',                   to: 'subscriptions#unsubscribe'
  get '/community',                                    to: 'community#index',                                 as: 'community'
  get '/top_items/newest',                             to: 'top_items#newest',                                as: 'newest_items'
  get '/top_items/highest_rated',                      to: 'top_items#highest_rated',                         as: 'highest_rated_items'
  get '/top_items/most_visited',                       to: 'top_items#most_visited',                          as: 'most_visited_items'
  get '/widget',                                       to: 'widget#index'

  #Static Pages
  get '/about',             to: 'static_pages#about'
  get '/faq',               to: 'static_pages#faq'
  get '/principles',        to: 'static_pages#principles'
  get '/team',              to: 'static_pages#team'
  get '/partners',          to: 'static_pages#partners'
  get '/terms',             to: 'static_pages#terms'
  get '/build-the-commons', to: 'static_pages#build_the_commons'
  get '/contact-us',        to: 'static_pages#contact'
  get '/posters',           to: 'static_pages#poster'
  get '/poster',            to: 'static_pages#poster'
  get '/polls',             to: 'polls#index'
  post '/polls',            to: 'polls#create'
  get '/blog',              to: 'static_pages#blog',                as: 'blog'
  get '/press',             to: 'static_pages#in_the_news'

  #Resource Declared Routes
  resources :user, only: [:show, :update, :edit]
  resources :answers
  resources :issues do
    post 'create_contribution', on: :member
  end
  resources :regions
  resources :links

  #Namespaces
  namespace "admin" do
    resources :articles
    resources :conversations
    resources :issues
    resources :regions
    resources :people do
      get 'proxies',       on: :collection
      put 'lock_access',   on: :member
      put 'unlock_access', on: :member
    end
    resources :invites
    root      to: "dashboard#show"
  end


  namespace "api" do
    get '/:id/conversations',                              to: 'conversations#index',  format: :json
    get '/:id/issues',                                     to: 'issues#index',         format: :json
    get '/:id/contributions',                              to: 'contributions#index',  format: :json
    get '/people-aggregator/person/:id/subscriptions',     to: 'subscriptions#index',  format: :json
    get '/people-aggregator/person/:id/contributions',     to: 'contributions#index',  format: :json
    put '/people-aggregator/person/:people_aggregator_id', to: 'people#update',        format: :json
  end

end
