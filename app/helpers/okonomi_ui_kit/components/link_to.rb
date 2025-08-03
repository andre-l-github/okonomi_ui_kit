module OkonomiUiKit
  module Components
    class LinkTo < OkonomiUiKit::Components::ButtonBase
      def render(name = nil, options = nil, html_options = nil, &block)
        html_options, options, name = options, name, block if block_given?

        html_options ||= {}
        html_options = html_options.with_indifferent_access

        variant = (html_options.delete(:variant) || "text").to_sym
        color = (html_options.delete(:color) || "default").to_sym

        html_options[:class] = build_button_class(variant: variant, color: color, classes: html_options[:class])

        if block_given?
          view.link_to(options, html_options, &block)
        else
          view.link_to(name, options, html_options)
        end
      end
    end
  end
end
