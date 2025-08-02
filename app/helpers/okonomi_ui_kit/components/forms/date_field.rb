module OkonomiUiKit
  module Components
    module Forms
      class DateField < OkonomiUiKit::Components::Forms::InputBase
        def render_arguments(object, method, options = {})
          css = input_field_classes(object, method, :date, options)
          [method, options.merge(class: css)]
        end
      end
    end
  end
end