require "test_helper"

module OkonomiUiKit
  module Components
    class DropdownButtonTest < ActionView::TestCase
      include OkonomiUiKit::UiHelper
      
      test "dropdown button requires a block" do
        assert_raises(ArgumentError) do
          ui.dropdown_button
        end
      end
      
      test "dropdown button renders with link items" do
        html = ui.dropdown_button do |dd|
          dd.link_to "Profile", "#", id: "profile-link"
          dd.link_to "Settings", "#", id: "settings-link"
        end
        
        assert_includes html, 'data-controller="dropdown"'
        # The click->dropdown#toggle is HTML escaped in the output
        assert_match /data-action="[^"]*dropdown#toggle/, html
        assert_includes html, "Profile"
        assert_includes html, "Settings"
        assert_includes html, 'data-dropdown-target="menu"'
      end
      
      test "dropdown button renders with button items" do
        html = ui.dropdown_button do |dd|
          dd.button_to "Delete", "#", method: :delete
          dd.button_to "Archive", "#", method: :post
        end
        
        assert_includes html, "Delete"
        assert_includes html, "Archive"
        assert_includes html, '_method'
        assert_includes html, 'value="delete"'
      end
      
      test "dropdown button supports dividers" do
        html = ui.dropdown_button do |dd|
          dd.link_to "Profile", "#"
          dd.divider
          dd.button_to "Logout", "#", method: :delete
        end
        
        assert_includes html, 'role="separator"'
      end
      
      test "dropdown button supports icons" do
        html = ui.dropdown_button do |dd|
          dd.link_to "Profile", "#", icon: "heroicons/outline/user"
          dd.link_to "Settings", "#", icon: "heroicons/outline/cog"
        end
        
        # Icons are rendered as SVG content, not as file paths
        assert_includes html, "<svg"
        assert_includes html, "Profile"
        assert_includes html, "Settings"
      end
      
      test "dropdown button inherits button styles" do
        html = ui.dropdown_button(variant: :outlined, color: :primary) do |dd|
          dd.link_to "Profile", "#"
        end
        
        # Check that it uses ButtonBase styling
        assert_match /class="[^"]*border[^"]*"/, html
      end
      
      test "dropdown button uses first item as primary action" do
        html = ui.dropdown_button do |dd|
          dd.link_to "Main Action", "#"
          dd.link_to "Secondary", "#"
        end
        
        # The main action should be in the split button
        assert_includes html, "Main Action"
        assert_includes html, "Secondary"
        
        # Only secondary action should appear in the menu
        menu_section = html.split('data-dropdown-target="menu"').last
        refute_includes menu_section, "Main Action"
        assert_includes menu_section, "Secondary"
        
        # Should have split button structure
        assert_includes html, "rounded-l-md"
        assert_includes html, "rounded-r-md"
      end
      
      test "dropdown button accepts html options" do
        html = ui.dropdown_button(id: "my-dropdown", data: { testid: "dropdown" }) do |dd|
          dd.link_to "Profile", "#"
        end
        
        assert_includes html, 'id="my-dropdown"'
        assert_includes html, 'data-testid="dropdown"'
      end
      
      test "dropdown button accepts custom menu classes" do
        html = ui.dropdown_button(menu_class: "custom-menu-class") do |dd|
          dd.link_to "Profile", "#"
          dd.link_to "Settings", "#"  # Need multiple items to have a menu
        end
        
        assert_includes html, "custom-menu-class"
      end
      
      test "dropdown button works with block content for items" do
        html = ui.dropdown_button do |dd|
          dd.link_to nil, "#" do
            "<strong>Custom Profile</strong>".html_safe
          end
        end
        
        assert_includes html, "<strong>Custom Profile</strong>"
      end
      
      test "dropdown button supports button_tag as primary action" do
        html = ui.dropdown_button do |dd|
          dd.button_tag "Copy", data: { action: "click->clipboard#copy" }, icon: "heroicons/outline/clipboard"
          dd.link_to "Edit", "#"
        end
        
        assert_includes html, "Copy"
        assert_match /data-action="[^"]*clipboard#copy/, html
        # Icon is rendered as SVG, not as path
        assert_includes html, "<svg"
        # Button tag should render as button element
        assert_match /<button[^>]*data-action=/, html
      end
      
      test "dropdown button supports button_tag in menu items" do
        html = ui.dropdown_button do |dd|
          dd.link_to "View", "#"
          dd.button_tag "Copy to clipboard", data: { action: "click->clipboard#copy" }
          dd.button_tag "Share", data: { action: "click->share#open" }, icon: "heroicons/outline/share"
        end
        
        assert_includes html, "Copy to clipboard"
        assert_includes html, "Share"
        assert_match /data-action="[^"]*clipboard#copy/, html
        assert_match /data-action="[^"]*share#open/, html
      end
      
      test "dropdown button button_tag with block content" do
        html = ui.dropdown_button do |dd|
          dd.button_tag data: { action: "click->custom#action" } do
            "<span class='custom'>Custom Action</span>".html_safe
          end
          dd.link_to "Other", "#"
        end
        
        assert_includes html, "<span class='custom'>Custom Action</span>"
        assert_match /data-action="[^"]*custom#action/, html
      end
      
      test "dropdown button adds deferred close action to all menu items" do
        html = ui.dropdown_button do |dd|
          dd.link_to "First", "#"
          dd.link_to "Second", "#", data: { action: "click->custom#action" }
          dd.button_to "Third", "#", method: :post
          dd.button_tag "Fourth", data: { action: "click->other#action" }
        end
        
        # All menu items should have the closeDeferred action
        assert_match /data-action="[^"]*dropdown#closeDeferred/, html
        # Custom actions should be preserved
        assert_match /data-action="[^"]*custom#action[^"]*dropdown#closeDeferred/, html
        assert_match /data-action="[^"]*other#action[^"]*dropdown#closeDeferred/, html
      end
      
      test "dropdown button handles onclick with deferred close" do
        html = ui.dropdown_button do |dd|
          dd.link_to "First", "#"
          dd.button_tag "Print", onclick: "window.print()"
        end
        
        # Should have modified onclick
        assert_includes html, "window.print();"
        assert_includes html, "setTimeout"
      end
      
      test "dropdown button renders as single button when only primary action provided" do
        html = ui.dropdown_button(variant: :contained, color: :primary) do |dd|
          dd.link_to "Create New", "#", icon: "heroicons/outline/plus"
        end
        
        # Should not have split button structure
        refute_includes html, "rounded-l-md"
        refute_includes html, "rounded-r-md"
        # Should have normal rounded corners
        assert_includes html, "rounded-md"
        # Should not have chevron icon
        refute_includes html, "chevron-down"
        # Should not have dropdown menu
        refute_includes html, 'data-dropdown-target="menu"'
        # Should have the primary action
        assert_includes html, "Create New"
      end
      
      test "dropdown button renders with split button when multiple actions provided" do
        html = ui.dropdown_button do |dd|
          dd.link_to "Primary", "#"
          dd.link_to "Secondary", "#"
        end
        
        # Should have split button structure
        assert_includes html, "rounded-l-md"
        assert_includes html, "rounded-r-md"
        # Should have chevron icon (as SVG)
        assert_includes html, "Open options"  # Check for sr-only text instead
        # Should have dropdown menu
        assert_includes html, 'data-dropdown-target="menu"'
      end
    end
  end
end