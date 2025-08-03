module OkonomiUiKit
  module Components
    module Forms
      class Field < OkonomiUiKit::FormComponent
        def render(form, field_id = nil, options = {}, &block)
          view.render(template_path, component: self, form: form, field_id: field_id, options: options, &block)
        end

        register_styles :default do
          {
            wrapper: "w-full flex flex-col gap-2",
            header: "flex justify-between items-center",
            hint: {
              trigger: "text-primary-600 text-sm hover:cursor-help",
              content: "text-xs absolute border rounded-md bg-gray-100 border-gray-600 text-gray-600 p-1 z-10"
            },
            content: "block",
            error: "mt-1 text-danger-600 text-sm"
          }
        end
      end
    end
  end
end
