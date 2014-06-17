require 'sidekiq/web'
Tm::Application.routes.draw do
  
  mount Sidekiq::Web, at: "/q"
  




  devise_for :users do
    match 'register/' => "devise/registrations#new"
    match 'register/:free_plan' => "devise/registrations#new"
    
    
  end
  get 'users/' => 'settings_users#index'
  get 'checklists/' => 'checklist_masters#index'
  get 'checklists/new' => 'checklist_masters#new'
  get 'documents/' => 'libraries#index'
  get 'pricing/' => 'welcome#pricing'
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
  resources :docs  do
    get 'upload_process', :on => :member
    get 'reload', :on => :member
    get 'after_upload', :on => :member
    get 'download', :on => :member 
    put 'assign_users', :on => :member
    put 'assign_libs', :on => :member
    get 'flip', :on => :member
    get 'left', :on => :member
    get 'right', :on => :member
    
    put 'move_to_checklist_items', :on => :member
    put 'review', :on => :member
    get 'show_file', :on => :member
    get 'show_png', :on => :member
    get 'get_secret_key', :on => :member
  end
  resources :libraries do
    post 'name', :on => :member
    resources :docs do
      get 'overwrite', :on => :member
    end
    
    collection do
      put :update_attribute_on_the_spot
      get :get_attribute_on_the_spot
    end
  end
  resources :contacts do
    get 'export', :on => :collection
    get 'role', :on => :member
    get 'extended', :on => :member
    get 'make_guest', :on => :member
  end
  resources :settings_transactions
  resources :transaction_details do
    resources :transaction_types
  end
  resources :transaction_types do
    collection do
      put :update_attribute_on_the_spot
      get :get_attribute_on_the_spot
      
    end
    post 'update_name', :on => :member
    put 'check', :on  => :member
  end
  
  resources :transaction_statuses do
    collection do
      put :update_attribute_on_the_spot
      get :get_attribute_on_the_spot
    end
    post 'update_name', :on => :member
    get 'check', :on  => :member
  end
  resources :mail_texts
  resources :settings_checklists
  resources :checklist_masters do
    post 'sort', :on => :collection
  end
  resources :settings_users do
    post 'save_welcome_template', :on => :collection
    put 'small_update', :on => :member
    put 'dropbox_code', :on => :member
    get 'dropbox_sync', :on => :member
    get 'dropbox_sync_verify', :on => :member
    get 'dropbox_restore', :on => :member
    get 'existing_user', :on => :member
    get 'invitation_mail', :on => :member
    get 'accept_invitation', :on => :member
  end
  resources :mail_templates
  get 'send_test_mail/' => 'mail_templates#test_mail'
  resources :users do
    resources :widgets do
      post 'sort', :on => :collection
    end
    get 'check_pass', :on => :member
    get 'destroy_company', :on => :member
    get 'console', :on => :collection
    post 'profile', :on => :member
    post 'company', :on => :member
    put 'assign_contact', :on => :member
    post 'plan', :on => :member
    get 'company_switch_plan', :on => :member
    post 'upgrade', :on => :member
    get 'lock_company', :on => :member
    get 'lock', :on => :member
    get 'switch_user', :on => :collection
    get 'switch_to_admin', :on => :collection
    
  end
  
  
  resources :checklists do
    resources :checklist_items
  end
  resources :checklist_items do
    post 'sort', :on => :collection
    collection do
      put :update_attribute_on_the_spot
      get :get_attribute_on_the_spot
    end
    put 'check', :on  => :member
    resources :docs do
      put 'move', :on => :collection
      get 'show_pdf', :on => :member
    end
    
  end
  resources :transactions do
    get :remove_notification, :on => :member
    post :search, :on => :collection
    get :in_location, :on => :member
    get :in_status, :on => :member
    get :in_type, :on => :member
    post :mail_attachment, :on => :member
    post :mail_note, :on => :member
    get :pdf, :on => :member
    get :remove_contact, :on => :member
    put :add_contact, :on => :member
    post :add_new_contact, :on => :collection
    get :lock, :on => :member
    get :autocomplete_user_fullname, :on => :collection
    resources :notes
    resources :docs do
      put 'move', :on => :collection
      get 'overwrite', :on => :member
    end
    
    resources :checklists
  end
  resources :locations do
    post 'name', :on => :member
    collection do
      put :update_attribute_on_the_spot
      get :get_attribute_on_the_spot
    end
  end
  match 'search/' => 'transactions#search'
  match 'lib/' => 'welcome#lib'
  match 'profile/' => 'welcome#profile'
  match 'dropboxauth/' => 'welcome#dropboxauth', :as => "dropboxauth"
  match 'library' => 'libraries#index'
  match 'dashboard' => 'welcome#dashboard'
  
  
  post 'get_mail' => 'transactions#get_mail'
  get 'te' => 'transactions#te'
  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.

	get "home(/:action)", :controller => "pages"

  root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'

end
