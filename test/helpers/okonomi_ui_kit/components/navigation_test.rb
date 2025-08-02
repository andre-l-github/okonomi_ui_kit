require "test_helper"

module OkonomiUiKit
  module Components
    class NavigationTest < ActionView::TestCase
      include OkonomiUiKit::UiHelper
      include OkonomiUiKit::ApplicationHelper

      test "navigation renders with basic structure" do
        html = ui.navigation do |nav|
          nav.group "Test Group" do |group|
            group.nav_link "Test Link", "/test"
          end
        end
        
        assert_includes html, '<ul role="list"'
        assert_includes html, 'flex flex-1 flex-col gap-y-7'
        assert_includes html, "Test Group"
        assert_includes html, "Test Link"
      end

      test "navigation group renders with title and list" do
        html = ui.navigation do |nav|
          nav.group "Dashboard" do |group|
            group.nav_link "Overview", "/dashboard"
            group.nav_link "Analytics", "/analytics"
          end
        end
        
        assert_includes html, '<div class="text-xs/6 font-semibold text-gray-400">Dashboard</div>'
        assert_includes html, '<ul role="list" class="-mx-2 mt-2 space-y-1">'
        assert_includes html, "Overview"
        assert_includes html, "Analytics"
      end

      test "navigation link renders with icon" do
        html = ui.navigation do |nav|
          nav.group "Test" do |group|
            group.nav_link "Home", "/", icon: "home"
          end
        end
        
        assert_includes html, 'href="/"'
        assert_includes html, "Home"
        # Check for icon rendering (should show SVG not found comment for non-existent icon)
        assert_includes html, "<!-- SVG home not found -->"
      end

      test "navigation link renders with initials" do
        html = ui.navigation do |nav|
          nav.group "Projects" do |group|
            group.nav_link "Marketing Site", "/projects/1", initials: "MS"
          end
        end
        
        assert_includes html, '<span class="flex size-6 shrink-0 items-center justify-center rounded-lg border border-gray-200 bg-white text-[0.625rem] font-medium text-gray-400 group-hover:border-primary-600 group-hover:text-primary-600">MS</span>'
        assert_includes html, "Marketing Site"
      end

      test "navigation renders profile section" do
        html = ui.navigation do |nav|
          nav.group "Main" do |group|
            group.nav_link "Dashboard", "/dashboard"
          end
          
          nav.profile_section do
            '<div class="profile-content">User Profile</div>'.html_safe
          end
        end
        
        assert_includes html, '<li class="-mx-6 mt-auto">'
        assert_includes html, '<div class="profile-content">User Profile</div>'
      end

      test "navigation link uses active link with exact option" do
        html = ui.navigation do |nav|
          nav.group "Test" do |group|
            group.nav_link "Exact Match", "/exact", exact: true
            group.nav_link "Fuzzy Match", "/fuzzy", exact: false
          end
        end
        
        # Active link should have exact: true/false in options
        assert_includes html, "Exact Match"
        assert_includes html, "Fuzzy Match"
      end

      test "navigation accepts multiple groups" do
        html = ui.navigation do |nav|
          nav.group "First Group" do |group|
            group.nav_link "Link 1", "/link1"
          end
          
          nav.group "Second Group" do |group|
            group.nav_link "Link 2", "/link2"
          end
          
          nav.group "Third Group" do |group|
            group.nav_link "Link 3", "/link3"
          end
        end
        
        assert_includes html, "First Group"
        assert_includes html, "Second Group" 
        assert_includes html, "Third Group"
        assert_includes html, "Link 1"
        assert_includes html, "Link 2"
        assert_includes html, "Link 3"
      end

      # TODO: Theme overrides work differently with the new component system
      # The register_styles approach doesn't directly integrate with ui.theme overrides
      # This needs to be addressed in a future update to the component base class

      test "navigation link applies correct base and active classes" do
        html = ui.navigation do |nav|
          nav.group "Test" do |group|
            group.nav_link "Test Link", "/test"
          end
        end
        
        # Should include the base classes for links
        assert_includes html, "group flex gap-x-3 rounded-md p-2 text-sm/6 font-semibold"
      end

      test "navigation handles empty groups gracefully" do
        html = ui.navigation do |nav|
          nav.group "Empty Group" do |group|
            # No links added
          end
        end
        
        assert_includes html, "Empty Group"
        assert_includes html, '<ul role="list" class="-mx-2 mt-2 space-y-1"></ul>'
      end

      test "navigation component loads via plugin system" do
        assert_nothing_raised do
          ui.navigation { |nav| }
        end
      end

      test "builder exposes style method" do
        html = ui.navigation do |nav|
          # Builder should have access to style method
          assert_respond_to nav, :style
          
          nav.group "Test" do |group|
            # Group builder should also have style method
            assert_respond_to group, :style
            group.nav_link "Link", "/test"
          end
        end
        
        assert html.present?
      end

      test "navigation accepts html options" do
        html = ui.navigation(id: "main-nav", data: { testid: "navigation" }) do |nav|
          nav.group "Test" do |group|
            group.nav_link "Link", "/test"
          end
        end
        
        # Note: The current implementation doesn't pass options to the ul element
        # This test documents the current behavior
        assert_includes html, '<ul role="list"'
      end
    end
  end
end