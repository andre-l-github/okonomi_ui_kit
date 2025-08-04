require 'action_view'
include ActionView::Helpers
include OkonomiUiKit::UiHelper

# Test icon-only button
html = ui.button_tag icon: "heroicons/outline/trash", variant: :contained, color: :danger
puts "Icon-only button HTML:"
puts html
puts "\n"

# Test button with text and icon
html2 = ui.button_tag "Delete", icon: "heroicons/outline/trash", variant: :contained, color: :danger
puts "Button with text and icon HTML:"
puts html2