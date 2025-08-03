require "test_helper"

class ShowcaseTest < ActionDispatch::IntegrationTest
  include OkonomiUiKit::UiHelper
  test "modals showcase page renders without errors" do
    get "/components/modals"
    assert_response :success
    assert_select 'h1', text: /Confirmation Modals Showcase/
  end

  test "confirmation modal component renders in showcase" do
    get "/components/modals"
    assert_response :success
    
    # Check that modal HTML is present
    assert_select '[data-controller="modal"]'
    assert_select '[data-modal-size-value]'
    assert_select '[role="dialog"]'
    assert_select '[aria-modal="true"]'
  end

  test "all showcase pages render successfully" do
    %w[typography icons page_builder form_builder modals tables navigation].each do |component|
      get "/components/#{component}"
      assert_response :success, "Showcase page for #{component} should render successfully"
    end
  end

  test "confirmation modal renders via ui helper" do
    # This tests that the component is properly loaded via the plugin system
    # We need to use the proper view paths from the Rails app
    lookup_context = ActionView::LookupContext.new(
      Rails.application.paths["app/views"].to_a + OkonomiUiKit::Engine.paths["app/views"].to_a
    )
    
    view_class = ActionView::Base.with_empty_template_cache
    view = view_class.new(lookup_context, {}, ApplicationController.new)
    view.extend(OkonomiUiKit::UiHelper)
    
    html = view.ui.confirmation_modal(
      title: "Test Modal",  
      message: "Test message"
    )
    
    assert html.present?, "confirmation_modal should return HTML"
    assert html.include?('data-controller="modal"'), "Should include modal controller"
    assert html.include?("Test Modal"), "Should include the title"
    assert html.include?("Test message"), "Should include the message"
  end
end