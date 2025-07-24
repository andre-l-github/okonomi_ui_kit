# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true

# Pin all the controllers from the engine
pin_all_from OkonomiUiKit::Engine.root.join("app/javascript/okonomi_ui_kit/controllers"), under: "controllers", to: "okonomi_ui_kit/controllers"