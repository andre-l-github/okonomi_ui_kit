module OkonomiUiKit
  module Components
    module Forms
      class FieldSet < OkonomiUiKit::FormComponent
        def render(form, options = {}, &block)
          view.render(template_path, component: self, options:, form:, &block)
        end

        register_styles :default do
          {
            root: "w-full flex flex-col gap-4 col-span-1 sm:col-span-3 md:col-span-5"
          }
        end
      end
    end
  end
end
