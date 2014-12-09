UserManagement::Application.routes.draw do
  resources :specifications

  resources :users, only: [:create, :update]

  get '/:user_name' => "users#show", as: :account
  scope 'account' do
    # 注册表单页面
    get '/sign_up' => 'users#new'
    # 登录表单页面
    get '/log_in_form' => 'application#log_in_form'
    # 登录表单提交
    post '/log_in' => 'application#log_in'
    # 退出登录
    get '/log_out' => 'application#log_out'

    get '/edit' => "users#edit", as: :edit_account
    # patch '/' => "users#update"
  end

  namespace :api do
    concern :base_routes do
      post 'token' => "base#get_access_token"
      patch 'token' => "base#exchange_access_token"
      delete 'token' => "base#destroy_access_token"
    end
    concerns :base_routes

    namespace :v1 do
      concern :v1_routes do
        concerns :base_routes
        
        get 'welcome' => "base#welcome"

        resources :users, only: [:create, :show]

        scope 'profile' do
          get "/:access_token" => "users#profile"
          patch "/:access_token" => "users#profile_update"
        end
      end
      concerns :v1_routes
    end

    # namespace :v2 do
    #   concern :v2_routes do
    #     concerns :v1_routes
    #   end
    #   concerns :v2_routes
    # end
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  

  root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
