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
        },
        input: {
          types: {
            text: {
              root: "w-full border-0 px-3 py-2 rounded-md ring-1 focus:outline-none focus-within:ring-1",
              error: "bg-danger-100 text-danger-400 ring-danger-400 focus:ring-danger-600",
              valid: "text-default-700 ring-gray-300 focus-within:ring-gray-400",
              disabled: "disabled:bg-gray-50 disabled:cursor-not-allowed"
            }
          }
        },
        select: {
          root: "col-start-1 row-start-1 w-full appearance-none rounded-md py-2 pr-8 pl-3 text-base outline-1 focus:outline-none sm:text-sm/6",
          error: "bg-danger-100 text-danger-400 ring-1 ring-danger-400",
          valid: "bg-white outline-default-300 text-default-700",
          wrapper: "grid grid-cols-1",
          icon: {
            file: 'heroicons/solid/chevron-down',
            class: "pointer-events-none col-start-1 row-start-1 mr-2 size-5 self-center justify-self-end text-gray-500 sm:size-4"
          }
        },
        label: {
          root: "block text-sm/6 font-medium text-default-700"
        }
      }
    }

    DEFAULT_THEME = LIGHT_THEME
  end
end