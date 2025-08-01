require "test_helper"

module OkonomiUiKit
  module Components
    class BreadcrumbsTest < ActionView::TestCase
      include OkonomiUiKit::UiHelper

      test "breadcrumbs renders with basic links" do
        html = ui.breadcrumbs do |crumb|
          crumb.link("Home", "/")
          crumb.link("Products", "/products")
        end
        
        assert_includes html, 'aria-label="Breadcrumb"'
        assert_includes html, '<ol role="list"'
        assert_includes html, "Home"
        assert_includes html, "Products"
        assert_includes html, 'href="/"'
        assert_includes html, 'href="/products"'
      end

      test "breadcrumbs marks current page correctly" do
        html = ui.breadcrumbs do |crumb|
          crumb.link("Home", "/")
          crumb.link("Products", "/products")
          crumb.link("iPhone", "/products/iphone", current: true)
        end
        
        assert_includes html, 'aria-current="page"'
        assert_includes html, "iPhone"
      end

      test "breadcrumbs renders text without link for current page" do
        html = ui.breadcrumbs do |crumb|
          crumb.link("Home", "/")
          crumb.link("Current Page", nil, current: true)
        end
        
        assert_includes html, "Current Page"
        assert_includes html, '<span'
        assert_includes html, 'aria-current="page"'
      end

      test "breadcrumbs renders with icon on first item" do
        icon_html = '<svg class="h-5 w-5" fill="currentColor" viewBox="0 0 20 20"><path d="M10 10z"/></svg>'.html_safe
        
        html = ui.breadcrumbs do |crumb|
          crumb.link("Home", "/", icon: icon_html)
          crumb.link("Products", "/products")
        end
        
        assert_includes html, '<svg class="h-5 w-5"'
        assert_includes html, "Home"
      end

      test "breadcrumbs renders chevron separators between items" do
        html = ui.breadcrumbs do |crumb|
          crumb.link("Home", "/")
          crumb.link("Products", "/products")
          crumb.link("iPhone", "/products/iphone")
        end
        
        # Check for chevron SVG
        assert_includes html, '<svg class='
        assert_includes html, 'viewBox="0 0 20 20"'
        assert_includes html, 'aria-hidden="true"'
      end

      test "breadcrumbs renders empty when no items provided" do
        html = ui.breadcrumbs do |crumb|
          # No items
        end
        
        assert_includes html, '<nav'
        assert_includes html, '<ol'
        assert_includes html, '</ol>'
        assert_includes html, '</nav>'
      end

      test "breadcrumbs applies theme styles correctly" do
        html = ui.breadcrumbs do |crumb|
          crumb.link("Home", "/")
          crumb.link("Products", "/products")
        end
        
        # Should have nav classes
        assert_match /<nav[^>]*class="[^"]*"/, html
        
        # Should have list classes  
        assert_match /<ol[^>]*class="[^"]*flex items-center/, html
      end

      test "breadcrumbs renders without block returns empty nav" do
        html = ui.breadcrumbs
        
        assert_equal "", html
      end

      test "breadcrumbs accepts html options" do
        html = ui.breadcrumbs(id: "main-breadcrumbs", data: { testid: "breadcrumbs" }) do |crumb|
          crumb.link("Home", "/")
        end
        
        assert_includes html, 'id="main-breadcrumbs"'
        assert_includes html, 'data-testid="breadcrumbs"'
      end

      test "breadcrumbs handles multiple items with mixed current states" do
        html = ui.breadcrumbs do |crumb|
          crumb.link("Home", "/")
          crumb.link("Products", "/products") 
          crumb.link("Phones", "/products/phones", current: false)
          crumb.link("iPhone", nil, current: true)
        end
        
        # Non-current items should be links
        assert_includes html, 'href="/"'
        assert_includes html, 'href="/products"'
        assert_includes html, 'href="/products/phones"'
        
        # Current item should not be a link
        refute_includes html, 'href="#"'
        assert_includes html, 'aria-current="page"'
      end

      test "breadcrumbs handles special characters in text" do
        html = ui.breadcrumbs do |crumb|
          crumb.link("Home & Garden", "/home-garden")
          crumb.link("Tools > Equipment", "/tools", current: true)
        end
        
        assert_includes html, "Home &amp; Garden"
        assert_includes html, "Tools &gt; Equipment"
      end

      test "breadcrumbs loads via plugin system" do
        assert_nothing_raised do
          ui.breadcrumbs do |crumb|
            crumb.link("Test", "/")
          end
        end
      end

      test "breadcrumbs first item with icon and no link" do
        icon_html = '<svg class="h-5 w-5"><path d="M0 0"/></svg>'.html_safe
        
        html = ui.breadcrumbs do |crumb|
          crumb.link("Dashboard", nil, icon: icon_html, current: true)
          crumb.link("Settings", "/settings")
        end
        
        assert_includes html, '<svg class="h-5 w-5"'
        assert_includes html, "Dashboard"
        assert_includes html, '<span'
        refute_match /<a[^>]*>.*Dashboard/, html
      end

      test "breadcrumbs preserves additional builder options" do
        html = ui.breadcrumbs do |crumb|
          # Test that options beyond current and icon are ignored gracefully
          crumb.link("Home", "/", class: "custom-class", data: { value: "home" })
          crumb.link("Products", "/products")
        end
        
        assert_includes html, "Home"
        assert_includes html, "Products"
      end
    end
  end
end