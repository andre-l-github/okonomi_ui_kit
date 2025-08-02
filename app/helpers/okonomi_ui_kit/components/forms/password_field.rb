module OkonomiUiKit
  module Components
    module Forms
      class PasswordField < OkonomiUiKit::Components::Forms::InputBase
        def render_arguments(object, method, options = {})
          css = input_field_classes(object, method, :password, options)
          [method, options.merge(class: css)]
        end
      end
    end
  end
end