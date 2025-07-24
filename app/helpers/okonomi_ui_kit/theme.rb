module OkonomiUiKit
  module Theme
    LIGHT_THEME = {
      components: {
        typography: {
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
        },
        link: {
          root: "hover:cursor-pointer",
          outlined: {
            root: "inline-flex border items-center justify-center px-4 py-2 font-medium focus:outline-none focus:ring-2 focus:ring-offset-2",
            colors: {
              default: "bg-white text-default-700 border-default-700 hover:bg-default-50",
              primary: "bg-white text-primary-600 border-primary-600 hover:bg-primary-50",
              secondary: "bg-white text-secondary-600 border-secondary-600 hover:bg-secondary-50",
              success: "bg-white text-success-600 border-success-600 hover:bg-success-50",
              danger: "bg-white text-danger-600 border-danger-600 hover:bg-danger-50",
              warning: "bg-white text-warning-600 border-warning-600 hover:bg-warning-50",
              info: "bg-white text-info-600 border-info-600 hover:bg-info-50"
            }
          },
          contained: {
            root: "inline-flex border items-center justify-center px-4 py-2 font-medium focus:outline-none focus:ring-2 focus:ring-offset-2",
            colors: {
              default: "border-default-700 bg-default-600 text-white hover:bg-default-700",
              primary: "border-primary-700 bg-primary-600 text-white hover:bg-primary-700",
              secondary: "border-secondary-700 bg-secondary-600 text-white hover:bg-secondary-700",
              success: "border-success-700 bg-success-600 text-white hover:bg-success-700",
              danger: "border-danger-700 bg-danger-600 text-white hover:bg-danger-700",
              warning: "border-warning-700 bg-warning-600 text-white hover:bg-warning-700",
              info: "border-info-700 bg-info-600 text-white hover:bg-info-700"
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
      }
    }

    DEFAULT_THEME = LIGHT_THEME
  end
end