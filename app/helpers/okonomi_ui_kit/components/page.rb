module OkonomiUiKit
  module Components
    class Page < OkonomiUiKit::Component
      def render(options = {}, &block)
        builder = PageBuilder.new(view)

        view.render(template_path, builder: builder, options: options, &block)
      end
    end

    class PageBuilder
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::CaptureHelper

      def initialize(template)
        @template = template
        @content_parts = []
      end

      def page_header(**options, &block)
        header_builder = PageHeaderBuilder.new(@template)
        yield(header_builder) if block_given?
        @content_parts << header_builder.render
        nil
      end

      def section(**options, &block)
        section_builder = SectionBuilder.new(@template)
        section_builder.title(options[:title]) if options[:title]
        yield(section_builder) if block_given?
        @content_parts << section_builder.render
        nil
      end

      def render_content
        @template.safe_join(@content_parts)
      end

      def to_s
        render_content
      end

      private

      def tag
        @template.tag
      end

      def capture(*args, &block)
        @template.capture(*args, &block)
      end
    end

    class PageHeaderBuilder
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::CaptureHelper

      def initialize(template)
        @template = template
        @breadcrumbs_content = nil
        @row_content = nil
      end

      def breadcrumbs(&block)
        @breadcrumbs_content = @template.ui.breadcrumbs(&block)
      end

      def row(&block)
        row_builder = PageHeaderRowBuilder.new(@template)
        yield(row_builder) if block_given?
        @row_content = row_builder.render
      end

      def render
        content = []
        content << @breadcrumbs_content if @breadcrumbs_content
        content << @row_content if @row_content

        tag.div(class: "flex flex-col gap-2") do
          @template.safe_join(content.compact)
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

    class PageHeaderRowBuilder
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::CaptureHelper

      attr_reader :template

      delegate :ui, to: :template

      def initialize(template)
        @template = template
        @title_content = nil
        @actions_content = nil
      end

      def title(text, **options)
        @title_content = ui.typography(text, variant: "h1", **options)
      end

      def actions(&block)
        @actions_content = tag.div(class: "mt-4 flex md:ml-4 md:mt-0 gap-2") do
          capture(&block) if block_given?
        end
      end

      def render
        tag.div(class: "flex w-full justify-between items-center") do
          content = []
          content << @title_content if @title_content
          content << @actions_content if @actions_content
          @template.safe_join(content.compact)
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

    class SectionBuilder
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::CaptureHelper

      def initialize(template)
        @template = template
        @title_content = nil
        @subtitle_content = nil
        @actions_content = nil
        @body_content = nil
        @attributes = []
      end

      def title(text, **options)
        @title_content = tag.h3(text, class: "text-base/7 font-semibold text-gray-900")
      end

      def subtitle(text, **options)
        @subtitle_content = tag.p(text, class: "mt-1 max-w-2xl text-sm/6 text-gray-500")
      end

      def actions(&block)
        @actions_content = tag.div(class: "mt-4 flex md:ml-4 md:mt-0") do
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
              tag.dl(class: "divide-y divide-gray-100") do
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

        attribute_html = tag.div(class: "py-6 sm:grid sm:grid-cols-3 sm:gap-4") do
          dt_content = tag.dt(label, class: "text-sm font-medium text-gray-900")
          dd_content = tag.dd(content, class: "mt-1 text-sm/6 text-gray-700 sm:col-span-2 sm:mt-0")

          dt_content + dd_content
        end

        @attributes << attribute_html
      end

      def render
        tag.div(class: "overflow-hidden bg-white") do
          header_content = build_header
          content_parts = []
          content_parts << header_content if header_content.present?
          content_parts << @body_content if @body_content
          @template.safe_join(content_parts.compact)
        end
      end

      private

      def build_header
        return nil unless @title_content || @subtitle_content || @actions_content

        tag.div(class: "py-6") do
          if @actions_content
            tag.div(class: "flex w-full justify-between items-start") do
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

      def tag
        @template.tag
      end

      def capture(*args, &block)
        @template.capture(*args, &block)
      end
    end
  end
end
