module OkonomiUiKit
  module Components
    module Forms
      class TextArea < OkonomiUiKit::Components::Forms::InputBase
        def render_arguments(object, method, options = {})
          css = input_field_classes(object, method, :textarea, options, include_disabled: false)
          [method, options.merge(class: css)]
        end
      end
    end
  end
end