module OkonomiUiKit
  module Components
    class DropdownButton < ButtonBase
      def render(options = {}, &block)
        raise ArgumentError, "DropdownButton requires a block" unless block_given?

        options = options.with_indifferent_access
        variant = (options.delete(:variant) || "contained").to_sym
        color = (options.delete(:color) || "default").to_sym

        base_button_classes = build_button_class(
          variant: variant,
          color: color,
          classes: options.delete(:class)
        )

        menu_classes = [
          style(:menu, :root),
          options.delete(:menu_class)
        ].compact.join(" ")

        dropdown_builder = DropdownBuilder.new(view)

        view.render(
          template_path,
          base_button_classes: base_button_classes,
          menu_classes: menu_classes,
          dropdown_builder: dropdown_builder,
          component: self,
          options: options,
          &block
        )
      end

      register_styles :default do
        {
          primary: {
            icon: "mr-1.5 size-3.5",
            chevron: "size-3.5"
          },
          menu: {
            root: "absolute right-0 z-10 mt-2 w-56 origin-top-right rounded-md bg-white shadow-lg ring-1 ring-gray-200 focus:outline-none",
            divider: "h-0 my-1 border-t border-gray-200",
            item: {
              root: "hover:cursor-pointer block w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-50 active:bg-gray-100 hover:text-gray-900",
              icon: "mr-3 h-5 w-5 text-gray-400",
              label: "flex items-center"
            }
          }
        }
      end

      class DropdownBuilder
        attr_reader :view, :items, :is_first

        def initialize(view)
          @view = view
          @items = []
          @is_first = true
        end

        def link_to(name = nil, options = nil, html_options = nil, &block)
          # Handle icon extraction
          if html_options.is_a?(Hash)
            icon = html_options.delete(:icon)
          else
            icon = nil
          end

          item = {
            type: :link,
            name: name,
            options: options,
            html_options: html_options || {},
            block: block,
            is_first: @is_first,
            icon: icon
          }
          @items << item
          @is_first = false
        end

        def button_to(name = nil, options = {}, html_options = {}, &block)
          # Handle icon extraction
          if html_options.is_a?(Hash)
            icon = html_options.delete(:icon)
          else
            icon = nil
          end

          item = {
            type: :button,
            name: name,
            options: options,
            html_options: html_options,
            block: block,
            is_first: @is_first,
            icon: icon
          }
          @items << item
          @is_first = false
        end
        
        def button_tag(content_or_options = nil, options = nil, &block)
          # Handle the different argument patterns for button_tag
          if content_or_options.is_a?(Hash)
            options = content_or_options
            content = nil
          else
            content = content_or_options
          end
          
          options ||= {}
          
          # Handle icon extraction
          icon = options.delete(:icon) if options.is_a?(Hash)
          
          # Ensure type is button for button_tag
          options[:type] ||= "button"
          
          item = {
            type: :button_tag,
            name: content,
            options: options,
            block: block,
            is_first: @is_first,
            icon: icon
          }
          @items << item
          @is_first = false
        end

        def divider
          @items << { type: :divider }
        end

        def primary_item
          @items.find { |item| item[:is_first] && item[:type] != :divider }
        end

        def menu_items
          @items
        end
      end
    end
  end
end
