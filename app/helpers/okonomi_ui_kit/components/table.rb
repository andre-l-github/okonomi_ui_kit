module OkonomiUiKit
  module Components
    class Table < OkonomiUiKit::Component
      def render(options = {}, &block)
        builder = TableBuilder.new(view, theme)
        view.render(template_path, builder: builder, options: options.with_indifferent_access, &block)
      end
    end

    class TableBuilder
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::CaptureHelper

      def initialize(template, theme)
        @template = template
        @theme = theme
        @current_row_cells = []
        @in_header = false
        @in_body = false
      end

      def head(&block)
        @in_header = true
        @in_body = false
        result = tag.thead(&block)
        @in_header = false
        result
      end

      def body(&block)
        @in_header = false
        @in_body = true
        result = tag.tbody(class: "divide-y divide-gray-200 bg-white", &block)
        @in_body = false
        result
      end

      def tr(&block)
        @current_row_cells = []

        # Collect all cells first
        yield if block_given?

        # Now render each cell with proper first/last detection
        rendered_cells = @current_row_cells.map.with_index do |cell, index|
          is_first = index == 0
          is_last = index == @current_row_cells.length - 1

          if cell[:type] == :th
            render_th(cell, is_first, is_last)
          else
            render_td(cell, is_first, is_last)
          end
        end

        result = tag.tr do
          @template.safe_join(rendered_cells)
        end

        @current_row_cells = []
        result
      end

      def th(scope: "col", align: :left, **options, &block)
        content = capture(&block) if block_given?

        # Store cell data for later processing in tr
        cell = { type: :th, scope: scope, align: align, options: options, content: content }
        @current_row_cells << cell

        # Return empty string for now, actual rendering happens in tr
        ""
      end

      def td(align: :left, **options, &block)
        content = capture(&block) if block_given?

        # Store cell data for later processing in tr
        cell = { type: :td, align: align, options: options, content: content }
        @current_row_cells << cell

        # Return empty string for now, actual rendering happens in tr
        ""
      end

      def empty_state(title: "No records found", icon: "heroicons/outline/document", colspan: nil, &block)
        content = if block_given?
          capture(&block)
        else
          tag.div(class: "text-center py-8") do
            icon_content = if @template.respond_to?(:svg_icon)
              @template.svg_icon(icon, class: "mx-auto h-12 w-12 text-gray-400")
            else
              tag.div(class: "mx-auto h-12 w-12 text-gray-400")
            end

            icon_content + tag.p(title, class: "mt-2 text-sm font-medium text-gray-900") +
            tag.p("Get started by creating a new record.", class: "mt-1 text-sm text-gray-500")
          end
        end

        tr do
          td(colspan: colspan, class: "text-center py-8 text-gray-500") do
            content
          end
        end
      end

      private

      def tag
        @template.tag
      end

      def capture(*args, &block)
        @template.capture(*args, &block)
      end

      def render_th(cell, is_first, is_last)
        align_class = alignment_class(cell[:align])

        if is_first
          full_class = "py-3.5 pr-3 #{align_class} text-sm font-semibold text-gray-900 #{cell[:options][:class] || ""}".strip
        elsif is_last
          full_class = "relative py-3.5 #{align_class} text-sm font-semibold text-gray-900 #{cell[:options][:class] || ""}".strip
        else
          full_class = "pl-3 pr-3 py-3.5 #{align_class} text-sm font-semibold text-gray-900 #{cell[:options][:class] || ""}".strip
        end

        options = cell[:options].except(:class)
        tag.th(cell[:content], scope: cell[:scope], class: full_class, **options)
      end

      def render_td(cell, is_first, is_last)
        align_class = alignment_class(cell[:align])

        if is_first
          full_class = "py-4 pr-3 #{align_class} text-sm font-medium whitespace-nowrap text-gray-900 #{cell[:options][:class] || ""}".strip
        elsif is_last
          full_class = "relative py-4 #{align_class} text-sm font-medium whitespace-nowrap #{cell[:options][:class] || ""}".strip
        else
          full_class = "pl-3 pr-3 py-4 #{align_class} text-sm whitespace-nowrap text-gray-500 #{cell[:options][:class] || ""}".strip
        end

        options = cell[:options].except(:class)
        tag.td(cell[:content], class: full_class, **options)
      end

      def alignment_class(align)
        case align.to_sym
        when :left
          "text-left"
        when :center
          "text-center"
        when :right
          "text-right"
        else
          "text-left"
        end
      end
    end
  end
end
