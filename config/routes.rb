Rails.application.routes.draw do

  #ユーザー
  devise_for :users, controllers: {
    registrations: "public/registrations",
    sessions: "public/sessions"
  }

  devise_scope :user do
    post 'users/guest_sign_in', to: 'public/users/sessions#guest_sign_in'
  end

  #管理者
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }


  #管理者
  namespace :admin do
    root to: 'users#index'
    get 'admin/users/:id/unsubscribe' => 'users#unsubscribe', as: 'unsubscribe'
    get "search" => "searches#search"
    resources :users, only: [:show, :index, :edit, :update, :destroy] do
      member do
        get :following, :followers
        # GET /users/1/following
        # GET /users/1/followers
      end
      
    end
    resources :posts, only: [:show, :destroy] do
      resources :comments, only: [:destroy]
      
    end
    
  end


  #ユーザー
  scope module: :public do
    root to: 'homes#top'
    get '/about' => 'homes#about'
    get '/newcomer' => 'homes#newcomer'
    get '/posts/new/yabai' => 'posts#shokuyoku_new', as: 'new_shokuyoku_post'
    get '/posts/new/zasetsu' => 'posts#zasetsu_new', as: 'new_zasetsu_post'
    get '/users/:id/unsubscribe' => 'users#unsubscribe', as: 'unsubscribe'
     # 退会確認画面
    patch '/users/:id/withdrawal' => 'users#withdrawal', as: 'withdrawal'
     # アカウント削除
    resources :users, only: [:index, :show, :edit, :update] do
      resource :relationships, only: [:create, :destroy]

    	member do
        get :likes
      end

      member do
        get :following, :followers
        # GET /users/1/following
        # GET /users/1/followers
      end
    end

    resources   :posts,      only: [:new, :create, :index, :show, :destroy] do
      resources :comments, only: [:create, :destroy]
      resource  :likes  ,  only: [:create, :destroy]
      collection do
        get 'search'
      end
    end
    resources :notifications, only: :index
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
