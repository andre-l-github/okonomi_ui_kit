module OkonomiUiKit
  module Components
    module Forms
      class UploadField < OkonomiUiKit::FormComponent
        def render(form, method, options = {})
          view.render(template_path, component: self, form: form, method: method, options: options)
        end

        register_styles :default do
          {
            dropzone: "border-2 border-dashed border-gray-300 rounded-md p-6 text-center cursor-pointer hover:bg-gray-50 relative",
            label: "block cursor-pointer",
            content: "flex flex-col items-center text-gray-600 space-y-2",
            preview: "w-full flex justify-center items-center",
            preview_image: "max-h-32",
            icon: "size-12 text-gray-400",
            filename: "text-sm text-gray-500",
            file_input: "hidden",
            clear_button: "absolute top-2 right-2 bg-red-100 text-red-700 px-2 py-1 text-xs rounded hover:bg-red-200"
          }
        end
      end
    end
  end
end
