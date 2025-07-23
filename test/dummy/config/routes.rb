Rails.application.routes.draw do
  mount OkonomiUiKit::Engine => "/okonomi_ui_kit"
  
  root "showcase#index"
  get "components/:component", to: "showcase#show", as: :showcase_component
end
