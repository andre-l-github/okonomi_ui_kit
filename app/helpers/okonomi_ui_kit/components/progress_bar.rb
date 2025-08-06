module OkonomiUiKit
  module Components
    class ProgressBar < OkonomiUiKit::Component
      def render(value, options = {})
        options = options.with_indifferent_access

        # Extract options
        color = (options.delete(:color) || :primary).to_sym
        size = (options.delete(:size) || :md).to_sym
        text = options.delete(:text)

        # Ensure value is between 0 and 1
        value = [ [ value.to_f, 0.0 ].max, 1.0 ].min
        percentage = (value * 100).round

        # Build classes
        container_classes = tw_merge(
          style(:container, :root),
          style(:container, :sizes, size),
          options.delete(:class)
        )

        bar_classes = tw_merge(
          style(:bar, :root),
          style(:bar, :colors, color),
          style(:bar, :sizes, size),
          percentage < 100 ? "animate-pulse" : nil
        )

        text_classes = tw_merge(
          style(:text, :root),
          style(:text, :sizes, size)
        )

        view.render(
          template_path,
          value: value,
          percentage: percentage,
          text: text,
          container_classes: container_classes,
          bar_classes: bar_classes,
          text_classes: text_classes,
          options: options
        )
      end

      register_styles :default do
        {
          container: {
            root: "w-full bg-gray-200 rounded-sm overflow-hidden relative",
            sizes: {
              sm: "h-2",
              md: "h-4",
              lg: "h-6"
            }
          },
          bar: {
            root: "h-full transition-all duration-300 ease-out",
            colors: {
              primary: "bg-primary-600",
              secondary: "bg-secondary-600",
              success: "bg-success-600",
              danger: "bg-danger-600",
              warning: "bg-warning-600",
              info: "bg-info-600",
              default: "bg-gray-600"
            },
            sizes: {
              sm: "h-2",
              md: "h-4",
              lg: "h-6"
            }
          },
          text: {
            root: "absolute inset-0 flex items-center justify-center font-medium text-white mix-blend-difference",
            sizes: {
              sm: "text-xs",
              md: "text-sm",
              lg: "text-base"
            }
          }
        }
      end
    end
  end
end
