module OkonomiUiKit
  module Components
    module Forms
      class InputBase < OkonomiUiKit::FormComponent
        def render_arguments(object, method, options = {})
          css = input_field_classes(object, method, :text, options)
          p [self.class.name, styles]
          [method, { autocomplete: "off" }.merge(options).merge(class: css)]
        end

        register_styles :default do
          {
            root: "w-full border-0 px-3 py-2 rounded-md ring-1 focus:outline-none focus-within:ring-1",
            error: "bg-danger-100 text-danger-400 ring-danger-400 focus:ring-danger-600",
            valid: "text-default-700 ring-gray-300 focus-within:ring-gray-400",
            disabled: "disabled:bg-gray-50 disabled:cursor-not-allowed"
          }
        end

        def input_field_classes(object, method, type, options, include_disabled: true)
          css_classes = OkonomiUiKit::TWMerge.merge_all(
            style(:root),
            when_errors(
              object,
              method,
              style(:error),
              style(:valid)
            ),
            options[:class]
          )

          if include_disabled
            css_classes = OkonomiUiKit::TWMerge.merge_all(css_classes, style(:disabled))
          end

          css_classes
        end

        def when_errors(object, method, value, default_value = nil)
          key = method.to_s.gsub('_id', '').to_sym
          if object.errors.include?(key) || object.errors.include?(method)
            value
          else
            default_value
          end
        end
      end
    end
  end
end