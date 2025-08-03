module OkonomiUiKit
  module Components
    module Forms
      class Select < OkonomiUiKit::FormComponent
        def render(form, method, choices = nil, options = {}, html_options = {}, &block)
          html_options = html_options.with_indifferent_access
          css = build_select_classes(form, method, html_options)

          select_html = ActionView::Helpers::FormBuilder.instance_method(:select).bind(form).call(method, choices, options, html_options.merge(class: css), &block)
          icon_html = view.ui.icon(
            style(:icon, :file),
            class: style(:icon, :class)
          )

          view.content_tag(:div, class: style(:wrapper)) do
            view.concat(select_html)
            view.concat(icon_html)
          end
        end

        register_styles :default do
          {
            wrapper: "relative",
            root: "w-full appearance-none border-0 pl-3 pr-10 py-2 rounded-md ring-1 focus:outline-none focus-within:ring-1",
            error: "bg-danger-100 text-danger-400 ring-danger-400 focus:ring-danger-600",
            valid: "text-default-700 ring-gray-300 focus-within:ring-gray-400",
            icon: {
              file: "heroicons/mini/chevron-down",
              class: "absolute right-2 top-1/2 -translate-y-1/2 size-5 text-gray-400 pointer-events-none"
            }
          }
        end

        private

        def build_select_classes(form, method, html_options)
          css = [
            style(:root),
            when_errors(form, method, style(:error), style(:valid)),
            html_options[:class]
          ].compact.join(" ").split(" ").uniq

          css.join(" ")
        end

        def when_errors(form, method, value, default_value = nil)
          key = method.to_s.gsub("_id", "").to_sym
          if form.object.errors.include?(key) || form.object.errors.include?(method)
            value
          else
            default_value
          end
        end
      end
    end
  end
end
