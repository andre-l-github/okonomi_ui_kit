require "test_helper"

module OkonomiUiKit
  module Components
    class ButtonTagTest < ActionView::TestCase
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

      test "button_tag renders with default variant" do
        html = ui.button_tag("Click me")

        assert_includes html, "<button"
        assert_includes html, "Click me"
        assert_includes html, "</button>"
      end

      test "button_tag renders with block content" do
        html = ui.button_tag do
          "<span>Block button</span>".html_safe
        end

        assert_includes html, "<button"
        assert_includes html, "<span>Block button</span>"
        assert_includes html, "</button>"
      end

      test "button_tag applies variant classes" do
        html = ui.button_tag("Button", variant: :outlined)

        assert_match /class="[^"]*"/, html
        assert_includes html, "border"
      end

      test "button_tag applies color classes" do
        html = ui.button_tag("Button", color: :primary)

        assert_match /class="[^"]*"/, html
      end

      test "button_tag merges custom classes" do
        html = ui.button_tag("Button", class: "custom-button-class")

        assert_includes html, "custom-button-class"
      end

      test "button_tag accepts html options" do
        html = ui.button_tag("Button", id: "my-button", data: { testid: "button-element" })

        assert_includes html, 'id="my-button"'
        assert_includes html, 'data-testid="button-element"'
      end

      test "button_tag with icon at start position" do
        html = ui.button_tag("Download", icon: "heroicons/outline/download")

        assert_includes html, "<button"
        assert_includes html, "Download"
        # Should include icon SVG
        assert_includes html, "<svg"
        # Icon should come before text
        assert html.index("<svg") < html.index("Download")
      end

      test "button_tag with icon object at start position" do
        html = ui.button_tag("Download", icon: { start: "heroicons/outline/download" })

        assert_includes html, "<button"
        assert_includes html, "Download"
        assert_includes html, "<svg"
        # Icon should come before text
        assert html.index("<svg") < html.index("Download")
      end

      test "button_tag with icon at end position" do
        html = ui.button_tag("Next", icon: { end: "heroicons/outline/arrow-right" })

        assert_includes html, "<button"
        assert_includes html, "Next"
        assert_includes html, "<svg"
        # Icon should come after text
        assert html.index("Next") < html.index("<svg")
      end

      test "button_tag with icon and block content" do
        html = ui.button_tag(icon: "heroicons/outline/user") do
          "<span>User Profile</span>".html_safe
        end

        assert_includes html, "<button"
        assert_includes html, "<span>User Profile</span>"
        assert_includes html, "<svg"
      end

      test "button_tag icon styling includes appropriate classes" do
        html = ui.button_tag("Save", icon: "heroicons/outline/save")

        # Check for icon-specific classes
        assert_match /size-3\.5/, html
        # Check for flex wrapper with gap
        assert_match /inline-flex items-center gap-1\.5/, html
      end

      test "button_tag icon at end position includes appropriate classes" do
        html = ui.button_tag("Next", icon: { end: "heroicons/outline/arrow-right" })

        # Check for icon-specific classes
        assert_match /size-3\.5/, html
        # Check for flex wrapper with gap
        assert_match /inline-flex items-center gap-1\.5/, html
      end

      test "button_tag component loads via plugin system" do
        assert_nothing_raised do
          ui.button_tag("Test")
        end
      end

      test "button_tag accepts disabled option" do
        html = ui.button_tag("Click me", disabled: true)

        assert_includes html, 'disabled="disabled"'
        assert_includes html, "Click me"
      end

      test "button_tag with disabled option and other attributes" do
        html = ui.button_tag("Save", disabled: true, id: "save-button", variant: :ghost, color: :primary)

        assert_includes html, 'disabled="disabled"'
        assert_includes html, 'id="save-button"'
        assert_includes html, "Save"
      end
    end
  end
end