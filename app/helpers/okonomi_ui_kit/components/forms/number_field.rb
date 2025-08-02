module OkonomiUiKit
  module Components
    module Forms
      class NumberField < OkonomiUiKit::Components::Forms::InputBase
        def render_arguments(object, method, options = {})
          css = input_field_classes(object, method, :number, options)
          [method, options.merge(class: css)]
        end
      end
    end
  end
end