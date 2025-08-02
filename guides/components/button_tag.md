# Button Tag Component Guide

The Button Tag component provides a flexible way to create interactive buttons using Rails' `button_tag` helper with consistent styling and behavior.

## Basic Usage

#### Simple Button
```erb
<%= ui.button_tag "Click Me" %>
```

#### Button with Variant
```erb
<%= ui.button_tag "Primary Action", variant: :contained, color: :primary %>
<%= ui.button_tag "Secondary Action", variant: :outlined, color: :secondary %>
<%= ui.button_tag "Text Button", variant: :text, color: :info %>
```

#### Button with Block Content
```erb
<%= ui.button_tag do %>
  <%= ui.icon "download", size: :sm, class: "mr-2" %>
  Download Report
<% end %>
```

## Customization Options

| Option | Type/Values | Purpose |
|--------|-------------|---------|
| variant | :contained, :outlined, :text | Controls the button style |
| color | :default, :primary, :secondary, :success, :danger, :warning, :info | Sets the color scheme |
| type | :button, :submit, :reset | HTML button type attribute |
| disabled | Boolean | Disables the button |
| class | String | Additional CSS classes |
| id | String | HTML id attribute |
| data | Hash | Data attributes for JavaScript |

## Advanced Features

#### Button with JavaScript Actions
```erb
<%= ui.button_tag "Show More", 
    data: { 
      action: "click->dropdown#toggle",
      dropdown_target: "button"
    } %>
```

#### Submit Button in Forms
```erb
<%= form_with model: @user do |form| %>
  <!-- form fields -->
  <div class="flex gap-2 mt-4">
    <%= ui.button_tag "Save", type: :submit, variant: :contained, color: :primary %>
    <%= ui.button_tag "Cancel", type: :button, variant: :outlined, color: :default %>
  </div>
<% end %>
```

#### Loading State Button
```erb
<%= ui.button_tag variant: :contained, color: :primary, data: { disable_with: "Processing..." } do %>
  <%= ui.icon "save", size: :sm, class: "mr-2" %>
  Save Changes
<% end %>
```

## Styling

#### Default Styles

The button tag component inherits styles from ButtonBase:
- Root: `hover:cursor-pointer text-sm`
- Contained variant: `inline-flex border items-center justify-center px-2 py-1 rounded-md font-medium focus:outline-none focus:ring-2 focus:ring-offset-2`
- Outlined variant: Similar structure with transparent background
- Text variant: `text-base` with hover underline effect

Each variant has color-specific classes for all supported colors.

#### Customizing Styles

You can customize the appearance by overriding the registered styles:

```ruby
# In your component or initializer
OkonomiUiKit::Components::ButtonTag.register_styles :custom do
  {
    root: "hover:cursor-pointer text-base font-semibold",
    contained: {
      root: "px-4 py-2 rounded-lg shadow-md transition-all",
      colors: {
        primary: "bg-indigo-600 text-white hover:bg-indigo-700 hover:shadow-lg"
      }
    }
  }
end
```

Or use runtime theme switching:

```erb
<% ui.theme(components: { button_tag: { root: "text-lg px-6 py-3" } }) do %>
  <%= ui.button_tag "Large Button", variant: :contained %>
<% end %>
```

## Best Practices

1. **Appropriate Button Types**: Use `type: :submit` for form submissions, `type: :button` for JavaScript actions
2. **Loading States**: Implement `data-disable-with` for buttons that trigger async operations
3. **Icon Usage**: Place icons before text with proper spacing for better readability
4. **Variant Selection**: Use contained for primary actions, outlined for secondary, text for tertiary
5. **Accessibility**: Include descriptive text or aria-labels for icon-only buttons

## Accessibility

The button tag component is built with accessibility in mind:
- Uses semantic `<button>` element
- Supports keyboard navigation (Tab, Enter, Space)
- Includes focus states with visible ring
- Maintains proper contrast ratios
- Supports screen reader announcements

## Examples

#### Action Toolbar
```erb
<div class="flex items-center gap-2 p-4 bg-gray-50 rounded-lg">
  <%= ui.button_tag "Edit", variant: :contained, color: :primary %>
  <%= ui.button_tag "Duplicate", variant: :outlined, color: :default %>
  <%= ui.button_tag "Archive", variant: :outlined, color: :warning %>
  <%= ui.button_tag "Delete", variant: :text, color: :danger %>
</div>
```

#### Modal Actions
```erb
<div class="modal-footer flex justify-end gap-3 pt-4 border-t">
  <%= ui.button_tag "Cancel", variant: :outlined, color: :default, data: { action: "modal#close" } %>
  <%= ui.button_tag "Confirm", variant: :contained, color: :primary, data: { action: "modal#confirm" } %>
</div>
```

#### Dropdown Trigger
```erb
<div class="relative" data-controller="dropdown">
  <%= ui.button_tag variant: :outlined, color: :default, data: { action: "dropdown#toggle" } do %>
    Options
    <%= ui.icon "chevron-down", size: :xs, class: "ml-2" %>
  <% end %>
  
  <div class="dropdown-menu hidden absolute right-0 mt-2 w-48 bg-white rounded-md shadow-lg">
    <!-- dropdown items -->
  </div>
</div>
```

#### Button Group
```erb
<div class="inline-flex rounded-md shadow-sm" role="group">
  <%= ui.button_tag "Year", variant: :outlined, color: :default, class: "rounded-r-none" %>
  <%= ui.button_tag "Month", variant: :outlined, color: :default, class: "rounded-none border-l-0" %>
  <%= ui.button_tag "Week", variant: :outlined, color: :default, class: "rounded-l-none border-l-0" %>
</div>
```

#### Icon Button
```erb
<%= ui.button_tag variant: :contained, color: :primary, class: "p-2", aria: { label: "Search" } do %>
  <%= ui.icon "search", size: :sm %>
<% end %>
```