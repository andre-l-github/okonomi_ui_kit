module OkonomiUiKit
  module Components
    module Forms
      class CheckBoxWithLabel < OkonomiUiKit::FormComponent
        def render(form, method, options = {}, checked_value = true, unchecked_value = false)
          options = options.with_indifferent_access

          view.content_tag(:div, class: style(:wrapper)) do
            view.concat form.check_box(
              method,
              {
                class: style(:input, :root)
              }.merge(options || {}),
              checked_value,
              unchecked_value
            )
            view.concat view.render(template_path, component: self, method: method, options: options, form: form)
          end
        end

        register_styles :default do
          {
            wrapper: "flex gap-x-3",
            input: {
              root: "size-4 rounded border-gray-300 text-primary-600 focus:ring-primary-600"
            },
            label: {
              root: "text-sm/6 font-medium text-gray-900"
            },
            hint: {
              root: "text-gray-500"
            }
          }
        end
      end
    end
  end
end
