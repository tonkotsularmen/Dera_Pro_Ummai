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
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
