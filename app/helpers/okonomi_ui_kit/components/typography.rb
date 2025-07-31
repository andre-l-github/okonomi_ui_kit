module OkonomiUiKit
  module Components
    class Typography < OkonomiUiKit::Component
      TYPOGRAPHY_COMPONENTS = {
        body1: 'p',
        body2: 'p',
        h1: 'h1',
        h2: 'h2',
        h3: 'h3',
        h4: 'h4',
        h5: 'h5',
        h6: 'h6',
      }.freeze

      def render(text = nil, options = {}, &block)
        options, text = text, nil if block_given?
        options ||= {}
        options = options.with_indifferent_access

        variant = (options.delete(:variant) || 'body1').to_sym
        component = (TYPOGRAPHY_COMPONENTS[variant] || 'span').to_s
        color = (options.delete(:color) || 'default').to_sym
        
        classes = [
          theme.dig(:components, :typography, :variants, variant) || '',
          theme.dig(:components, :typography, :colors, color) || '',
          options.delete(:class) || ''
        ].reject(&:blank?).join(' ')

        view.render(
          template_path,
          text: text,
          options: options,
          variant: variant,
          component: component,
          classes: classes,
          &block
        )
      end
    end
  end
end