module OkonomiUiKit
  module Components
    class Icon < OkonomiUiKit::Component
      def render(name, options = {})
        options = options.with_indifferent_access
        
        # Extract specific icon options
        variant = options.delete(:variant) || :outlined
        width = options.delete(:width)
        height = options.delete(:height)
        
        # Build classes array
        classes = [
          style(:base),
          options.delete(:class)
        ].compact.join(' ')
        
        view.render(
          template_path,
          name: name,
          variant: variant,
          width: width,
          height: height,
          classes: classes,
          options: options
        )
      end
      
      register_styles :default do
        {
          base: "inline-block"
        }
      end
    end
  end
end