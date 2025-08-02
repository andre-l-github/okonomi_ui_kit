module OkonomiUiKit
  module Components
    module Forms
      class TelephoneField < OkonomiUiKit::Components::Forms::InputBase
        def render_arguments(object, method, options = {})
          css = input_field_classes(object, method, :telephone_field, options)
          [method, options.merge(class: css)]
        end
      end
    end
  end
end