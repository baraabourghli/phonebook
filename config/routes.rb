Phonebook::Application.routes.draw do

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
