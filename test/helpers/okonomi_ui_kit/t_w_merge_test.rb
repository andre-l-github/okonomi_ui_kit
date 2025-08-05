require "test_helper"

module OkonomiUiKit
  class TWMergeTest < ActiveSupport::TestCase
    # Basic merging tests
    test "merge_all handles nil and empty values" do
      assert_equal "", TWMerge.merge_all(nil, "", nil)
      assert_equal "foo", TWMerge.merge_all("foo", nil, "")
      assert_equal "foo bar", TWMerge.merge_all("foo", "bar")
    end

    test "merge preserves non-conflicting classes" do
      assert_equal "text-lg font-bold", TWMerge.merge("text-lg", "font-bold")
      assert_equal "p-4 m-2", TWMerge.merge("p-4", "m-2")
    end

    test "merge handles duplicate classes" do
      assert_equal "text-lg", TWMerge.merge("text-lg", "text-lg")
      assert_equal "p-4", TWMerge.merge("p-4", "p-4")
    end

    # Padding tests
    test "padding classes override correctly" do
      # Overall padding should override previous overall padding
      assert_equal "p-8", TWMerge.merge("p-4", "p-8")
      assert_equal "p-2", TWMerge.merge("p-8", "p-2")

      # Different padding types should not conflict
      assert_equal "p-4 px-8", TWMerge.merge("p-4", "px-8")
      assert_equal "p-4 py-8", TWMerge.merge("p-4", "py-8")
      assert_equal "px-4 py-8", TWMerge.merge("px-4", "py-8")

      # Same axis padding should override
      assert_equal "px-8", TWMerge.merge("px-4", "px-8")
      assert_equal "py-2", TWMerge.merge("py-8", "py-2")

      # Individual side padding should not conflict with axis padding
      assert_equal "px-4 pl-8", TWMerge.merge("px-4", "pl-8")
      assert_equal "py-4 pt-8", TWMerge.merge("py-4", "pt-8")

      # Same side padding should override
      assert_equal "pl-8", TWMerge.merge("pl-4", "pl-8")
      assert_equal "pr-2", TWMerge.merge("pr-8", "pr-2")
      assert_equal "pt-6", TWMerge.merge("pt-4", "pt-6")
      assert_equal "pb-1", TWMerge.merge("pb-8", "pb-1")
    end

    # Margin tests
    test "margin classes override correctly" do
      # Overall margin should override previous overall margin
      assert_equal "m-8", TWMerge.merge("m-4", "m-8")
      assert_equal "m-2", TWMerge.merge("m-8", "m-2")

      # Different margin types should not conflict
      assert_equal "m-4 mx-8", TWMerge.merge("m-4", "mx-8")
      assert_equal "m-4 my-8", TWMerge.merge("m-4", "my-8")
      assert_equal "mx-4 my-8", TWMerge.merge("mx-4", "my-8")

      # Same axis margin should override
      assert_equal "mx-8", TWMerge.merge("mx-4", "mx-8")
      assert_equal "my-2", TWMerge.merge("my-8", "my-2")

      # Individual side margin should not conflict with axis margin
      assert_equal "mx-4 ml-8", TWMerge.merge("mx-4", "ml-8")
      assert_equal "my-4 mt-8", TWMerge.merge("my-4", "mt-8")

      # Same side margin should override
      assert_equal "ml-8", TWMerge.merge("ml-4", "ml-8")
      assert_equal "mr-2", TWMerge.merge("mr-8", "mr-2")
      assert_equal "mt-6", TWMerge.merge("mt-4", "mt-6")
      assert_equal "mb-1", TWMerge.merge("mb-8", "mb-1")

      # Negative margins
      assert_equal "-m-8", TWMerge.merge("-m-4", "-m-8")
      assert_equal "-mx-2", TWMerge.merge("-mx-8", "-mx-2")
      assert_equal "-ml-4", TWMerge.merge("-ml-8", "-ml-4")
    end

    # Gap tests
    test "gap classes override correctly" do
      # Overall gap should override
      assert_equal "gap-8", TWMerge.merge("gap-4", "gap-8")
      assert_equal "gap-2", TWMerge.merge("gap-8", "gap-2")

      # Different gap types should not conflict
      assert_equal "gap-4 gap-x-8", TWMerge.merge("gap-4", "gap-x-8")
      assert_equal "gap-4 gap-y-8", TWMerge.merge("gap-4", "gap-y-8")
      assert_equal "gap-x-4 gap-y-8", TWMerge.merge("gap-x-4", "gap-y-8")

      # Same axis gap should override
      assert_equal "gap-x-8", TWMerge.merge("gap-x-4", "gap-x-8")
      assert_equal "gap-y-2", TWMerge.merge("gap-y-8", "gap-y-2")
    end

    # Space tests
    test "space classes override correctly" do
      # Horizontal spacing
      assert_equal "space-x-8", TWMerge.merge("space-x-4", "space-x-8")
      assert_equal "space-x-2", TWMerge.merge("space-x-8", "space-x-2")

      # Vertical spacing
      assert_equal "space-y-8", TWMerge.merge("space-y-4", "space-y-8")
      assert_equal "space-y-2", TWMerge.merge("space-y-8", "space-y-2")

      # Different axes should not conflict
      assert_equal "space-x-4 space-y-8", TWMerge.merge("space-x-4", "space-y-8")

      # Negative spacing
      assert_equal "-space-x-8", TWMerge.merge("-space-x-4", "-space-x-8")
      assert_equal "-space-y-2", TWMerge.merge("-space-y-8", "-space-y-2")
    end

    # Ring tests
    test "ring classes override correctly" do
      # Ring width
      assert_equal "ring-8", TWMerge.merge("ring-4", "ring-8")
      assert_equal "ring-2", TWMerge.merge("ring-8", "ring-2")
      assert_equal "ring", TWMerge.merge("ring-4", "ring")

      # Ring color
      assert_equal "ring-blue-500", TWMerge.merge("ring-red-500", "ring-blue-500")
      assert_equal "ring-green-600", TWMerge.merge("ring-blue-500", "ring-green-600")

      # Ring opacity
      assert_equal "ring-opacity-75", TWMerge.merge("ring-opacity-50", "ring-opacity-75")
      assert_equal "ring-opacity-25", TWMerge.merge("ring-opacity-100", "ring-opacity-25")

      # Ring offset width
      assert_equal "ring-offset-4", TWMerge.merge("ring-offset-2", "ring-offset-4")
      assert_equal "ring-offset-1", TWMerge.merge("ring-offset-8", "ring-offset-1")

      # Ring offset color
      assert_equal "ring-offset-blue-500", TWMerge.merge("ring-offset-red-500", "ring-offset-blue-500")

      # Different ring properties should not conflict
      assert_equal "ring-4 ring-blue-500", TWMerge.merge("ring-4", "ring-blue-500")
      assert_equal "ring-4 ring-opacity-50", TWMerge.merge("ring-4", "ring-opacity-50")
      assert_equal "ring-4 ring-offset-2", TWMerge.merge("ring-4", "ring-offset-2")
      assert_equal "ring-blue-500 ring-opacity-50", TWMerge.merge("ring-blue-500", "ring-opacity-50")
    end

    # Variant tests
    test "variants work with spacing classes" do
      # Hover variants
      assert_equal "hover:p-8", TWMerge.merge("hover:p-4", "hover:p-8")
      assert_equal "hover:m-2", TWMerge.merge("hover:m-8", "hover:m-2")

      # Different variants should not conflict
      assert_equal "hover:p-4 focus:p-8", TWMerge.merge("hover:p-4", "focus:p-8")

      # Same variant should override
      assert_equal "hover:px-8", TWMerge.merge("hover:px-4", "hover:px-8")
      assert_equal "sm:gap-4", TWMerge.merge("sm:gap-8", "sm:gap-4")
    end

    # Complex merge_all tests
    test "merge_all works with multiple arguments" do
      result = TWMerge.merge_all("p-4", "px-8", "pl-2")
      assert_equal "p-4 px-8 pl-2", result

      result = TWMerge.merge_all("text-lg", "text-xl", "text-2xl")
      assert_equal "text-2xl", result

      result = TWMerge.merge_all("m-4 p-4", "mx-8 px-8", "ml-2 pl-2")
      assert_equal "m-4 p-4 mx-8 px-8 ml-2 pl-2", result
    end

    # Edge cases
    test "handles arbitrary values" do
      assert_equal "p-[20px]", TWMerge.merge("p-4", "p-[20px]")
      assert_equal "m-[1.5rem]", TWMerge.merge("m-8", "m-[1.5rem]")
      assert_equal "gap-[30px]", TWMerge.merge("gap-4", "gap-[30px]")
    end

    test "preserves non-tailwind classes" do
      assert_equal "custom-class p-4", TWMerge.merge("custom-class", "p-4")
      assert_equal "p-4 my-special-class", TWMerge.merge("p-4", "my-special-class")
    end
  end
end
