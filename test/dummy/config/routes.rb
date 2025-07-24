Rails.application.routes.draw do
  mount OkonomiUiKit::Engine => "/okonomi_ui_kit"
  
  root "showcase#index"
  get "components/:component", to: "showcase#show", as: :showcase_component
  match "form_builder_demo", to: "showcase#form_builder_demo", via: [:get, :post], as: :form_builder_demo
end
