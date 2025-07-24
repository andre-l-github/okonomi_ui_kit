module OkonomiUiKit
  module BadgeHelper
  def badge(text, severity = :default, **options)
    color_classes = case severity.to_sym
    when :success
      "bg-green-100 text-green-800"
    when :danger
      "bg-red-100 text-red-800"
    when :info
      "bg-blue-100 text-blue-800"
    when :warning
      "bg-yellow-100 text-yellow-800"
    else
      "bg-gray-100 text-gray-800"
    end

    base_classes = "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium"
    full_classes = "#{base_classes} #{color_classes} #{options[:class] || ''}".strip

    tag.span(text, class: full_classes, **options.except(:class))
  end
  end
end