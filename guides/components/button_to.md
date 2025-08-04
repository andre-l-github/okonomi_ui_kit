# Button To Component Guide

The Button To component extends Rails' `button_to` helper to create form-based buttons with consistent styling, perfect for actions that require HTTP methods other than GET.

## Basic Usage

#### Simple Button To
```erb
<%= ui.button_to "Submit", "/path" %>
```

#### Button To with HTTP Method
```erb
<%= ui.button_to "Delete", item_path(@item), method: :delete %>
<%= ui.button_to "Update", item_path(@item), method: :patch %>
```

#### Button To with Variants
```erb
<%= ui.button_to "Primary Action", "/path", variant: :contained, color: :primary %>
<%= ui.button_to "Secondary Action", "/path", variant: :outlined, color: :secondary %>
<%= ui.button_to "Danger Action", "/path", variant: :text, color: :danger %>
```

#### Button To with Icons
```erb
# Icon at start (default position)
<%= ui.button_to "Save", save_path, icon: "heroicons/outline/save" %>

# Icon at end
<%= ui.button_to "Continue", next_path, icon: { end: "heroicons/outline/arrow-right" } %>

# Icon only button
<%= ui.button_to delete_path, method: :delete, icon: "heroicons/outline/trash" %>
```

## Customization Options

| Option | Type/Values | Purpose |
|--------|-------------|---------|
| variant | :contained, :outlined, :text | Controls the button style |
| color | :default, :primary, :secondary, :success, :danger, :warning, :info | Sets the color scheme |
| icon | String or Hash | Adds an icon (string defaults to start, hash can specify :start or :end) |
| method | :get, :post, :patch, :put, :delete | HTTP method for the request |
| disabled | Boolean | Disables the button |
| class | String | Additional CSS classes |
| id | String | HTML id attribute |
| data | Hash | Data attributes including confirmations |
| form | Hash | Additional form tag attributes |

## Advanced Features

#### Button To with Confirmation
```erb
<%= ui.button_to "Delete Account", 
    account_path(@account), 
    method: :delete,
    variant: :contained,
    color: :danger,
    data: { 
      confirm: "Are you sure you want to delete your account?",
      confirm_text: "This action cannot be undone."
    } %>
```

#### Button To with Block Content
```erb
<%= ui.button_to edit_item_path(@item), method: :get, icon: "heroicons/outline/pencil" do %>
  Edit Item
<% end %>
```

#### Inline Form Styling
```erb
<%= ui.button_to "Quick Action", "/path", 
    form: { class: "inline-block" },
    variant: :outlined,
    color: :primary %>
```

## Styling

#### Default Styles

The button to component inherits all styles from ButtonBase:
- Root: `hover:cursor-pointer text-sm`
- Contained variant: Full background color with hover states
- Outlined variant: Border with transparent background
- Text variant: Text-only style with underline on hover

The component automatically wraps the button in a form element styled appropriately.

#### Customizing Styles

You can customize the appearance by creating a custom config:

```ruby
# app/helpers/okonomi_ui_kit/configs/button_to.rb
module OkonomiUiKit
  module Configs
    class ButtonTo < OkonomiUiKit::Config
      register_styles :custom do
        {
          root: "hover:cursor-pointer text-base transition-all duration-200",
          contained: {
            root: "px-4 py-2 rounded-lg shadow-sm hover:shadow-md",
            colors: {
              danger: "bg-red-600 text-white hover:bg-red-700 active:bg-red-800"
            }
          }
        }
      end
    end
  end
end
```

Then register and use your custom style:

```ruby
# In an initializer or component
OkonomiUiKit::Components::ButtonTo.use_config(:custom)
```

## Best Practices

1. **Use for Non-GET Actions**: Perfect for DELETE, POST, PATCH operations that modify data
2. **Confirmation Dialogs**: Always add confirmations for destructive actions
3. **Method Selection**: Explicitly specify the HTTP method for clarity
4. **Form Attributes**: Use the `form` option to control the wrapper form element
5. **Loading States**: Implement loading indicators for async operations

## Accessibility

The button to component maintains accessibility standards:
- Generates a proper form with CSRF protection
- Uses semantic `<button>` element within the form
- Supports keyboard navigation
- Maintains focus states
- Works with screen readers

## Examples

#### Resource Actions in a Table
```erb
<%= ui.table do |table| %>
  <% @items.each do |item| %>
    <% table.tr do %>
      <% table.td item.name %>
      <% table.td do %>
        <div class="flex gap-2">
          <%= ui.button_to "Edit", edit_item_path(item), 
              method: :get, 
              variant: :outlined, 
              color: :primary,
              form: { class: "inline" } %>
          <%= ui.button_to "Delete", item_path(item), 
              method: :delete,
              variant: :text,
              color: :danger,
              data: { confirm: "Are you sure?" },
              form: { class: "inline" } %>
        </div>
      <% end %>
    <% end %>
  <% end %>
<% end %>
```

#### Admin Action Panel
```erb
<div class="bg-gray-50 p-4 rounded-lg">
  <h3 class="text-lg font-medium mb-4">Admin Actions</h3>
  <div class="space-y-2">
    <%= ui.button_to "Publish All", publish_all_posts_path, 
        method: :post,
        variant: :contained,
        color: :success,
        class: "w-full" %>
    <%= ui.button_to "Archive Old Posts", archive_posts_path,
        method: :post,
        variant: :outlined,
        color: :warning,
        class: "w-full",
        data: { confirm: "Archive posts older than 6 months?" } %>
    <%= ui.button_to "Clear Cache", clear_cache_path,
        method: :delete,
        variant: :outlined,
        color: :danger,
        class: "w-full" %>
  </div>
</div>
```

#### Shopping Cart Actions
```erb
<div class="cart-item flex justify-between items-center p-4">
  <div class="item-details">
    <h4><%= item.name %></h4>
    <p class="text-gray-600">$<%= item.price %></p>
  </div>
  <div class="actions flex gap-2">
    <%= ui.button_to "-", update_cart_item_path(item), 
        method: :patch,
        params: { quantity: item.quantity - 1 },
        variant: :outlined,
        color: :default,
        class: "w-8 h-8 p-0" %>
    <span class="px-3 py-1"><%= item.quantity %></span>
    <%= ui.button_to "+", update_cart_item_path(item),
        method: :patch,
        params: { quantity: item.quantity + 1 },
        variant: :outlined,
        color: :default,
        class: "w-8 h-8 p-0" %>
    <%= ui.button_to remove_from_cart_path(item),
        method: :delete,
        variant: :text,
        color: :danger,
        icon: "heroicons/outline/trash",
        form: { class: "ml-4" } %>
  </div>
</div>
```

#### Toggle State Button
```erb
<%= ui.button_to @feature.enabled? ? "Enabled" : "Disabled",
    toggle_feature_path(@feature),
    method: :patch,
    variant: :contained,
    color: @feature.enabled? ? :success : :default,
    icon: @feature.enabled? ? "heroicons/outline/check" : "heroicons/outline/x" %>
```