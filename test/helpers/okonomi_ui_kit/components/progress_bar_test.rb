require "test_helper"

module OkonomiUiKit
  module Components
    class ProgressBarTest < ActionView::TestCase
      include OkonomiUiKit::UiHelper

      test "progress bar renders with default options" do
        html = ui.progress_bar(0.5)

        assert_includes html, 'role="progressbar"'
        assert_includes html, 'aria-valuenow="50"'
        assert_includes html, 'aria-valuemin="0"'
        assert_includes html, 'aria-valuemax="100"'
        assert_includes html, 'style="width: 50%"'
        assert_includes html, "bg-primary-600"
      end

      test "progress bar renders all color variations" do
        %i[primary secondary success danger warning info].each do |color|
          html = ui.progress_bar(0.5, color: color)

          assert_includes html, "bg-#{color}-600"
        end

        # Default color uses gray
        html = ui.progress_bar(0.5, color: :default)
        assert_includes html, "bg-gray-600"
      end

      test "progress bar renders all size variations" do
        html_sm = ui.progress_bar(0.5, size: :sm)
        assert_includes html_sm, "h-2"

        html_md = ui.progress_bar(0.5, size: :md)
        assert_includes html_md, "h-4"

        html_lg = ui.progress_bar(0.5, size: :lg)
        assert_includes html_lg, "h-6"
      end

      test "progress bar renders with text" do
        html = ui.progress_bar(0.75, text: "75% Complete")

        assert_includes html, "75% Complete"
        assert_includes html, "absolute inset-0 flex items-center justify-center"
      end

      test "progress bar clamps values between 0 and 1" do
        # Test value below 0
        html_negative = ui.progress_bar(-0.5)
        assert_includes html_negative, 'aria-valuenow="0"'
        assert_includes html_negative, 'style="width: 0%"'

        # Test value above 1
        html_over = ui.progress_bar(1.5)
        assert_includes html_over, 'aria-valuenow="100"'
        assert_includes html_over, 'style="width: 100%"'
      end

      test "progress bar handles edge cases" do
        # Test 0
        html_zero = ui.progress_bar(0)
        assert_includes html_zero, 'aria-valuenow="0"'
        assert_includes html_zero, 'style="width: 0%"'

        # Test 1
        html_full = ui.progress_bar(1)
        assert_includes html_full, 'aria-valuenow="100"'
        assert_includes html_full, 'style="width: 100%"'
      end

      test "progress bar accepts html options" do
        html = ui.progress_bar(0.5, id: "upload-progress", data: { target: "progress.bar" })

        assert_includes html, 'id="upload-progress"'
        assert_includes html, 'data-target="progress.bar"'
      end

      test "progress bar merges custom classes" do
        html = ui.progress_bar(0.5, class: "custom-progress-class")

        assert_includes html, "custom-progress-class"
        assert_includes html, "w-full bg-gray-200 rounded-sm"
      end

      test "progress bar component loads via plugin system" do
        assert_nothing_raised do
          ui.progress_bar(0.5)
        end
      end

      test "progress bar handles decimal percentages correctly" do
        html = ui.progress_bar(0.333)
        assert_includes html, 'aria-valuenow="33"'
        assert_includes html, 'style="width: 33%"'

        html = ui.progress_bar(0.999)
        assert_includes html, 'aria-valuenow="100"'
        assert_includes html, 'style="width: 100%"'
      end

      test "progress bar with all options combined" do
        html = ui.progress_bar(0.66,
          color: :success,
          size: :lg,
          text: "Processing...",
          class: "my-progress",
          id: "process-progress"
        )

        assert_includes html, "bg-success-600"
        assert_includes html, "h-6"
        assert_includes html, "Processing..."
        assert_includes html, "my-progress"
        assert_includes html, 'id="process-progress"'
        assert_includes html, 'aria-valuenow="66"'
      end

      test "progress bar pulses when not at 100%" do
        # Progress less than 100% should pulse
        html = ui.progress_bar(0.5)
        assert_includes html, "animate-pulse"

        html = ui.progress_bar(0.99)
        assert_includes html, "animate-pulse"

        # Progress at 100% should not pulse
        html = ui.progress_bar(1.0)
        refute_includes html, "animate-pulse"
      end
    end
  end
end
