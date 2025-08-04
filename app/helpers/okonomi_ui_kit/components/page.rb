module OkonomiUiKit
  module Components
    class Page < OkonomiUiKit::Component
      def render(options = {}, &block)
        options = options.with_indifferent_access

        classes = tw_merge(
          style(:root),
          options.delete(:class)
        )

        builder = PageBuilder.new(view)

        view.render(template_path, builder: builder, options: options.merge(class: classes), &block)
      end

      register_styles :default do
        {
          root: "flex flex-col gap-8 p-8"
        }
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
        @content_parts << @template.ui.page_header(options, &block)
        nil
      end

      def section(**options, &block)
        @content_parts << @template.ui.page_section(options, &block)
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
  end
end
