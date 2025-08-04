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
    end
  end
end