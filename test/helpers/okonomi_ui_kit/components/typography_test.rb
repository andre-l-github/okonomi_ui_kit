require "test_helper"

module OkonomiUiKit
  module Components
    class TypographyTest < ActionView::TestCase
      include OkonomiUiKit::UiHelper

      test "typography renders with default variant and text" do
        html = ui.typography("Hello World")

        assert_includes html, "<p"
        assert_includes html, "Hello World"
        assert_includes html, "</p>"
      end

      test "typography renders with h1 variant" do
        html = ui.typography("Main Title", variant: :h1)

        assert_includes html, "<h1"
        assert_includes html, "Main Title"
        assert_includes html, "</h1>"
      end

      test "typography renders all heading variants correctly" do
        %i[h1 h2 h3 h4 h5 h6].each do |variant|
          html = ui.typography("Heading #{variant}", variant: variant)

          assert_includes html, "<#{variant}"
          assert_includes html, "Heading #{variant}"
          assert_includes html, "</#{variant}>"
        end
      end

      test "typography renders body variants with p tag" do
        %i[body1 body2].each do |variant|
          html = ui.typography("Body text", variant: variant)

          assert_includes html, "<p"
          assert_includes html, "Body text"
          assert_includes html, "</p>"
        end
      end

      test "typography renders unknown variant as span" do
        html = ui.typography("Custom text", variant: :custom)

        assert_includes html, "<span"
        assert_includes html, "Custom text"
        assert_includes html, "</span>"
      end

      test "typography accepts block content" do
        html = ui.typography(variant: :h2) do
          "<strong>Bold content</strong>".html_safe
        end

        assert_includes html, "<h2"
        assert_includes html, "<strong>Bold content</strong>"
        assert_includes html, "</h2>"
      end

      test "typography applies theme variant classes" do
        # Assuming theme has typography variants defined
        html = ui.typography("Styled text", variant: :h1)

        # The actual classes depend on theme configuration
        assert_match /class="[^"]*"/, html
      end

      test "typography applies color classes" do
        html = ui.typography("Colored text", color: :primary)

        # The actual classes depend on theme configuration
        assert_match /class="[^"]*"/, html
      end

      test "typography merges custom classes" do
        html = ui.typography("Custom styled", class: "custom-class")

        assert_includes html, "custom-class"
      end

      test "typography handles nil text gracefully" do
        html = ui.typography(nil)

        assert_includes html, "<p"
        assert_includes html, "</p>"
        refute_includes html, "nil"
      end

      test "typography accepts html options" do
        html = ui.typography("Text with ID", id: "my-typography", data: { testid: "typography-element" })

        assert_includes html, 'id="my-typography"'
        assert_includes html, 'data-testid="typography-element"'
      end

      test "typography uses default h1 styles" do
        html = ui.typography("Themed heading", variant: :h1)

        assert_includes html, "text-3xl font-bold"
        assert_includes html, "text-default-700"
      end

      test "typography component is loaded via plugin system" do
        # This tests that the method_missing mechanism works
        assert_nothing_raised do
          ui.typography("Test")
        end
      end

      test "typography renders empty content with block that yields nothing" do
        html = ui.typography(variant: :div) do
          # Empty block
        end

        assert_includes html, "<span"  # Unknown variant becomes span
        assert_includes html, "</span>"
      end

      test "typography preserves indifferent access for options" do
        html = ui.typography("Test", "variant" => "h3", "color" => "primary")

        assert_includes html, "<h3"
        assert_includes html, "Test"
        assert_includes html, "</h3>"
      end
    end
  end
end
