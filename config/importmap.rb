pin "application", to: "okonomi_ui_kit/application.js", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true

pin "okonomi_ui_kit", to: "okonomi_ui_kit/application.js", preload: true
pin_all_from OkonomiUiKit::Engine.root.join("app/javascript/okonomi_ui_kit/controllers"), under: "controllers", to: "okonomi_ui_kit/controllers"
