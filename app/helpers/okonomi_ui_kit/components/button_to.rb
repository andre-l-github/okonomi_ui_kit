module OkonomiUiKit
  module Components
    class ButtonTo < OkonomiUiKit::Component
      def render(name = nil, options = nil, html_options = nil, &block)
        html_options, options, name = options, name, block if block_given?
        
        html_options ||= {}
        html_options = html_options.with_indifferent_access
        
        variant = (html_options.delete(:variant) || 'contained').to_sym
        color = (html_options.delete(:color) || 'default').to_sym
        
        html_options[:class] = build_button_class(variant: variant, color: color, classes: html_options[:class])
        
        if block_given?
          view.button_to(options, html_options, &block)
        else
          view.button_to(name, options, html_options)
        end
      end
      
      private
      
      def build_button_class(variant:, color:, classes: '')
        [
          theme.dig(:components, :link, :root) || '',
          theme.dig(:components, :link, variant.to_sym, :root) || '',
          theme.dig(:components, :link, variant.to_sym, :colors, color.to_sym) || '',
          classes,
        ].reject(&:blank?).join(' ')
      end
    end
  end
end