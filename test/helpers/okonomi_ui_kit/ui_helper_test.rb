require "test_helper"

module OkonomiUiKit
  class UiHelperTest < ActionView::TestCase
    include OkonomiUiKit::UiHelper

    test "confirmation_modal renders with default options" do
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
      assert_includes modal_html, 'data-action="click->modal#confirm"'
    end

    test "modal_data_attributes helper formats data attributes correctly" do
      data_html = ui.modal_data_attributes({ data: { test_attr: "value1", another_attr: "value2" } })
      
      assert_includes data_html, 'data-test-attr="value1"'
      assert_includes data_html, 'data-another-attr="value2"'
    end

    test "modal_data_attributes helper returns empty string when no data" do
      data_html = ui.modal_data_attributes({})
      
      assert_equal "", data_html
    end

    test "modal_panel_class helper builds panel classes correctly" do
      panel_class = ui.modal_panel_class(:lg)
      
      assert_includes panel_class, "relative transform overflow-hidden"
      assert_includes panel_class, "sm:max-w-2xl"
    end

    test "modal_icon_wrapper_class helper builds icon wrapper classes correctly" do
      wrapper_class = ui.modal_icon_wrapper_class(:warning)
      
      assert_includes wrapper_class, "mx-auto flex size-12"
      assert_includes wrapper_class, "bg-red-100"
    end

    test "confirmation_modal uses existing button_class system for actions" do
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
      assert_includes modal_html, "hover:cursor-pointer inline-flex border items-center justify-center"
    end
  end
end