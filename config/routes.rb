Rails.application.routes.draw do
  namespace :public do
    get 'homes/top'
  end
  devise_for :users, controllers: {
    registrations: "public/registrations",
    sessions: "public/sessions"
  }

  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }
  
  namespace :admin do
    root to: 'homes#top'
  end 
  


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
