module OkonomiUiKit
  module Components
    module Forms
      class TimeField < OkonomiUiKit::Components::Forms::InputBase
        def render_arguments(object, method, options = {})
          css = input_field_classes(object, method, :time, options)
          [method, options.merge(class: css)]
        end
      end
    end
  end
end