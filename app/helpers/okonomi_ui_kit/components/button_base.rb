module OkonomiUiKit
  module Components
    class ButtonBase < OkonomiUiKit::Component
      def build_button_class(variant:, color:, classes: "")
        [
          style(:root) || "",
          style(variant.to_sym, :root) || "",
          style(variant.to_sym, :colors, color.to_sym) || "",
          classes
        ].reject(&:blank?).join(" ")
      end

      # Extracts and normalizes icon configuration from options
      # Returns [icon_config, updated_options]
      # icon_config will be nil or { path: "icon/path", position: :start/:end }
      def extract_icon_config(options)
        return [nil, options] unless options.is_a?(Hash)
        
        icon_option = options.delete(:icon)
        return [nil, options] unless icon_option
        
        icon_config = case icon_option
        when String
          { path: icon_option, position: :start }
        when Hash
          if icon_option[:start]
            { path: icon_option[:start], position: :start }
          elsif icon_option[:end]
            { path: icon_option[:end], position: :end }
          else
            # Invalid hash format, ignore
            nil
          end
        else
          nil
        end
        
        [icon_config, options]
      end

      # Renders button content with optional icon
      # icon_config: { path: "icon/path", position: :start/:end }
      # content: String or block content
      # block: Optional block for content
      def render_button_content(icon_config, content = nil, &block)
        icon_html = if icon_config
          view.ui.icon(icon_config[:path], class: style(:icon, icon_config[:position]))
        end
        
        content_html = if block_given?
          view.capture(&block)
        else
          content
        end
        
        # Check if we have actual content (not empty/nil)
        has_content = content_html.present?
        
        if icon_config && has_content
          # Both icon and content - wrap in flex container with gap
          wrapper_class = "inline-flex items-center gap-1.5"
          
          if icon_config[:position] == :end
            view.content_tag(:span, class: wrapper_class) do
              view.safe_join([content_html, icon_html].compact)
            end
          else
            view.content_tag(:span, class: wrapper_class) do
              view.safe_join([icon_html, content_html].compact)
            end
          end
        elsif icon_config
          # Icon only - no wrapper needed
          icon_html
        else
          # Content only
          content_html
        end
      end

      register_styles :default do
        {
          root: "hover:cursor-pointer text-sm",
          outlined: {
            root: "inline-flex border items-center justify-center px-2 py-1 rounded-md font-medium focus:outline-none",
            colors: {
              default: "bg-white text-default-700 border-default-700 hover:bg-default-50 active:bg-default-100",
              primary: "bg-white text-primary-600 border-primary-600 hover:bg-primary-50 active:bg-primary-100",
              secondary: "bg-white text-secondary-600 border-secondary-600 hover:bg-secondary-50 active:bg-secondary-100",
              success: "bg-white text-success-600 border-success-600 hover:bg-success-50 active:bg-success-100",
              danger: "bg-white text-danger-600 border-danger-600 hover:bg-danger-50 active:bg-danger-100",
              warning: "bg-white text-warning-600 border-warning-600 hover:bg-warning-50 active:bg-warning-100",
              info: "bg-white text-info-600 border-info-600 hover:bg-info-50 active:bg-info-100"
            }
          },
          contained: {
            root: "inline-flex border items-center justify-center px-2 py-1 rounded-md font-medium focus:outline-none",
            colors: {
              default: "border-default-700 bg-default-600 text-white hover:bg-default-700 active:bg-default-500",
              primary: "border-primary-700 bg-primary-600 text-white hover:bg-primary-700 active:bg-primary-500",
              secondary: "border-secondary-700 bg-secondary-600 text-white hover:bg-secondary-700 active:bg-secondary-500",
              success: "border-success-700 bg-success-600 text-white hover:bg-success-700 active:bg-success-500",
              danger: "border-danger-700 bg-danger-600 text-white hover:bg-danger-700 active:bg-danger-500",
              warning: "border-warning-700 bg-warning-600 text-white hover:bg-warning-700 active:bg-warning-500",
              info: "border-info-700 bg-info-600 text-white hover:bg-info-700 active:bg-info-500"
            }
          },
          text: {
            root: "text-base",
            colors: {
              default: "text-default-700 hover:underline",
              primary: "text-primary-600 hover:underline",
              secondary: "text-secondary-600 hover:underline",
              success: "text-success-600 hover:underline",
              danger: "text-danger-600 hover:underline",
              warning: "text-warning-600 hover:underline",
              info: "text-info-600 hover:underline"
            }
          },
          icon: {
            start: "size-3.5",
            end: "size-3.5"
          }
        }
      end
    end
  end
end
