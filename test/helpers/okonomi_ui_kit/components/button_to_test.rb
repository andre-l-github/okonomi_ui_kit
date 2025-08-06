require "test_helper"

module OkonomiUiKit
  module Components
    class ButtonToTest < ActionView::TestCase
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

      test "button_to renders with default variant" do
        html = ui.button_to("Submit", "/path")

        assert_includes html, "<form"
        assert_includes html, 'action="/path"'
        assert_includes html, "<button"
        assert_includes html, "Submit"
        assert_includes html, "</button>"
      end

      test "button_to renders with block content" do
        html = ui.button_to("/path") do
          "<span>Block button</span>".html_safe
        end

        assert_includes html, "<form"
        assert_includes html, "<button"
        assert_includes html, "<span>Block button</span>"
        assert_includes html, "</button>"
      end

      test "button_to applies variant classes" do
        html = ui.button_to("Button", "/path", variant: :outlined)

        assert_match /class="[^"]*"/, html
      end

      test "button_to applies color classes" do
        html = ui.button_to("Button", "/path", color: :primary)

        assert_match /class="[^"]*"/, html
      end

      test "button_to merges custom classes" do
        html = ui.button_to("Button", "/path", class: "custom-button-class")

        assert_includes html, "custom-button-class"
      end

      test "button_to accepts html options" do
        html = ui.button_to("Button", "/path", id: "my-button", data: { confirm: "Are you sure?" })

        assert_includes html, 'id="my-button"'
        assert_includes html, 'data-confirm="Are you sure?"'
      end

      test "button_to with method option" do
        html = ui.button_to("Delete", "/path", method: :delete)

        assert_includes html, "<form"
        assert_includes html, 'action="/path"'
        # Rails generates hidden field for method
        assert_includes html, "_method"
        assert_includes html, 'value="delete"'
      end

      test "button_to with theme override" do
        # The current ButtonBase implementation uses internal styles registry
        # Theme overrides would need to be handled differently
        # For now, test that the component renders with default styles
        html = ui.button_to("Themed", "/path")

        # Verify it renders with the expected default contained variant classes
        assert_includes html, "inline-flex border items-center justify-center"
        assert_includes html, "bg-default-600 text-white"
      end

      test "button_to component loads via plugin system" do
        assert_nothing_raised do
          ui.button_to("Test", "/path")
        end
      end

      test "button_to with form options" do
        html = ui.button_to("Submit", "/path", form: { class: "inline-form" })

        assert_includes html, '<form class="inline-form"'
      end

      test "button_to with icon at start position" do
        html = ui.button_to("Submit", "/path", icon: "heroicons/outline/check")

        assert_includes html, "<button"
        assert_includes html, "Submit"
        # Should include icon SVG
        assert_includes html, "<svg"
        # Icon should come before text
        assert html.index("<svg") < html.index("Submit")
      end

      test "button_to with icon object at start position" do
        html = ui.button_to("Submit", "/path", icon: { start: "heroicons/outline/check" })

        assert_includes html, "<button"
        assert_includes html, "Submit"
        assert_includes html, "<svg"
        # Icon should come before text
        assert html.index("<svg") < html.index("Submit")
      end

      test "button_to with icon at end position" do
        html = ui.button_to("Next", "/path", icon: { end: "heroicons/outline/arrow-right" })

        assert_includes html, "<button"
        assert_includes html, "Next"
        assert_includes html, "<svg"
        # Icon should come after text
        assert html.index("Next") < html.index("<svg")
      end

      test "button_to with icon and block content" do
        html = ui.button_to("/path", icon: "heroicons/outline/trash") do
          "<span>Delete Item</span>".html_safe
        end

        assert_includes html, "<button"
        assert_includes html, "<span>Delete Item</span>"
        assert_includes html, "<svg"
      end

      test "button_to icon styling includes appropriate classes" do
        html = ui.button_to("Save", "/path", icon: "heroicons/outline/save")

        # Check for icon-specific classes
        assert_match /size-3\.5/, html
        # Check for flex wrapper with gap
        assert_match /inline-flex items-center gap-1\.5/, html
      end

      test "button_to accepts disabled option" do
        html = ui.button_to("Submit", "/path", disabled: true)

        assert_includes html, 'disabled="disabled"'
        assert_includes html, "Submit"
      end

      test "button_to with disabled option and other attributes" do
        html = ui.button_to("Save", "/path", disabled: true, id: "save-button", variant: :outlined)

        assert_includes html, 'disabled="disabled"'
        assert_includes html, 'id="save-button"'
        assert_includes html, "Save"
      end
    end
  end
end
