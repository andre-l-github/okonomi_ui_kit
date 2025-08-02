require "turbo-rails"
require "stimulus-rails"
require "importmap-rails"
require "tailwindcss-rails"

module OkonomiUiKit
  class Engine < ::Rails::Engine
    isolate_namespace OkonomiUiKit

    initializer "okonomi_ui_kit.importmap", before: "importmap" do |app|
      app.config.importmap.paths << root.join("config/importmap.rb")
      app.config.importmap.cache_sweepers << root.join("app/javascript")
    end

    initializer "okonomi_ui_kit.assets" do |app|
      app.config.assets.paths << root.join("app/javascript")
      app.config.assets.paths << root.join("app/assets/builds")
      app.config.assets.precompile += %w[okonomi_ui_kit_manifest.js okonomi_ui_kit/application.tailwind.css]
    end

    initializer "okonomi_ui_kit.view_helpers" do
      ActiveSupport.on_load(:action_view) do
        include OkonomiUiKit::ApplicationHelper
        include OkonomiUiKit::AttributeSectionHelper
        include OkonomiUiKit::UiHelper

        ActionView::Base.field_error_proc = ->(html_tag, _instance) { html_tag.html_safe }
      end
    end
  end
end
