Pulsefy::Application.routes.draw do

  resources :assemblies
  resources :nodes
  resources :sessions, :only => [:new, :create, :destroy]
  resources :pulses, :only => [:reinforce, :degrade, :create, :destroy, :show]
  resources :pulse_comments

  root :to => 'static#home'

  match '/asspicup' => 'assemblies#picup'
  match '/assaccount' => 'assemblies#account'
  match '/show' => 'nodes#show'
  match '/picup' => 'nodes#picup'
  match '/account' => 'nodes#account'
  match '/inpulse' => 'assemblies#assembly_pulse_form'
  match '/members' => 'nodes#members'
  match '/uncomment' => 'pulse_comments#destroy'
  match '/delete'  => 'pulses#destroy'
  match '/reassemble' => 'assemblies#edit'
  match '/view'  =>  'assemblies#show_assemblies'
  match '/inputs' => 'nodes#show_inputs'
  match '/outputs' => 'nodes#show_outputs'
  match '/otherinputs' => 'nodes#show_other_inputs'
  match '/otheroutputs' => 'nodes#show_other_outputs'
  match '/quit' => 'assemblies#quit'
  match '/join' =>  'assemblies#join'
  match '/assemble' => 'assemblies#new'
  match '/comment' => 'pulses#show'
  match '/cast' => 'pulses#cast'
  match '/edit' => 'nodes#edit'
  match '/index' => 'nodes#index', :as => 'index'
  match '/pulseup' => 'nodes#new', :as => 'pulseup'
  match '/pulsein',  :to => 'sessions#new', :as => 'pulsein'
  match '/pulseout', :to => 'sessions#destroy', :via => :delete

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
