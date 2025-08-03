module OkonomiUiKit
  module Components
    module Forms
      class MultiSelect < OkonomiUiKit::FormComponent
        def render(form, method, options = {})
          view.render(template_path, component: self, form: form, method: method, options: options)
        end

        register_styles :default do
          {
            wrapper: "grid grid-cols-2 gap-2",
            item: "flex items-center"
          }
        end
      end
    end
  end
end
