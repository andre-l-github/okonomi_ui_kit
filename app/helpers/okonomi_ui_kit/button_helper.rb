module OkonomiUiKit
  module ButtonHelper
    def okonomi_button(text, url = nil, variant: :primary, size: :medium, **options)
      base_classes = "inline-flex items-center justify-center font-medium rounded-md focus:outline-none focus:ring-2 focus:ring-offset-2 transition-colors"
      
      variant_classes = case variant
      when :primary
        "bg-blue-600 text-white hover:bg-blue-700 focus:ring-blue-500"
      when :secondary
        "bg-gray-200 text-gray-900 hover:bg-gray-300 focus:ring-gray-500"
      when :danger
        "bg-red-600 text-white hover:bg-red-700 focus:ring-red-500"
      when :ghost
        "bg-transparent text-gray-700 hover:bg-gray-100 focus:ring-gray-500"
      else
        "bg-blue-600 text-white hover:bg-blue-700 focus:ring-blue-500"
      end
      
      size_classes = case size
      when :small
        "px-3 py-1.5 text-sm"
      when :medium
        "px-4 py-2 text-sm"
      when :large
        "px-6 py-3 text-base"
      else
        "px-4 py-2 text-sm"
      end
      
      options[:class] = [base_classes, variant_classes, size_classes, options[:class]].compact.join(" ")
      
      if url
        link_to text, url, options
      else
        content_tag :button, text, options
      end
    end
  end
end