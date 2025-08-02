module OkonomiUiKit
  module Components
    class Code < OkonomiUiKit::Component
      def render(content = nil, options = {}, &block)
        options, content = content, nil if block_given?
        options ||= {}
        options = options.with_indifferent_access

        # Extract component-specific options
        language = options.delete(:language) || options.delete(:lang)
        variant = (options.delete(:variant) || "default").to_sym
        size = (options.delete(:size) || "default").to_sym
        wrap = options.delete(:wrap) != false # Default to true

        # Build classes
        classes = build_classes(variant: variant, size: size, wrap: wrap, custom_class: options.delete(:class))

        # Escape HTML entities in content
        raw_content = if block_given?
                        view.capture(&block)
        elsif content
                        content
        else
                        ""
        end

        escaped_content = html_escape(raw_content)

        view.render(
          template_path,
          content: escaped_content,
          options: options,
          classes: classes,
          language: language
        )
      end

      private

      def build_classes(variant:, size:, wrap:, custom_class: nil)
        base_classes = theme.dig(:components, :code, :base) || "bg-gray-900 text-gray-100 rounded-lg"

        variant_classes = case variant
        when :inline
                            "bg-gray-100 text-gray-900 px-1 py-0.5 rounded text-sm font-mono"
        when :minimal
                            "bg-gray-900 text-gray-100 p-3 rounded text-xs"
        else
                            # :default
                            "bg-gray-900 text-gray-100 p-4 rounded-lg"
        end

        size_classes = case size
        when :xs
                         "text-xs"
        when :sm
                         "text-sm"
        when :lg
                         "text-base"
        else
                         # :default
                         "text-sm"
        end

        wrap_classes = wrap ? "overflow-x-auto" : "overflow-hidden"

        [ base_classes, variant_classes, size_classes, wrap_classes, custom_class ].compact.join(" ")
      end

      def html_escape(content)
        ERB::Util.html_escape(content.to_s.strip)
      end
    end
  end
end
