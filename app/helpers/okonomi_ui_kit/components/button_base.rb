module OkonomiUiKit
  module Components
    class ButtonBase < OkonomiUiKit::Component
      def build_button_class(variant:, color:, classes: "")
        [
          style(:root) || "",
          style(variant.to_sym, :root) || "",
          style(variant.to_sym, :colors, color.to_sym) || "",
          classes
        ].reject(&:blank?).join(" ")
      end

      register_styles :default do
        {
          root: "hover:cursor-pointer text-sm",
          outlined: {
            root: "inline-flex border items-center justify-center px-2 py-1 rounded-md font-medium focus:outline-none",
            colors: {
              default: "bg-white text-default-700 border-default-700 hover:bg-default-50 active:bg-default-100",
              primary: "bg-white text-primary-600 border-primary-600 hover:bg-primary-50 active:bg-primary-100",
              secondary: "bg-white text-secondary-600 border-secondary-600 hover:bg-secondary-50 active:bg-secondary-100",
              success: "bg-white text-success-600 border-success-600 hover:bg-success-50 active:bg-success-100",
              danger: "bg-white text-danger-600 border-danger-600 hover:bg-danger-50 active:bg-danger-100",
              warning: "bg-white text-warning-600 border-warning-600 hover:bg-warning-50 active:bg-warning-100",
              info: "bg-white text-info-600 border-info-600 hover:bg-info-50 active:bg-info-100"
            }
          },
          contained: {
            root: "inline-flex border items-center justify-center px-2 py-1 rounded-md font-medium focus:outline-none",
            colors: {
              default: "border-default-700 bg-default-600 text-white hover:bg-default-700 active:bg-default-500",
              primary: "border-primary-700 bg-primary-600 text-white hover:bg-primary-700 active:bg-primary-500",
              secondary: "border-secondary-700 bg-secondary-600 text-white hover:bg-secondary-700 active:bg-secondary-500",
              success: "border-success-700 bg-success-600 text-white hover:bg-success-700 active:bg-success-500",
              danger: "border-danger-700 bg-danger-600 text-white hover:bg-danger-700 active:bg-danger-500",
              warning: "border-warning-700 bg-warning-600 text-white hover:bg-warning-700 active:bg-warning-500",
              info: "border-info-700 bg-info-600 text-white hover:bg-info-700 active:bg-info-500"
            }
          },
          text: {
            root: "text-base",
            colors: {
              default: "text-default-700 hover:underline",
              primary: "text-primary-600 hover:underline",
              secondary: "text-secondary-600 hover:underline",
              success: "text-success-600 hover:underline",
              danger: "text-danger-600 hover:underline",
              warning: "text-warning-600 hover:underline",
              info: "text-info-600 hover:underline"
            }
          }
        }
      end
    end
  end
end
