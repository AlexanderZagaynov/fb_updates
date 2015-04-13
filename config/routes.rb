Rails.application.routes.draw do
  # get controller: :home, action: :oauth, as: :oauth
  post controller: :home, action: :reload, as: :reload
  root controller: :home, action: :index
end
