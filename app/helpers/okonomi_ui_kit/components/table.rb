module OkonomiUiKit
  module Components
    class Table < OkonomiUiKit::Component
      def render(options = {}, &block)
        options = options.with_indifferent_access
        variant = (options.delete(:variant) || :default).to_sym
        
        builder = TableBuilder.new(view, theme, self, variant)
        view.render(template_path, builder: builder, options: options, &block)
      end

      register_styles :default do
        {
          default: {
            body: {
              base: "divide-y divide-gray-200 bg-white"
            },
            th: {
              base: "text-sm font-semibold text-gray-900",
              first: "py-3.5 pr-3",
              last: "relative py-3.5",
              middle: "pl-3 pr-3 py-3.5"
            },
            td: {
              base: "text-sm whitespace-nowrap",
              first: "py-4 pr-3 font-medium text-gray-900",
              last: "relative py-4 font-medium",
              middle: "pl-3 pr-3 py-4 text-gray-500"
            },
            alignment: {
              left: "text-left",
              center: "text-center",
              right: "text-right"
            },
            empty_state: {
              wrapper: "text-center py-8",
              icon: "mx-auto h-12 w-12 text-gray-400",
              title: "mt-2 text-sm font-medium text-gray-900",
              subtitle: "mt-1 text-sm text-gray-500",
              cell: "text-center py-8 text-gray-500"
            }
          }
        }
      end
    end

    class TableBuilder
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::CaptureHelper

      def initialize(template, theme, style_provider, variant = :default)
        @template = template
        @theme = theme
        @style_provider = style_provider
        @variant = variant
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
        result = tag.tbody(class: style(:body, :base), &block)
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
          tag.div(class: style(:empty_state, :wrapper)) do
            icon_content = if @template.respond_to?(:ui)
              @template.ui.icon(icon, class: style(:empty_state, :icon))
            else
              tag.div(class: style(:empty_state, :icon))
            end

            icon_content + tag.p(title, class: style(:empty_state, :title)) +
            tag.p("Get started by creating a new record.", class: style(:empty_state, :subtitle))
          end
        end

        tr do
          td(colspan: colspan, class: style(:empty_state, :cell)) do
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
        align_class = style(:alignment, cell[:align]) || style(:alignment, :left)
        
        position_class = if is_first
          style(:th, :first)
        elsif is_last
          style(:th, :last)
        else
          style(:th, :middle)
        end

        classes = [
          style(:th, :base),
          position_class,
          align_class,
          cell[:options][:class]
        ].compact.join(' ')

        options = cell[:options].except(:class)
        tag.th(cell[:content], scope: cell[:scope], class: classes, **options)
      end

      def render_td(cell, is_first, is_last)
        align_class = style(:alignment, cell[:align]) || style(:alignment, :left)
        
        position_class = if is_first
          style(:td, :first)
        elsif is_last
          style(:td, :last)
        else
          style(:td, :middle)
        end

        classes = [
          style(:td, :base),
          position_class,
          align_class,
          cell[:options][:class]
        ].compact.join(' ')

        options = cell[:options].except(:class)
        tag.td(cell[:content], class: classes, **options)
      end

      def style(*keys)
        @style_provider.style(@variant, *keys)
      end
    end
  end
end
