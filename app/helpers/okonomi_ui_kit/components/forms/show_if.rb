module OkonomiUiKit
  module Components
    module Forms
      class ShowIf < OkonomiUiKit::FormComponent
        def render(form, options = {}, &block)
          field = options[:field]
          equals = options[:equals]
          field_id = "#{form.object_name}_#{field}"
          view.tag.div(
            class: style(:root),
            data: {
              controller: "form-field-visibility",
              "form-field-visibility-field-id-value": field_id,
              "form-field-visibility-equals-value": equals
            },
            &block
          )
        end

        register_styles :default do
          {
            root: "hidden"
          }
        end
      end
    end
  end
end
