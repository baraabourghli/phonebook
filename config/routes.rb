Phonebook::Application.routes.draw do
  resources :contacts do
    get :download, :on => :collection
    post :upload, :on => :collection
  end

  namespace :api do
    
    resources :contacts do
      get :download, :on => :collection
      post :upload, :on => :collection
    end
    
    resources :jobs do
      get :status
    end

  end

  mount Resque::Server.new, :at => "/resque"
end
