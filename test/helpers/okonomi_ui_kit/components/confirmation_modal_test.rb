require "test_helper"

module OkonomiUiKit
  module Components
    class ConfirmationModalTest < ActionView::TestCase
      include OkonomiUiKit::UiHelper

      test "confirmation_modal renders with required options" do
        modal_html = ui.confirmation_modal(
          title: "Delete Item",
          message: "Are you sure you want to delete this item?"
        )

        assert_includes modal_html, 'data-controller="modal"'
        assert_includes modal_html, 'data-modal-size-value="md"'
        assert_includes modal_html, "Delete Item"
        assert_includes modal_html, "Are you sure you want to delete this item?"
        assert_includes modal_html, "Confirm"
        assert_includes modal_html, "Cancel"
      end

      test "confirmation_modal renders with custom options" do
        modal_html = ui.confirmation_modal(
          title: "Custom Title",
          message: "Custom message",
          confirm_text: "Yes, Delete",
          cancel_text: "No, Keep",
          variant: :info,
          size: :lg
        )

        assert_includes modal_html, 'data-modal-size-value="lg"'
        assert_includes modal_html, "Custom Title"
        assert_includes modal_html, "Custom message"
        assert_includes modal_html, "Yes, Delete"
        assert_includes modal_html, "No, Keep"
      end

      test "confirmation_modal renders with warning variant by default" do
        modal_html = ui.confirmation_modal(
          title: "Test",
          message: "Test message"
        )

        assert_includes modal_html, "bg-red-100"
        assert_includes modal_html, "text-red-600"
        # Uses danger color for warning variant in buttons
        assert_includes modal_html, "bg-danger-600"
      end

      test "confirmation_modal renders with info variant" do
        modal_html = ui.confirmation_modal(
          title: "Test",
          message: "Test message",
          variant: :info
        )

        assert_includes modal_html, "bg-blue-100"
        assert_includes modal_html, "text-blue-600"
        assert_includes modal_html, "bg-info-600"
      end

      test "confirmation_modal renders with success variant" do
        modal_html = ui.confirmation_modal(
          title: "Test",
          message: "Test message",
          variant: :success
        )

        assert_includes modal_html, "bg-green-100"
        assert_includes modal_html, "text-green-600"
        assert_includes modal_html, "bg-success-600"
      end

      test "confirmation_modal accepts custom data attributes" do
        modal_html = ui.confirmation_modal(
          title: "Test",
          message: "Test message",
          data: { "test-attribute": "test-value", "another-attr": "another-value" }
        )

        assert_includes modal_html, 'data-test-attribute="test-value"'
        assert_includes modal_html, 'data-another-attr="another-value"'
      end

      test "confirmation_modal accepts auto_open option" do
        modal_html = ui.confirmation_modal(
          title: "Test",
          message: "Test message",
          auto_open: true
        )

        assert_includes modal_html, 'data-modal-auto-open-value="true"'
      end

      test "confirmation_modal yields to custom block content" do
        modal_html = ui.confirmation_modal(
          title: "Test",
          message: "Test message"
        ) do
          "<button>Custom Button</button>".html_safe
        end

        assert_includes modal_html, "Custom Button"
        refute_includes modal_html, "Confirm"
        refute_includes modal_html, "Cancel"
      end

      test "confirmation_modal includes proper ARIA attributes" do
        modal_html = ui.confirmation_modal(
          title: "Test",
          message: "Test message"
        )

        assert_includes modal_html, 'role="dialog"'
        assert_includes modal_html, 'aria-modal="true"'
        assert_includes modal_html, 'aria-labelledby="modal-title"'
        assert_includes modal_html, 'aria-hidden="true"'
      end

      test "confirmation_modal includes Stimulus actions" do
        modal_html = ui.confirmation_modal(
          title: "Test",
          message: "Test message"
        )

        assert_includes modal_html, 'data-action="click->modal#close"'
        # button_to generates forms which escape the > character
        assert_includes modal_html, 'data-action="click-&gt;modal#confirm"'
      end

      test "confirmation_modal uses button component for actions" do
        modal_html = ui.confirmation_modal(
          title: "Test",
          message: "Test message",
          variant: :info
        )

        # Should use contained button styling for primary action
        assert_includes modal_html, "bg-info-600 text-white hover:bg-info-700"
        assert_includes modal_html, "sm:ml-3 sm:w-auto"

        # Should use outlined button styling for secondary action
        assert_includes modal_html, "bg-white text-default-700 border-default-700 hover:bg-default-50"
        assert_includes modal_html, "mt-3 sm:mt-0 sm:w-auto"

        # Should include proper button structure
        assert_match /hover:cursor-pointer.*inline-flex.*border.*items-center.*justify-center/, modal_html
      end

      test "confirmation_modal raises error when title is missing" do
        assert_raises(ArgumentError) do
          ui.confirmation_modal(message: "Test message")
        end
      end

      test "confirmation_modal raises error when message is missing" do
        assert_raises(ArgumentError) do
          ui.confirmation_modal(title: "Test title")
        end
      end

      test "confirmation_modal loads via plugin system" do
        assert_nothing_raised do
          ui.confirmation_modal(title: "Test", message: "Test message")
        end
      end

      test "confirmation_modal renders all sizes correctly" do
        %i[sm md lg xl].each do |size|
          modal_html = ui.confirmation_modal(
            title: "Test",
            message: "Test message",
            size: size
          )

          assert_includes modal_html, "data-modal-size-value=\"#{size}\""
          
          case size
          when :sm
            assert_includes modal_html, "sm:max-w-sm"
          when :md
            assert_includes modal_html, "sm:max-w-lg"
          when :lg
            assert_includes modal_html, "sm:max-w-2xl"
          when :xl
            assert_includes modal_html, "sm:max-w-4xl"
          end
        end
      end

      test "confirmation_modal includes close button with proper icon" do
        modal_html = ui.confirmation_modal(
          title: "Test",
          message: "Test message"
        )

        # Icon is rendered as SVG, check for the close button structure instead
        assert_includes modal_html, "<span class=\"sr-only\">Close</span>"
        assert_includes modal_html, 'class="inline-block size-6"'
        assert_includes modal_html, 'data-action="click->modal#close"'
      end

      test "confirmation_modal includes variant-specific icons" do
        # Warning variant - check for red colors
        modal_html = ui.confirmation_modal(title: "Test", message: "Test", variant: :warning)
        assert_includes modal_html, "bg-red-100"
        assert_includes modal_html, "text-red-600"

        # Info variant - check for blue colors
        modal_html = ui.confirmation_modal(title: "Test", message: "Test", variant: :info)
        assert_includes modal_html, "bg-blue-100"
        assert_includes modal_html, "text-blue-600"

        # Success variant - check for green colors
        modal_html = ui.confirmation_modal(title: "Test", message: "Test", variant: :success)
        assert_includes modal_html, "bg-green-100"
        assert_includes modal_html, "text-green-600"
      end

      test "confirmation_modal handles html safe content" do
        modal_html = ui.confirmation_modal(
          title: "<strong>Bold Title</strong>".html_safe,
          message: "<em>Italic message</em>".html_safe
        )

        assert_includes modal_html, "<strong>Bold Title</strong>"
        assert_includes modal_html, "<em>Italic message</em>"
      end
    end
  end
end