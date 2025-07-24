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
        },
        checkbox: {
          wrapper: "flex gap-4 items-center",
          input: {
            root: "cursor-pointer size-5 rounded-sm border-gray-300 text-primary-600 focus:ring-0 focus:ring-primary-600"
          },
          label: {
            root: "cursor-pointer font-medium text-gray-700"
          },
          hint: {
            root: "cursor-pointer text-sm text-gray-400"
          }
        },
        modal: {
          backdrop: "fixed inset-0 bg-gray-500/75 transition-opacity duration-300 ease-out opacity-0",
          container: "fixed inset-0 z-10 w-screen overflow-y-auto",
          wrapper: "flex min-h-full items-end justify-center p-4 text-center sm:items-center sm:p-0",
          panel: {
            base: "relative transform overflow-hidden rounded-lg bg-white px-4 pt-5 pb-4 text-left shadow-xl transition-all duration-300 ease-out sm:my-8 sm:w-full sm:p-6 opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95",
            sizes: {
              sm: "sm:max-w-sm",
              md: "sm:max-w-lg", 
              lg: "sm:max-w-2xl",
              xl: "sm:max-w-4xl"
            }
          },
          close_button: {
            wrapper: "absolute top-0 right-0 hidden pt-4 pr-4 sm:block",
            button: "rounded-md bg-white text-gray-400 hover:text-gray-500 focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 focus:outline-none",
            icon: {
              file: "heroicons/outline/x-mark",
              class: "size-6"
            }
          },
          icon: {
            wrapper: "mx-auto flex size-12 shrink-0 items-center justify-center rounded-full sm:mx-0 sm:size-10",
            class: "size-6",
            variants: {
              warning: {
                wrapper: "bg-red-100",
                icon: "text-red-600",
                file: "heroicons/outline/exclamation-triangle"
              },
              info: {
                wrapper: "bg-blue-100",
                icon: "text-blue-600", 
                file: "heroicons/outline/information-circle"
              },
              success: {
                wrapper: "bg-green-100",
                icon: "text-green-600",
                file: "heroicons/outline/check-circle"
              }
            }
          },
          content: {
            wrapper: "sm:flex sm:items-start",
            text_wrapper: "mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left",
            title: "text-base font-semibold text-gray-900",
            message: "mt-2 text-sm text-gray-500"
          },
          actions: {
            wrapper: "mt-5 sm:mt-4 sm:flex sm:flex-row-reverse"
          }
        }
      }
    }

    DEFAULT_THEME = LIGHT_THEME
  end
end