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

  constraints FilterConstraint do
    get 'conversations/:filter', to: 'conversations#filter', as: 'conversations_filter'
  end

#Custom Matchers
  #Contributions
  get '/contributions/create_from_pa',                 to: 'contributions#create_from_pa',                   as: 'create_contribution_from_pa'
  post '/contributions/create_confirmed_contribution', to: 'contributions#create_confirmed_contribution',    as: 'create_confirmed_contribution'
  delete '/contributions/moderate/:id',                to: 'contributions#moderate_contribution',            as: 'moderate_contribution'
  delete '/contributions/:id',                         to: 'contributions#destroy',                          as: 'contribution'

 #Conversations
  get '/conversations/',                               to: 'conversations#index',                            as: 'conversations'
  match '/conversations/preview_node_contribution',    to: 'conversations#preview_node_contribution'
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
  #Community
  get '/community',                                    to: 'community#index',                                 as: 'community'
  #Widget
  get '/widget',                                       to: 'widget#index'

#Static Pages
  get '/about',             to: 'static_pages#about'
  get '/blog',              to: 'static_pages#blog',                as: 'blog'
  get '/build-the-commons', to: 'static_pages#build_the_commons'
  get '/contact-us',        to: 'static_pages#contact'
  get '/faq',               to: 'static_pages#faq'
  get '/partners',          to: 'static_pages#partners'
  get '/poster',            to: 'static_pages#poster'
  get '/posters',           to: 'static_pages#poster'
  get '/press',             to: 'static_pages#in_the_news'
  get '/principles',        to: 'static_pages#principles'
  get '/team',              to: 'static_pages#team'
  get '/terms',             to: 'static_pages#terms'

  #Resource Declared Routes
  resources :user, only: [:show, :update, :edit] do
    delete "destroy_avatar", on: :member
  end
  resources :issues do
    post 'create_contribution', on: :member
  end
  resources :regions, only: [:index, :show]
  resources :links, only: [:new, :create]

#Namespaces
  namespace "admin" do
    root      to: "dashboard#show"
    resources :articles
    resources :conversations
    resources :issues
    resources :regions
    resources :people do
      get 'proxies',       on: :collection
      put 'lock_access',   on: :member
      put 'unlock_access', on: :member
    end
  end


  namespace "api" do
    get '/:id/conversations',                              to: 'conversations#index',  format: :json
    get '/:id/issues',                                     to: 'issues#index',         format: :json
    get '/:id/contributions',                              to: 'contributions#index',  format: :json
    get '/:id/subscriptions',                              to: 'subscriptions#index',  format: :json
  end

end
