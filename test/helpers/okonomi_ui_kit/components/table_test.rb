require "test_helper"

module OkonomiUiKit
  module Components
    class TableTest < ActionView::TestCase
      include OkonomiUiKit::UiHelper

      test "table renders basic structure" do
        html = ui.table do |table|
          table.head do
            table.tr do
              table.th { "Name" }
              table.th { "Email" }
            end
          end +
          table.body do
            table.tr do
              table.td { "John Doe" }
              table.td { "john@example.com" }
            end
          end
        end

        assert_includes html, "<table"
        assert_includes html, "<thead"
        assert_includes html, "<tbody"
        assert_includes html, "John Doe"
        assert_includes html, "john@example.com"
      end

      test "table applies theme classes to cells" do
        html = ui.table do |table|
          table.head do
            table.tr do
              table.th { "Header" }
            end
          end
        end

        assert_includes html, "text-sm font-semibold text-gray-900"
      end

      test "table handles alignment" do
        html = ui.table do |table|
          table.body do
            table.tr do
              table.td(align: :left) { "Left" }
              table.td(align: :center) { "Center" }
              table.td(align: :right) { "Right" }
            end
          end
        end

        assert_includes html, "text-left"
        assert_includes html, "text-center"
        assert_includes html, "text-right"
      end

      test "table handles custom classes" do
        html = ui.table do |table|
          table.body do
            table.tr do
              table.td(class: "custom-class") { "Content" }
            end
          end
        end

        assert_includes html, "custom-class"
      end

      test "table renders empty state" do
        html = ui.table do |table|
          table.body do
            table.empty_state(title: "No data available", colspan: 3)
          end
        end

        assert_includes html, "No data available"
        assert_includes html, 'colspan="3"'
      end

      test "table empty state accepts custom content" do
        html = ui.table do |table|
          table.body do
            table.empty_state(colspan: 2) do
              "<p>Custom empty message</p>".html_safe
            end
          end
        end

        assert_includes html, "<p>Custom empty message</p>"
      end

      test "table accepts html options" do
        html = ui.table(id: "users-table", data: { sortable: true })

        assert_includes html, 'id="users-table"'
        assert_includes html, 'data-sortable="true"'
      end

      test "table handles first and last cell styling" do
        html = ui.table do |table|
          table.body do
            table.tr do
              table.td { "First" }
              table.td { "Middle" }
              table.td { "Last" }
            end
          end
        end

        # First cell has different padding
        assert_includes html, "py-4 pr-3"
        # Middle cells have pl-3 pr-3
        assert_includes html, "pl-3 pr-3"
        # Last cell has relative positioning
        assert_includes html, "relative py-4"
      end

      test "table head cells have proper scope" do
        html = ui.table do |table|
          table.head do
            table.tr do
              table.th(scope: "col") { "Column Header" }
            end
          end
        end

        assert_includes html, 'scope="col"'
      end

      test "table works with complex nested content" do
        html = ui.table do |table|
          table.body do
            table.tr do
              table.td do
                "<div class='flex items-center'><span>Complex</span></div>".html_safe
              end
            end
          end
        end

        assert_includes html, "<div class='flex items-center'>"
        assert_includes html, "<span>Complex</span>"
      end
    end
  end
end
