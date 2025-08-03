# Icon Component

The Icon component provides a unified way to render SVG icons in your Rails application. It loads icons from your assets directory and allows you to apply custom classes, dimensions, and other HTML attributes.

## Basic Usage

```erb
<%= ui.icon("heroicons/outline/home") %>
```

## Customization Options

### With CSS Classes

Apply Tailwind CSS classes for styling:

```erb
<%= ui.icon("heroicons/outline/user", class: "h-6 w-6 text-blue-500") %>
```

### With Custom Dimensions

Set explicit width and height attributes:

```erb
<%= ui.icon("heroicons/outline/search", width: "24", height: "24") %>
```

### With Additional HTML Attributes

Add any HTML attributes like `id`, `data-*`, or ARIA attributes:

```erb
<%= ui.icon("heroicons/outline/bell", 
  id: "notification-icon",
  data: { toggle: "tooltip", placement: "bottom" },
  role: "img",
  "aria-label": "Notifications"
) %>
```

## Icon Sources

Icons can be placed in two locations:

1. **Host Application** (takes precedence): `app/assets/images/`
2. **Engine Default**: Engine's `app/assets/images/`

This allows you to override engine-provided icons or add custom icons specific to your application.

## Common Icon Collections

The component works with any SVG files, but commonly used with:

- **Heroicons Outline** (24×24): `heroicons/outline/*`
- **Heroicons Solid** (24×24): `heroicons/solid/*`
- **Heroicons Mini** (20×20): `heroicons/mini/*`
- **Heroicons Micro** (16×16): `heroicons/micro/*`
- **Custom Icons**: `custom/*`

## Examples

### Navigation Icons

```erb
<nav class="flex space-x-4">
  <a href="#" class="flex items-center px-3 py-2 text-sm font-medium text-gray-600 hover:text-gray-900">
    <%= ui.icon("heroicons/solid/home", class: "h-4 w-4 mr-2") %>
    Home
  </a>
  <a href="#" class="flex items-center px-3 py-2 text-sm font-medium text-gray-600 hover:text-gray-900">
    <%= ui.icon("heroicons/outline/document-text", class: "h-4 w-4 mr-2") %>
    Documents
  </a>
</nav>
```

### Button with Icon

```erb
<button class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md text-white bg-blue-600 hover:bg-blue-700">
  <%= ui.icon("heroicons/outline/plus", class: "h-4 w-4 mr-2") %>
  Add Item
</button>
```

### Status Indicators

```erb
<div class="flex items-center">
  <%= ui.icon("heroicons/outline/check-circle", class: "h-5 w-5 text-green-500 mr-2") %>
  <span class="text-sm text-gray-900">Task completed successfully</span>
</div>

<div class="flex items-center">
  <%= ui.icon("heroicons/outline/exclamation-triangle", class: "h-5 w-5 text-yellow-500 mr-2") %>
  <span class="text-sm text-gray-900">Warning: Check your settings</span>
</div>
```

### Empty States

```erb
<div class="text-center py-8">
  <%= ui.icon("heroicons/outline/document", class: "mx-auto h-12 w-12 text-gray-400") %>
  <h3 class="mt-2 text-sm font-medium text-gray-900">No documents</h3>
  <p class="mt-1 text-sm text-gray-500">Get started by creating a new document.</p>
</div>
```

## Styling with Theme

The Icon component supports customization through config classes:

```ruby
# app/helpers/okonomi_ui_kit/configs/icon.rb
module OkonomiUiKit
  module Configs
    class Icon < OkonomiUiKit::Config
      register_styles :custom do
        {
          base: "inline-block transition-colors duration-200"
        }
      end
      
      register_styles :animated do
        {
          base: "inline-block animate-pulse"
        }
      end
    end
  end
end
```

Then register and use your custom style:

```ruby
# In an initializer or component
OkonomiUiKit::Components::Icon.use_config(:custom)
```

## Best Practices

1. **Consistent Sizing**: Use standard Tailwind size classes (h-4 w-4, h-5 w-5, h-6 w-6, etc.)
2. **Semantic Colors**: Use color classes that match the icon's purpose (text-green-500 for success, text-red-500 for errors)
3. **Accessibility**: Add `role="img"` and `aria-label` for decorative icons that convey meaning
4. **Performance**: Icons are cached in memory after first load for better performance

## Error Handling

If an icon file is not found, the component will render a comment indicating the missing icon:

```html
<!-- SVG heroicons/outline/missing-icon not found -->
```

This makes it easy to identify missing icons during development without breaking the page layout.