module OkonomiUiKit
  module Components
    class Badge < OkonomiUiKit::Component
      def render(text, options = {})
        options = options.with_indifferent_access
        severity = (options.delete(:severity) || :default).to_sym
        
        classes = [
          style(:base),
          style(:severities, severity) || '',
          options.delete(:class) || ''
        ].reject(&:blank?).join(' ')

        view.tag.span(text, class: classes, **options)
      end

      register_styles :default do
        {
          base: "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium",
          severities: {
            default: "bg-gray-100 text-gray-800",
            success: "bg-green-100 text-green-800",
            danger: "bg-red-100 text-red-800",
            info: "bg-blue-100 text-blue-800",
            warning: "bg-yellow-100 text-yellow-800"
          }
        }
      end
    end
  end
end
