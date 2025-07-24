module OkonomiUiKit
  module AttributeSectionHelper
    def attribute_section(title:, description: nil, **options, &block)
      builder = AttributeSectionBuilder.new(self)

      render 'okonomi/attribute_sections/section',
             builder: builder,
             title: title,
             description: description,
             options: options,
             &block
    end

    class AttributeSectionBuilder
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::CaptureHelper

      def initialize(template)
        @template = template
      end

      def attribute(label, value = nil, **options, &block)
        content = if block_given?
                    capture(&block)
                  elsif value.respond_to?(:call)
                    value.call
                  else
                    value
                  end

        tag.div(class: "py-6 sm:grid sm:grid-cols-3 sm:gap-4") do
          dt_content = tag.dt(label, class: "text-sm font-medium text-gray-900")
          dd_content = tag.dd(content, class: "mt-1 text-sm/6 text-gray-700 sm:col-span-2 sm:mt-0")

          dt_content + dd_content
        end
      end

      private

      def tag
        @template.tag
      end

      def capture(*args, &block)
        @template.capture(*args, &block)
      end
    end
  end
end