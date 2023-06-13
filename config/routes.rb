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
  
  devise_scope :admin do
    post 'admin/guest_sign_in', to: 'admin/users/sessions#guest_sign_in'
  end

  #管理者
  namespace :admin do
    root to: 'homes#top'
    resources :users, only: [:show, :index, :destroy]
    resources :posts, only: [:show, :destroy] do
      resources :comments, only: [:destroy]
    end
  end


  #ユーザー
  scope module: :public do
    root to: 'homes#top'
    get '/about' => 'homes#about'
    get '/newcomer' => 'homes#newcomer'
    get '/users/:id/unsubscribe' => 'users#unsubscribe', as: 'unsubscribe'
     # 退会確認画面
    patch '/users/:id/withdrawal' => 'users#withdrawal', as: 'withdrawal'
     # アカウント削除
    resources :users, only: [:show, :edit, :update] do
      resource :relationships, only: [:create, :destroy]
    	get 'followings' => 'relationships#followings', as: 'followings'
    	get 'followers' => 'relationships#followers', as: 'followers'
    	member do
        get :likes
      end
    end

    resources   :posts,      only: [:new, :create, :index, :show, :destroy] do
      resources :comments, only: [:create, :destroy]
      resource  :likes  ,  only: [:create, :destroy]
      collection do
        get 'search'
      end
    end

  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
