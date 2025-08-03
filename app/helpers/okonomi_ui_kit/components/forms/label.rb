module OkonomiUiKit
  module Components
    module Forms
      class Label < OkonomiUiKit::FormComponent
        def render(form, method, text = nil, options = {}, &block)
          options = options.with_indifferent_access
          base_classes = style(:root)
          # Call the parent class label method directly to avoid infinite loop
          ActionView::Helpers::FormBuilder.instance_method(:label).bind(form).call(method, text, merge_class(options, base_classes), &block)
        end

        register_styles :default do
          {
            root: "block text-sm/6 font-medium text-gray-900"
          }
        end

        private

        def merge_class(options, new_class)
          options[:class] = TWMerge.merge(options[:class] || "", new_class)
          options
        end
      end
    end
  end
end
