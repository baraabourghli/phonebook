Phonebook::Application.routes.draw do
  resources :contacts do
    get :download, :on => :collection
  end

  root 'contacts#index'
end
