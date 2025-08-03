module OkonomiUiKit
  module Components
    class Typography < OkonomiUiKit::Component
      TYPOGRAPHY_COMPONENTS = {
        body1: "p",
        body2: "p",
        h1: "h1",
        h2: "h2",
        h3: "h3",
        h4: "h4",
        h5: "h5",
        h6: "h6"
      }.freeze

      def render(text = nil, options = {}, &block)
        options, text = text, nil if block_given?
        options ||= {}
        options = options.with_indifferent_access

        variant = (options.delete(:variant) || "body1").to_sym
        component = (TYPOGRAPHY_COMPONENTS[variant] || "span").to_s
        color = (options.delete(:color) || "default").to_sym

        classes = [
          style(:variants, variant) || "",
          style(:colors, color) || "",
          options.delete(:class) || ""
        ].reject(&:blank?).join(" ")

        view.render(
          template_path,
          text: text,
          options: options,
          variant: variant,
          component: component,
          classes: classes,
          &block
        )
      end

      register_styles :default do
        {
          variants: {
            body1: "text-base font-normal",
            body2: "text-sm font-normal",
            h1: "text-3xl font-bold",
            h2: "text-2xl font-bold",
            h3: "text-xl font-semibold",
            h4: "text-lg font-semibold",
            h5: "text-base font-semibold",
            h6: "text-sm font-semibold"
          },
          colors: {
            default: "text-default-700",
            dark: "text-default-900",
            muted: "text-default-500",
            primary: "text-primary-600",
            secondary: "text-secondary-600",
            success: "text-success-600",
            danger: "text-danger-600",
            warning: "text-warning-600",
            info: "text-info-600"
          }
        }
      end
    end
  end
end
