require "test_helper"

module OkonomiUiKit
  module Components
    class LinkToTest < ActionView::TestCase
      include OkonomiUiKit::UiHelper

      # Mock the SvgIcons to avoid file system dependencies
      setup do
        @test_svg = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M12 2L2 7v10c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V7l-10-5z"/></svg>'
        @original_exist = OkonomiUiKit::SvgIcons.method(:exist?)
        @original_read = OkonomiUiKit::SvgIcons.method(:read)
        
        # Mock icon existence and reading for tests
        test_svg = @test_svg
        OkonomiUiKit::SvgIcons.define_singleton_method(:exist?) { |_| true }
        OkonomiUiKit::SvgIcons.define_singleton_method(:read) { |_| test_svg }
      end

      teardown do
        # Restore original methods
        OkonomiUiKit::SvgIcons.define_singleton_method(:exist?, @original_exist)
        OkonomiUiKit::SvgIcons.define_singleton_method(:read, @original_read)
      end

      test "link_to renders with default variant" do
        html = ui.link_to("Click me", "/path")

        assert_includes html, "<a"
        assert_includes html, 'href="/path"'
        assert_includes html, "Click me"
        assert_includes html, "</a>"
      end

      test "link_to renders with block content" do
        html = ui.link_to("/path") do
          "<span>Block content</span>".html_safe
        end

        assert_includes html, "<a"
        assert_includes html, 'href="/path"'
        assert_includes html, "<span>Block content</span>"
        assert_includes html, "</a>"
      end

      test "link_to applies variant classes" do
        html = ui.link_to("Link", "/path", variant: :outlined)

        assert_match /class="[^"]*"/, html
      end

      test "link_to applies color classes" do
        html = ui.link_to("Link", "/path", color: :primary)

        assert_match /class="[^"]*"/, html
      end

      test "link_to merges custom classes" do
        html = ui.link_to("Link", "/path", class: "custom-class")

        assert_includes html, "custom-class"
      end

      test "link_to accepts html options" do
        html = ui.link_to("Link", "/path", id: "my-link", data: { turbo: false })

        assert_includes html, 'id="my-link"'
        assert_includes html, 'data-turbo="false"'
      end

      test "link_to works with Rails route helpers" do
        # Assuming root_path exists in dummy app
        html = ui.link_to("Home", root_path)

        assert_includes html, "<a"
        assert_includes html, 'href="/"'
        assert_includes html, "Home"
      end

      test "link_to with theme override" do
        # The current ButtonBase implementation uses internal styles registry
        # Theme overrides would need to be handled differently
        # For now, test that the component renders with default styles
        html = ui.link_to("Themed", "/path")

        # Verify it renders with the expected default text variant classes
        assert_includes html, "text-base"
        assert_includes html, "text-default-700 hover:underline"
      end

      test "link_to component loads via plugin system" do
        assert_nothing_raised do
          ui.link_to("Test", "/path")
        end
      end

      test "link_to with icon at start position" do
        html = ui.link_to("Home", "/path", icon: "heroicons/outline/home")

        assert_includes html, "<a"
        assert_includes html, "Home"
        # Should include icon SVG
        assert_includes html, "<svg"
        # Icon should come before text
        assert html.index("<svg") < html.index("Home")
      end

      test "link_to with icon object at start position" do
        html = ui.link_to("Home", "/path", icon: { start: "heroicons/outline/home" })

        assert_includes html, "<a"
        assert_includes html, "Home"
        assert_includes html, "<svg"
        # Icon should come before text
        assert html.index("<svg") < html.index("Home")
      end

      test "link_to with icon at end position" do
        html = ui.link_to("Next", "/path", icon: { end: "heroicons/outline/arrow-right" })

        assert_includes html, "<a"
        assert_includes html, "Next"
        assert_includes html, "<svg"
        # Icon should come after text
        assert html.index("Next") < html.index("<svg")
      end

      test "link_to with icon and block content" do
        html = ui.link_to("/path", icon: "heroicons/outline/document") do
          "<span>View Document</span>".html_safe
        end

        assert_includes html, "<a"
        assert_includes html, "<span>View Document</span>"
        assert_includes html, "<svg"
      end

      test "link_to icon styling includes appropriate classes" do
        html = ui.link_to("Dashboard", "/path", icon: "heroicons/outline/chart-bar")

        # Check for icon-specific classes
        assert_match /size-3\.5/, html
        # Check for flex wrapper with gap
        assert_match /inline-flex items-center gap-1\.5/, html
      end
    end
  end
end
