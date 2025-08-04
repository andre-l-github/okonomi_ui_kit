module OkonomiUiKit
  module Components
    class LinkTo < OkonomiUiKit::Components::ButtonBase
      def render(name = nil, options = nil, html_options = nil, &block)
        html_options, options, name = options, name, block if block_given?

        html_options ||= {}
        html_options = html_options.with_indifferent_access

        variant = (html_options.delete(:variant) || "text").to_sym
        color = (html_options.delete(:color) || "default").to_sym
        
        # Extract icon configuration
        icon_config, html_options = extract_icon_config(html_options)

        html_options[:class] = build_button_class(variant: variant, color: color, classes: html_options[:class])

        view.link_to(options, html_options) do
          render_button_content(icon_config, name, &block)
        end
      end
    end
  end
end
