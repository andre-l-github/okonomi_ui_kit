module OkonomiUiKit
  module Components
    class PageHeader < OkonomiUiKit::Component
      def render(options = {}, &block)
        options = options.with_indifferent_access

        classes = tw_merge(
          style(:root),
          options.delete(:class)
        )

        builder = PageHeaderBuilder.new(view, self)

        view.render(template_path, builder: builder, options: options.merge(class: classes), &block)
      end

      register_styles :default do
        {
          root: "flex flex-col gap-2",
          row: "flex w-full justify-between items-center",
          actions: "mt-4 flex md:ml-4 md:mt-0 gap-2"
        }
      end
    end

    class PageHeaderBuilder
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::CaptureHelper

      def initialize(template, component)
        @template = template
        @component = component
        @breadcrumbs_content = nil
        @row_content = nil
      end

      def breadcrumbs(&block)
        @breadcrumbs_content = @template.ui.breadcrumbs(&block)
      end

      def row(&block)
        row_builder = PageHeaderRowBuilder.new(@template, @component)
        yield(row_builder) if block_given?
        @row_content = row_builder.render
      end

      def render
        content = []
        content << @breadcrumbs_content if @breadcrumbs_content
        content << @row_content if @row_content

        @template.safe_join(content.compact)
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

      def initialize(template, component)
        @template = template
        @component = component
        @title_content = nil
        @actions_content = nil
      end

      def title(text, **options)
        @title_content = ui.typography(text, variant: "h1", **options)
      end

      def actions(&block)
        @actions_content = tag.div(class: @component.style(:actions)) do
          capture(&block) if block_given?
        end
      end

      def render
        tag.div(class: @component.style(:row)) do
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
  end
end
