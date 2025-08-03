module OkonomiUiKit
  module Components
    class ButtonTag < OkonomiUiKit::Components::ButtonBase
      def render(name = nil, options = {}, &block)
        options, name = options, block if block_given?

        options ||= {}
        options = options.with_indifferent_access

        variant = (options.delete(:variant) || "contained").to_sym
        color = (options.delete(:color) || "default").to_sym

        options[:class] = build_button_class(variant: variant, color: color, classes: options[:class])

        if block_given?
          view.button_tag(options, &block)
        else
          view.button_tag(name, options)
        end
      end
    end
  end
end
