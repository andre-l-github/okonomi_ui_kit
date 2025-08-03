require "test_helper"

module OkonomiUiKit
  module Components
    class ButtonToTest < ActionView::TestCase
      include OkonomiUiKit::UiHelper

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
        ui.theme(components: { link: { contained: { root: "theme-button-class" } } }) do
          html = ui.button_to("Themed", "/path")

          assert_includes html, "theme-button-class"
        end
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
    end
  end
end
