# Alert Component Guide

The Alert component provides a way to display important messages, notifications, or warnings to users with contextual styling.

## Basic Usage

#### Simple Alert
```erb
<%= ui.alert "This is an important message!" %>
```

#### Alert with Variant
```erb
<%= ui.alert "Operation successful!", variant: :success %>
```

#### Alert with Block Content
```erb
<%= ui.alert "Warning" do %>
  <p>This action cannot be undone. Please proceed with caution.</p>
<% end %>
```

## Customization Options

| Option | Type/Values | Purpose |
|--------|-------------|---------|
| variant | :info, :success, :warning, :error | Controls the visual style and color scheme |
| dismissible | Boolean | Adds a dismiss button (requires Stimulus controller) |
| icon | Boolean | Shows an icon appropriate to the variant |

## Advanced Features

#### Alert with Custom Actions
```erb
<%= ui.alert "New Update Available", variant: :info do %>
  <p>Version 2.0 is now available with new features.</p>
  <div class="mt-2">
    <%= ui.button_tag "Update Now", size: :sm %>
    <%= ui.link_to "Learn More", "#", variant: :text, size: :sm %>
  </div>
<% end %>
```

#### Dismissible Alert
```erb
<%= ui.alert "This message can be dismissed", variant: :warning, dismissible: true %>
```

## Styling

#### Default Styles

The alert component includes these default Tailwind classes:
- Base: `rounded-lg p-4 mb-4`
- Info variant: `bg-blue-50 text-blue-800 border border-blue-200`
- Success variant: `bg-green-50 text-green-800 border border-green-200`
- Warning variant: `bg-yellow-50 text-yellow-800 border border-yellow-200`
- Error variant: `bg-red-50 text-red-800 border border-red-200`

#### Customizing Styles

You can customize the appearance by creating a config class:

```ruby
# app/helpers/okonomi_ui_kit/configs/alert.rb
module OkonomiUiKit
  module Configs
    class Alert < OkonomiUiKit::Config
      register_styles :default do
        {
          base: "rounded-xl shadow-lg p-6",
          variants: {
            info: "bg-indigo-100 text-indigo-900",
            success: "bg-emerald-100 text-emerald-900"
          }
        }
      end
    end
  end
end
```

## Best Practices

1. **Choose Appropriate Variants**: Use the correct variant to convey the right level of importance (info for general messages, warning for caution, error for problems)
2. **Keep Messages Concise**: Alert messages should be brief and actionable
3. **Dismissible Alerts**: Only make alerts dismissible if the information is not critical
4. **Avoid Overuse**: Too many alerts can overwhelm users and reduce their effectiveness

## Accessibility

The alert component is built with accessibility in mind:
- Uses semantic HTML with appropriate ARIA roles
- Includes `role="alert"` for important messages
- Supports screen reader announcements
- Dismissible alerts include accessible close buttons with proper labels

## Examples

#### Form Validation Alert
```erb
<% if @model.errors.any? %>
  <%= ui.alert "Please correct the errors below", variant: :error do %>
    <ul class="list-disc list-inside mt-2">
      <% @model.errors.full_messages.each do |message| %>
        <li><%= message %></li>
      <% end %>
    </ul>
  <% end %>
<% end %>
```

#### Flash Message Alert
```erb
<% flash.each do |type, message| %>
  <% variant = case type
               when "notice" then :success
               when "alert" then :warning
               when "error" then :error
               else :info
               end %>
  <%= ui.alert message, variant: variant, dismissible: true %>
<% end %>
```

#### System Status Alert
```erb
<%= ui.alert "System Maintenance", variant: :warning do %>
  <p>Scheduled maintenance will occur on Saturday, 2:00 AM - 4:00 AM EST.</p>
  <p class="mt-2 text-sm">Some features may be temporarily unavailable.</p>
<% end %>
```