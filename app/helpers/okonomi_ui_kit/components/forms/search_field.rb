module OkonomiUiKit
  module Components
    module Forms
      class SearchField < OkonomiUiKit::Components::Forms::InputBase
        def render_arguments(object, method, options = {})
          css = input_field_classes(object, method, :search, options)
          [method, options.merge(class: css)]
        end
      end
    end
  end
end