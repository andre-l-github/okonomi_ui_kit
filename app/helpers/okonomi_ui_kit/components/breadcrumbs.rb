# frozen_string_literal: true

module OkonomiUiKit
  module Components
    class Breadcrumbs < Component
      register_styles do
        {
          base: "flex",
          container: "isolate flex -space-x-px rounded-lg shadow-sm",
          nav: "",
          list: "flex items-center space-x-4",
          item: {
            base: "",
            first: "",
            last: "",
            current: ""
          },
          link: {
            base: "ml-4 text-sm font-medium text-gray-500 hover:text-gray-700",
            first: "text-sm font-medium text-gray-500 hover:text-gray-700",
            current: "ml-4 text-sm font-medium text-gray-500"
          },
          separator: {
            base: "size-5 shrink-0 text-gray-400",
            wrapper: ""
          },
          icon: "size-5 text-gray-400"
        }
      end

      def initialize(template, options = {})
        super
        @items = []
        @builder = BreadcrumbBuilder.new(self)
      end

      def render(options = {}, &block)
        return "" if block.nil?

        block.call(@builder)
        view.render("okonomi/components/breadcrumbs/breadcrumbs",
          component: self,
          items: @items,
          options: options
        )
      end

      def add_item(text, path = nil, current: false, icon: nil)
        @items << {
          text: text,
          path: path,
          current: current,
          icon: icon
        }
      end

      class BreadcrumbBuilder
        def initialize(component)
          @component = component
        end

        def link(text, path = nil, current: false, icon: nil, **options)
          # Ignore extra options for now
          @component.add_item(text, path, current: current, icon: icon)
        end
      end
    end
  end
end
