Phonebook::Application.routes.draw do
  resources :contacts do
    get :download, :on => :collection
    post :upload, :on => :collection
  end

  root 'contacts#index'
end
