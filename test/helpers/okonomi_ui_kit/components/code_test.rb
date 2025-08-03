require "test_helper"

module OkonomiUiKit
  module Components
    class CodeTest < ActionView::TestCase
      include OkonomiUiKit::UiHelper

      test "code renders with default styling" do
        html = ui.code("puts 'Hello, World!'")

        assert_includes html, "<pre"
        assert_includes html, "<code>"
        assert_includes html, "puts &#39;Hello, World!&#39;"
        assert_includes html, "</code></pre>"
        assert_includes html, "bg-gray-900 text-gray-100"
      end

      test "code escapes HTML entities" do
        html = ui.code("<script>alert('xss')</script>")

        assert_includes html, "&lt;script&gt;alert(&#39;xss&#39;)&lt;/script&gt;"
        refute_includes html, "<script>"
      end

      test "code renders with block content" do
        html = ui.code do
          "def hello\n  puts 'world'\nend"
        end

        assert_includes html, "def hello"
        assert_includes html, "puts"
        assert_includes html, "world"
        assert_includes html, "end"
      end

      test "code renders with language attribute" do
        html = ui.code("console.log('test')", language: "javascript")

        assert_includes html, 'data-language="javascript"'
      end

      test "code renders with inline variant" do
        html = ui.code("var x = 1", variant: :inline)

        assert_includes html, "bg-gray-100 text-gray-900"
        assert_includes html, "px-1 py-0.5"
      end

      test "code renders with minimal variant" do
        html = ui.code("SELECT * FROM users", variant: :minimal)

        assert_includes html, "p-3"
        assert_includes html, "text-xs"
      end

      test "code renders with different sizes" do
        %i[xs sm lg].each do |size|
          html = ui.code("code", size: size)

          expected_class = case size
          when :xs then "text-xs"
          when :sm then "text-sm"
          when :lg then "text-base"
          end

          assert_includes html, expected_class
        end
      end

      test "code disables wrapping when specified" do
        html = ui.code("very long line of code", wrap: false)

        assert_includes html, "overflow-hidden"
        refute_includes html, "overflow-x-auto"
      end

      test "code merges custom classes" do
        html = ui.code("code", class: "custom-code-class")

        assert_includes html, "custom-code-class"
        assert_includes html, "bg-gray-900"
      end

      test "code accepts HTML options" do
        html = ui.code("code", id: "my-code", data: { clipboard: true })

        assert_includes html, 'id="my-code"'
        assert_includes html, 'data-clipboard="true"'
      end

      test "code handles empty content" do
        html = ui.code("")

        assert_includes html, "<pre"
        assert_includes html, "<code></code>"
      end

      test "code handles nil content" do
        html = ui.code(nil)

        assert_includes html, "<pre"
        assert_includes html, "<code></code>"
      end

      test "code component loads via plugin system" do
        assert_nothing_raised do
          ui.code("test")
        end
      end

      test "code with multiline content preserves formatting" do
        code_content = <<~CODE
          class User
            def initialize(name)
              @name = name
            end
          end
        CODE

        html = ui.code(code_content)

        assert_includes html, "class User"
        assert_includes html, "def initialize(name)"
        assert_includes html, "@name = name"
      end

      test "code uses default styling" do
        html = ui.code("themed code")

        assert_includes html, "bg-gray-900"
        assert_includes html, "text-gray-100"
        assert_includes html, "p-4"
        assert_includes html, "rounded-lg"
      end
    end
  end
end
