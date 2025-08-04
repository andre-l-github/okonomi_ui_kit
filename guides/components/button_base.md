# ButtonBase Component Guide

The ButtonBase component provides the foundation for all button components in OkonomiUiKit, offering consistent styling and behavior patterns across button_tag, button_to, and link_to components.

## Basic Usage

ButtonBase is not directly used in views. Instead, it provides the base functionality for other button components. Use one of these derived components:

#### Button Tag
```erb
<%= ui.button_tag "Click Me" %>
```

#### Button To (with URL)
```erb
<%= ui.button_to "Submit", form_path, method: :post %>
```

#### Link To (styled as button)
```erb
<%= ui.link_to "Navigate", path, variant: :contained %>
```

## Customization Options

ButtonBase provides these standardized options that all button components inherit:

| Option | Type/Values | Purpose |
|--------|-------------|---------|
| variant | :contained, :outlined, :text | Controls the visual style of the button |
| color | :default, :primary, :secondary, :success, :danger, :warning, :info | Sets the color scheme |
| classes | String | Additional CSS classes to apply |

## Advanced Features

#### Block Content
All button components support block content for complex button layouts:

```erb
<%= ui.button_tag variant: :outlined, color: :primary do %>
  <%= ui.icon "plus" %>
  <span>Add Item</span>
<% end %>
```

#### Combining with Form Actions
```erb
<%= ui.button_to products_path, method: :delete, variant: :contained, color: :danger do %>
  <%= ui.icon "trash" %>
  Delete Product
<% end %>
```

## Styling

#### Default Styles

The ButtonBase component includes these base styles for all buttons:
- Base: `hover:cursor-pointer text-sm`

Variant-specific styles:
- **Contained**: `inline-flex border items-center justify-center px-2 py-1 rounded-md font-medium focus:outline-none focus:ring-2 focus:ring-offset-2`
- **Outlined**: Same structural styles as contained but with transparent background
- **Text**: `text-base` with hover underline effects

#### Customizing Styles

You can customize button styles by creating a custom configuration:

```ruby
# In your initializer or component
module OkonomiUiKit
  module Components
    class ButtonBase
      register_styles :custom do
        {
          root: "hover:cursor-pointer text-base font-semibold",
          contained: {
            root: "inline-flex items-center px-4 py-2 rounded-lg shadow-sm",
            colors: {
              primary: "bg-brand-600 text-white hover:bg-brand-700 focus:ring-brand-500"
            }
          }
        }
      end
    end
  end
end
```

Or use runtime theme switching:

```erb
<% ui.theme(components: { button_base: { contained: { colors: { primary: "bg-brand-500" } } } }) do %>
  <%= ui.button_tag "Themed Button", variant: :contained, color: :primary %>
<% end %>
```

## Best Practices

1. **Consistent Variants**: Use the same variant for similar actions across your application
2. **Color Semantics**: Use colors consistently (e.g., danger for destructive actions, primary for main CTAs)
3. **Accessible Labels**: Always provide clear, descriptive button text
4. **Loading States**: Consider adding loading indicators for async actions
5. **Button vs Link**: Use button_to for actions, link_to for navigation

## Accessibility

ButtonBase ensures all derived button components:
- Use semantic HTML elements (`<button>`, `<a>`, or form `<button>`)
- Include focus states with visible focus rings
- Support keyboard navigation
- Maintain proper color contrast ratios

## Examples

#### Form Submit Button
```erb
<%= form_with model: @product do |f| %>
  <!-- form fields -->
  <%= ui.button_tag "Save Product", variant: :contained, color: :primary, type: :submit %>
<% end %>
```

#### Destructive Action
```erb
<%= ui.button_to product_path(@product), 
    method: :delete, 
    variant: :contained, 
    color: :danger,
    data: { confirm: "Are you sure?" } do %>
  Delete Product
<% end %>
```

#### Navigation Button Group
```erb
<div class="flex gap-2">
  <%= ui.link_to "Previous", prev_path, variant: :outlined, color: :default %>
  <%= ui.link_to "Next", next_path, variant: :contained, color: :primary %>
</div>
```

#### Icon-Only Button
```erb
<%= ui.button_tag variant: :text, color: :default, class: "p-1" do %>
  <%= ui.icon "ellipsis-vertical", size: 5 %>
<% end %>
```

#### Button with Badge
```erb
<%= ui.button_tag variant: :outlined, color: :primary, class: "gap-2" do %>
  <span>Notifications</span>
  <%= ui.badge "5", color: :danger, size: :sm %>
<% end %>
```