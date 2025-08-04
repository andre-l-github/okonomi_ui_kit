module OkonomiUiKit
  module Components
    class PageSection < OkonomiUiKit::Component
      def render(options = {}, &block)
        options = options.with_indifferent_access
        title = options.delete(:title)

        classes = tw_merge(
          style(:root),
          options.delete(:class)
        )

        builder = SectionBuilder.new(view, self)
        builder.title(title) if title

        view.render(template_path, builder: builder, options: options.merge(class: classes), &block)
      end

      register_styles :default do
        {
          root: "overflow-hidden bg-white",
          header: "py-6",
          header_with_actions: "flex w-full justify-between items-start",
          title: "text-base/7 font-semibold text-gray-900",
          subtitle: "mt-1 max-w-2xl text-sm/6 text-gray-500",
          actions: "mt-4 flex md:ml-4 md:mt-0",
          attribute_list: "divide-y divide-gray-100",
          attribute_row: "py-6 sm:grid sm:grid-cols-3 sm:gap-4",
          attribute_label: "text-sm font-medium text-gray-900",
          attribute_value: "mt-1 text-sm/6 text-gray-700 sm:col-span-2 sm:mt-0"
        }
      end
    end

    class SectionBuilder
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::CaptureHelper

      def initialize(template, component)
        @template = template
        @component = component
        @title_content = nil
        @subtitle_content = nil
        @actions_content = nil
        @body_content = nil
        @attributes = []
      end

      def title(text, **options)
        @title_content = tag.h3(text, class: @component.style(:title))
      end

      def subtitle(text, **options)
        @subtitle_content = tag.p(text, class: @component.style(:subtitle))
      end

      def actions(&block)
        @actions_content = tag.div(class: @component.style(:actions)) do
          capture(&block) if block_given?
        end
      end

      def body(&block)
        if block_given?
          # Capture the content first to see if attributes were used
          content = capture { yield(self) }

          @body_content = if @attributes.any?
            # If attributes were added, wrap them in dl
            tag.div do
              tag.dl(class: @component.style(:attribute_list)) do
                @template.safe_join(@attributes)
              end
            end
          else
            # Otherwise, just return the captured content
            tag.div do
              content
            end
          end
        end
      end

      def attribute(label, value = nil, **options, &block)
        content = if block_given?
          capture(&block)
        elsif value.respond_to?(:call)
          value.call
        else
          value
        end

        attribute_html = tag.div(class: @component.style(:attribute_row)) do
          dt_content = tag.dt(label, class: @component.style(:attribute_label))
          dd_content = tag.dd(content, class: @component.style(:attribute_value))

          dt_content + dd_content
        end

        @attributes << attribute_html
      end

      def render_header
        return nil unless @title_content || @subtitle_content || @actions_content

        tag.div(class: @component.style(:header)) do
          if @actions_content
            tag.div(class: @component.style(:header_with_actions)) do
              title_section = tag.div do
                content_parts = []
                content_parts << @title_content if @title_content
                content_parts << @subtitle_content if @subtitle_content
                @template.safe_join(content_parts.compact)
              end

              title_section + @actions_content
            end
          else
            content_parts = []
            content_parts << @title_content if @title_content
            content_parts << @subtitle_content if @subtitle_content
            @template.safe_join(content_parts.compact)
          end
        end
      end

      def render_content
        content_parts = []
        content_parts << render_header
        content_parts << @body_content if @body_content
        @template.safe_join(content_parts.compact)
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
