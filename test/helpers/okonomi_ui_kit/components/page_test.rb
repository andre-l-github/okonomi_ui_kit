require "test_helper"

module OkonomiUiKit
  module Components
    class PageTest < ActionView::TestCase
      include OkonomiUiKit::UiHelper

      test "page renders with basic structure" do
        html = ui.page do |page|
          "Basic content"
        end

        assert_includes html, '<div class="flex flex-col gap-8 p-8'
        assert_includes html, "Basic content"
        assert_includes html, "</div>"
      end

      test "page accepts custom classes" do
        html = ui.page(class: "custom-page-class") do |page|
          "Content"
        end

        assert_includes html, "custom-page-class"
      end

      test "page with header section" do
        html = ui.page do |page|
          page.page_header do |header|
            header.row do |row|
              row.title "Page Title"
            end
          end
        end

        assert_includes html, "<h1"
        assert_includes html, "Page Title"
        assert_includes html, "text-3xl font-bold"
      end

      test "page header with breadcrumbs" do
        html = ui.page do |page|
          page.page_header do |header|
            header.breadcrumbs do |crumb|
              crumb.link("Home", "/")
              crumb.link("Users", "/users")
            end
          end
        end

        assert_includes html, 'aria-label="Breadcrumb"'
        assert_includes html, "Home"
        assert_includes html, "Users"
      end

      test "page header with actions" do
        html = ui.page do |page|
          page.page_header do |header|
            header.row do |row|
              row.title "Page Title"
              row.actions do
                "<button>Action</button>".html_safe
              end
            end
          end
        end

        assert_includes html, "Page Title"
        assert_includes html, "<button>Action</button>"
        assert_includes html, "mt-4 flex md:ml-4 md:mt-0"
      end

      test "page with section" do
        html = ui.page do |page|
          page.section do |section|
            section.title "Section Title"
            section.subtitle "Section subtitle"
          end
        end

        assert_includes html, "<h3"
        assert_includes html, "Section Title"
        assert_includes html, "Section subtitle"
        assert_includes html, "text-base/7 font-semibold"
      end

      test "section with body and attributes" do
        html = ui.page do |page|
          page.section do |section|
            section.title "Details"
            section.body do |body|
              section.attribute("Name", "John Doe")
              section.attribute("Email", "john@example.com")
            end
          end
        end

        assert_includes html, "Name"
        assert_includes html, "John Doe"
        assert_includes html, "Email"
        assert_includes html, "john@example.com"
        assert_includes html, "divide-y divide-gray-100"
      end

      test "section attribute with block content" do
        html = ui.page do |page|
          page.section do |section|
            section.body do |body|
              section.attribute("Custom") do
                "<span class='custom'>Block content</span>".html_safe
              end
            end
          end
        end

        assert_includes html, "Custom"
        assert_includes html, "<span class='custom'>Block content</span>"
      end

      test "section attribute with callable value" do
        callable_value = -> { "Dynamic value" }

        html = ui.page do |page|
          page.section do |section|
            section.body do |body|
              section.attribute("Dynamic", callable_value)
            end
          end
        end

        assert_includes html, "Dynamic"
        assert_includes html, "Dynamic value"
      end

      test "section with actions" do
        html = ui.page do |page|
          page.section do |section|
            section.title "Section"
            section.actions do
              "<button>Edit</button>".html_safe
            end
          end
        end

        assert_includes html, "Section"
        assert_includes html, "<button>Edit</button>"
        assert_includes html, "flex w-full justify-between"
      end

      test "page with multiple sections" do
        html = ui.page do |page|
          page.section do |section|
            section.title "Section 1"
          end

          page.section do |section|
            section.title "Section 2"
          end
        end

        assert_includes html, "Section 1"
        assert_includes html, "Section 2"
      end

      test "page component loads via plugin system" do
        assert_nothing_raised do
          ui.page { "Test" }
        end
      end

      test "complex page structure" do
        html = ui.page do |page|
          page.page_header do |header|
            header.row do |row|
              row.title "User Profile"
              row.actions do
                "<button>Edit Profile</button>".html_safe
              end
            end
          end

          page.section do |section|
            section.title "Personal Information"
            section.subtitle "Basic details about the user"
            section.actions do
              "<a href='#'>Update</a>".html_safe
            end
            section.body do |body|
              section.attribute("Name", "Jane Smith")
              section.attribute("Email", "jane@example.com")
            end
          end
        end

        assert_includes html, "User Profile"
        assert_includes html, "Edit Profile"
        assert_includes html, "Personal Information"
        assert_includes html, "Basic details about the user"
        assert_includes html, "Update"
        assert_includes html, "Jane Smith"
      end

      test "page component uses registered styles" do
        html = ui.page do |page|
          "Test content"
        end

        # Should contain the root style from register_styles
        assert_includes html, "flex flex-col gap-8 p-8"
      end

      test "page header component uses registered styles" do
        html = ui.page do |page|
          page.page_header do |header|
            header.row do |row|
              row.title "Title"
            end
          end
        end

        # Should contain styles from PageHeader component
        assert_includes html, "flex flex-col gap-2"
        assert_includes html, "flex w-full justify-between items-center"
      end

      test "page section component uses registered styles" do
        html = ui.page do |page|
          page.section do |section|
            section.title "Section Title"
          end
        end

        # Should contain styles from PageSection component
        assert_includes html, "overflow-hidden bg-white"
        assert_includes html, "text-base/7 font-semibold text-gray-900"
      end
    end
  end
end
