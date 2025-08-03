module OkonomiUiKit
  module Components
    class ConfirmationModal < OkonomiUiKit::Component
      def render(options = {}, &block)
        options = options.with_indifferent_access
        
        # Extract and validate required options
        title = options.fetch(:title) { raise ArgumentError, "title is required" }
        message = options.fetch(:message) { raise ArgumentError, "message is required" }
        
        # Extract optional parameters with defaults
        confirm_text = options.delete(:confirm_text) || "Confirm"
        cancel_text = options.delete(:cancel_text) || "Cancel"
        variant = (options.delete(:variant) || :warning).to_sym
        size = (options.delete(:size) || :md).to_sym
        auto_open = options.delete(:auto_open) || false
        
        # Build component options
        modal_options = {
          title: title,
          message: message,
          confirm_text: confirm_text,
          cancel_text: cancel_text,
          variant: variant,
          size: size,
          auto_open: auto_open,
          has_custom_actions: block_given?,
          data: options.delete(:data) || {}
        }.merge(options)
        
        view.render(template_path, options: modal_options, &block)
      end
      
      # Register default styles for the confirmation modal
      register_styles :default do
        {
          # Modal container and backdrop
          backdrop: "fixed inset-0 bg-gray-500/75 transition-opacity duration-300 ease-out opacity-0",
          container: "fixed inset-0 z-10 w-screen overflow-y-auto",
          wrapper: "flex min-h-full items-end justify-center p-4 text-center sm:items-center sm:p-0",
          
          # Modal panel
          panel: {
            base: "relative transform overflow-hidden rounded-lg bg-white px-4 pt-5 pb-4 text-left shadow-xl transition-all duration-300 ease-out sm:my-8 sm:w-full sm:p-6 opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95",
            sizes: {
              sm: "sm:max-w-sm",
              md: "sm:max-w-lg",
              lg: "sm:max-w-2xl",
              xl: "sm:max-w-4xl"
            }
          },
          
          # Close button
          close_button: {
            wrapper: "absolute top-0 right-0 hidden pt-4 pr-4 sm:block",
            button: "rounded-md bg-white text-gray-400 hover:text-gray-500 focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 focus:outline-none",
            icon: {
              file: "heroicons/outline/x-mark",
              class: "size-6"
            }
          },
          
          # Icon configuration
          icon: {
            wrapper: "mx-auto flex size-12 shrink-0 items-center justify-center rounded-full sm:mx-0 sm:size-10",
            class: "size-6",
            variants: {
              warning: {
                wrapper: "bg-red-100",
                icon: "text-red-600",
                file: "heroicons/outline/exclamation-triangle"
              },
              info: {
                wrapper: "bg-blue-100",
                icon: "text-blue-600",
                file: "heroicons/outline/information-circle"
              },
              success: {
                wrapper: "bg-green-100",
                icon: "text-green-600",
                file: "heroicons/outline/check-circle"
              }
            }
          },
          
          # Content styling
          content: {
            wrapper: "sm:flex sm:items-start",
            text_wrapper: "mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left",
            title: "text-base font-semibold text-gray-900",
            message: "mt-2 text-sm text-gray-500"
          },
          
          # Actions container
          actions: {
            wrapper: "mt-5 sm:mt-4 sm:flex sm:flex-row-reverse"
          }
        }
      end
      
      # Helper methods to build classes from styles
      def modal_panel_class(size)
        [
          style(:panel, :base),
          style(:panel, :sizes, size)
        ].compact.join(" ")
      end
      
      def modal_icon_wrapper_class(variant)
        [
          style(:icon, :wrapper),
          style(:icon, :variants, variant, :wrapper)
        ].compact.join(" ")
      end
      
      def modal_icon_class(variant)
        [
          style(:icon, :class),
          style(:icon, :variants, variant, :icon)
        ].compact.join(" ")
      end
      
      def modal_data_attributes(options)
        return "" unless options[:data]
        
        options[:data].map { |k, v| "data-#{k.to_s.dasherize}=\"#{v}\"" }.join(" ").html_safe
      end
    end
  end
end