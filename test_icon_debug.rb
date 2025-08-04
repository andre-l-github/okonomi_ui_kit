require 'action_view'
include ActionView::Helpers
include OkonomiUiKit::UiHelper

# Simulate what happens in button_tag
options = { icon: "heroicons/outline/trash", variant: :contained, color: :danger }
options = options.with_indifferent_access

variant = (options.delete(:variant) || "contained").to_sym
color = (options.delete(:color) || "default").to_sym

# Simulate extract_icon_config
icon_option = options.delete(:icon)
icon_config = { path: icon_option, position: :start }

puts "Options after extraction: #{options.inspect}"
puts "Icon config: #{icon_config.inspect}"

# Now let's see what Rails button_tag does
puts "\nRails button_tag with empty options:"
puts button_tag(options) { "Test" }

puts "\nRails button_tag with no remaining options:"
puts button_tag { "Test" }