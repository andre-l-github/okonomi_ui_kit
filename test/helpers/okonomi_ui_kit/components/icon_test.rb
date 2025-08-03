require "test_helper"

module OkonomiUiKit
  module Components
    class IconTest < ActionView::TestCase
      include OkonomiUiKit::UiHelper

      # Mock the SvgIcons to avoid file system dependencies
      setup do
        @test_svg = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M12 2L2 7v10c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V7l-10-5z"/></svg>'
        @original_exist = OkonomiUiKit::SvgIcons.method(:exist?)
        @original_read = OkonomiUiKit::SvgIcons.method(:read)
      end

      teardown do
        # Restore original methods
        OkonomiUiKit::SvgIcons.define_singleton_method(:exist?, @original_exist)
        OkonomiUiKit::SvgIcons.define_singleton_method(:read, @original_read)
      end

      test "icon renders with basic usage" do
        test_svg = @test_svg
        OkonomiUiKit::SvgIcons.define_singleton_method(:exist?) { |_| true }
        OkonomiUiKit::SvgIcons.define_singleton_method(:read) { |_| test_svg }

        html = ui.icon("heroicons/outline/home")

        assert_includes html, "<svg"
        assert_includes html, "</svg>"
        assert_includes html, 'viewbox="0 0 24 24"'
      end

      test "icon applies custom classes" do
        test_svg = @test_svg
        OkonomiUiKit::SvgIcons.define_singleton_method(:exist?) { |_| true }
        OkonomiUiKit::SvgIcons.define_singleton_method(:read) { |_| test_svg }

        html = ui.icon("heroicons/outline/user", class: "h-6 w-6 text-blue-500")

        assert_includes html, 'class="inline-block h-6 w-6 text-blue-500"'
      end

      test "icon applies width and height attributes" do
        test_svg = @test_svg
        OkonomiUiKit::SvgIcons.define_singleton_method(:exist?) { |_| true }
        OkonomiUiKit::SvgIcons.define_singleton_method(:read) { |_| test_svg }

        html = ui.icon("heroicons/outline/star", width: "32", height: "32")

        assert_includes html, 'width="32"'
        assert_includes html, 'height="32"'
      end

      test "icon handles non-existent icons gracefully" do
        OkonomiUiKit::SvgIcons.define_singleton_method(:exist?) { |_| false }

        html = ui.icon("non-existent-icon")

        assert_includes html, "<!-- SVG non-existent-icon not found -->"
      end

      test "icon accepts html options" do
        test_svg = @test_svg
        OkonomiUiKit::SvgIcons.define_singleton_method(:exist?) { |_| true }
        OkonomiUiKit::SvgIcons.define_singleton_method(:read) { |_| test_svg }

        html = ui.icon("heroicons/outline/bell",
          id: "notification-icon",
          data: { toggle: "tooltip", placement: "bottom" },
          role: "img",
          "aria-label": "Notifications"
        )

        assert_includes html, 'id="notification-icon"'
        assert_includes html, 'data-toggle="tooltip"'
        assert_includes html, 'data-placement="bottom"'
        assert_includes html, 'role="img"'
        assert_includes html, 'aria-label="Notifications"'
      end

      test "icon loads via plugin system" do
        test_svg = @test_svg
        OkonomiUiKit::SvgIcons.define_singleton_method(:exist?) { |_| true }
        OkonomiUiKit::SvgIcons.define_singleton_method(:read) { |_| test_svg }

        assert_nothing_raised do
          ui.icon("test-icon")
        end
      end


      test "icon handles malformed svg gracefully" do
        malformed_svg = "<svg><not-closed"

        OkonomiUiKit::SvgIcons.define_singleton_method(:exist?) { |_| true }
        OkonomiUiKit::SvgIcons.define_singleton_method(:read) { |_| malformed_svg }

        html = ui.icon("malformed-icon")

        # Nokogiri should handle and fix the malformed SVG
        assert_includes html, "<svg"
      end

      test "icon preserves existing svg attributes" do
        svg_with_attrs = '<svg xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path d="M3 12h18"/></svg>'

        OkonomiUiKit::SvgIcons.define_singleton_method(:exist?) { |_| true }
        OkonomiUiKit::SvgIcons.define_singleton_method(:read) { |_| svg_with_attrs }

        html = ui.icon("test-icon", class: "custom-class")

        assert_includes html, 'fill="none"'
        assert_includes html, 'stroke="currentColor"'
        assert_includes html, 'viewbox="0 0 24 24"'
        assert_includes html, 'class="inline-block custom-class"'
      end

      test "icon variant parameter is accepted but not used" do
        # The variant parameter was in the old implementation but not used
        # We accept it for backward compatibility
        test_svg = @test_svg
        OkonomiUiKit::SvgIcons.define_singleton_method(:exist?) { |_| true }
        OkonomiUiKit::SvgIcons.define_singleton_method(:read) { |_| test_svg }

        html = ui.icon("heroicons/outline/home", variant: :solid)

        assert_includes html, "<svg"
        assert_includes html, "</svg>"
      end
    end
  end
end
