Rails.application.routes.draw do

  #ユーザー
  devise_for :users, controllers: {
    registrations: "public/registrations",
    sessions: "public/sessions"
  }

  #管理者
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  #管理者
  namespace :admin do
    root to: 'homes#top'
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
