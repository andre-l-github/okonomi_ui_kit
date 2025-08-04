module OkonomiUiKit
  module Components
    class ButtonTag < OkonomiUiKit::Components::ButtonBase
      def render(name = nil, options = {}, &block)
        # Handle different parameter patterns
        if name.is_a?(Hash) && options.empty?
          # Called as button_tag(options) with block
          options = name
          name = nil
        end

        options ||= {}
        options = options.with_indifferent_access

        variant = (options.delete(:variant) || "contained").to_sym
        color = (options.delete(:color) || "default").to_sym
        
        # Extract icon configuration
        icon_config, options = extract_icon_config(options)

        options[:class] = build_button_class(variant: variant, color: color, classes: options[:class])

        view.button_tag(options) do
          render_button_content(icon_config, name, &block)
        end
      end
    end
  end
end
