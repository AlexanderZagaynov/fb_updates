Rails.application.routes.draw do
  with_options controller: :home do
    get '/callback', action: :verify, as: :verify
    post '/callback', action: :callback, as: :callback
    post '/subscribe', action: :subscribe, as: :subscribe
    post '/reload', action: :reload, as: :reload
    root action: :index
  end
end
