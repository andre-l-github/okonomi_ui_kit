# Dropdown Button Component

The dropdown button component provides a button that reveals a dropdown menu when clicked. It inherits from `ButtonBase`, supporting all the same styling options while adding dropdown-specific functionality.

## Basic Usage

```erb
<%= ui.dropdown_button do |dd| %>
  <% dd.link_to "Profile", profile_path %>
  <% dd.link_to "Settings", settings_path %>
  <% dd.button_to "Logout", logout_path, method: :delete %>
<% end %>
```

The dropdown button uses a split button design:
- The first item becomes the primary action button (clickable)
- A chevron icon on the right opens the dropdown menu
- The two sections appear as a single cohesive button
- Remaining items appear in the dropdown menu

## Styling Options

Since `DropdownButton` inherits from `ButtonBase`, it supports all the same variants and colors:

```erb
<%= ui.dropdown_button(variant: :outlined, color: :primary) do |dd| %>
  <% dd.link_to "Edit", edit_path %>
  <% dd.link_to "Delete", delete_path %>
<% end %>
```

### Available Variants
- `:contained` (default) - Solid background button
- `:outlined` - Border with transparent background
- `:text` - Minimal text-only style

### Available Colors
- `:default`, `:primary`, `:secondary`, `:success`, `:danger`, `:warning`, `:info`

## Icons

Add icons to dropdown items using the `icon` option:

```erb
<%= ui.dropdown_button do |dd| %>
  <% dd.link_to "Profile", profile_path, icon: "heroicons/outline/user" %>
  <% dd.link_to "Settings", settings_path, icon: "heroicons/outline/cog" %>
  <% dd.button_to "Logout", logout_path, method: :delete, icon: "heroicons/outline/arrow-right-on-rectangle" %>
<% end %>
```

## Dividers

Separate groups of menu items with dividers:

```erb
<%= ui.dropdown_button do |dd| %>
  <% dd.link_to "Profile", profile_path %>
  <% dd.link_to "Settings", settings_path %>
  <% dd.divider %>
  <% dd.button_to "Logout", logout_path, method: :delete %>
<% end %>
```

## JavaScript Actions with button_tag

The dropdown button supports `button_tag` for JavaScript-triggered actions. This is useful for client-side operations like copying to clipboard, triggering modals, or other JavaScript functionality.

### Basic button_tag Usage

```erb
<%= ui.dropdown_button do |dd| %>
  <% dd.button_tag "Copy", data: { action: "click->clipboard#copy" }, icon: "heroicons/outline/clipboard" %>
  <% dd.button_tag "Print", onclick: "window.print()", icon: "heroicons/outline/printer" %>
  <% dd.link_to "Download", download_path, icon: "heroicons/outline/arrow-down-tray" %>
<% end %>
```

### button_tag with Stimulus Actions

Use with Stimulus controllers for more complex interactions:

```erb
<%= ui.dropdown_button(variant: :outlined, color: :primary) do |dd| %>
  <% dd.button_tag "Toggle Favorite", 
                   data: { action: "click->favorite#toggle", 
                          item_id: @item.id },
                   icon: "heroicons/outline/star" %>
  <% dd.button_tag "Duplicate", 
                   data: { action: "click->duplicate#create" },
                   icon: "heroicons/outline/document-duplicate" %>
  <% dd.divider %>
  <% dd.button_to "Delete", item_path(@item), method: :delete %>
<% end %>
```

### button_tag with Block Content

You can also use blocks for custom content:

```erb
<%= ui.dropdown_button do |dd| %>
  <% dd.button_tag data: { action: "click->share#open" } do %>
    <span class="font-bold">Share</span>
    <span class="text-xs text-gray-500 block">Opens share dialog</span>
  <% end %>
<% end %>
```

## Advanced Options

### Custom Menu Classes

Add custom classes to the dropdown menu:

```erb
<%= ui.dropdown_button(menu_class: "w-64") do |dd| %>
  <% dd.link_to "Wide menu item", path %>
<% end %>
```

### HTML Options

Standard HTML options are supported:

```erb
<%= ui.dropdown_button(id: "user-menu", data: { testid: "user-dropdown" }) do |dd| %>
  <% dd.link_to "Profile", profile_path %>
<% end %>
```

### Block Content

Use blocks for custom content in menu items:

```erb
<%= ui.dropdown_button do |dd| %>
  <% dd.link_to profile_path do %>
    <div class="flex items-center">
      <%= image_tag current_user.avatar, class: "w-8 h-8 rounded-full mr-2" %>
      <span><%= current_user.name %></span>
    </div>
  <% end %>
<% end %>
```

## JavaScript Behavior

The dropdown uses a Stimulus controller (`dropdown_controller.js`) to handle:
- Toggle on click
- Close when clicking outside
- Keyboard navigation (future enhancement)

## Customization

### Style Customization

Create a config class to override default styles:

```ruby
# app/helpers/okonomi_ui_kit/configs/dropdown_button.rb
module OkonomiUiKit
  module Configs
    class DropdownButton < OkonomiUiKit::Config
      register_styles :default do
        {
          primary: {
            icon: "mr-2 size-4",
            chevron: "size-4"
          },
          menu: {
            root: "absolute right-0 z-50 mt-3 w-48 rounded-lg bg-white shadow-xl",
            divider: "h-px my-2 bg-gray-100",
            item: {
              root: "block px-4 py-3 text-sm hover:bg-gray-50",
              icon: "mr-3 h-5 w-5 text-gray-500",
              label: "flex items-center"
            }
          }
        }
      end
    end
  end
end
```

### Template Override

Override the dropdown button template by creating:
```
app/views/okonomi/components/dropdown_button/_dropdown_button.html.erb
```

## Examples

### User Menu
```erb
<%= ui.dropdown_button(variant: :text) do |dd| %>
  <% dd.link_to current_user.name, profile_path, icon: "heroicons/outline/user" %>
  <% dd.link_to "Account Settings", account_path, icon: "heroicons/outline/cog" %>
  <% dd.link_to "Billing", billing_path, icon: "heroicons/outline/credit-card" %>
  <% dd.divider %>
  <% dd.button_to "Sign out", logout_path, method: :delete, icon: "heroicons/outline/arrow-right-on-rectangle" %>
<% end %>
```

### Actions Menu
```erb
<%= ui.dropdown_button(variant: :outlined, color: :primary) do |dd| %>
  <% dd.link_to "Edit", edit_item_path(@item), icon: "heroicons/outline/pencil" %>
  <% dd.link_to "Duplicate", duplicate_item_path(@item), icon: "heroicons/outline/document-duplicate" %>
  <% dd.divider %>
  <% dd.link_to "Archive", archive_item_path(@item), icon: "heroicons/outline/archive-box" %>
  <% dd.button_to "Delete", item_path(@item), method: :delete, icon: "heroicons/outline/trash", 
                  data: { confirm: "Are you sure?" } %>
<% end %>
```

### More Options Menu
```erb
<%= ui.dropdown_button do |dd| %>
  <% dd.link_to "View Details", item_path(@item) %>
  <% dd.link_to "Download", download_item_path(@item), icon: "heroicons/outline/arrow-down-tray" %>
  <% dd.link_to "Share", share_item_path(@item), icon: "heroicons/outline/share" %>
  <% dd.divider %>
  <% dd.link_to "Report", report_item_path(@item), icon: "heroicons/outline/flag" %>
<% end %>
```

### Mixed Actions with JavaScript
```erb
<%= ui.dropdown_button do |dd| %>
  <% dd.link_to "View Details", item_path(@item), icon: "heroicons/outline/eye" %>
  <% dd.button_tag "Copy Link", 
                   data: { action: "click->clipboard#copy", 
                          clipboard_text: item_url(@item) },
                   icon: "heroicons/outline/link" %>
  <% dd.divider %>
  <% dd.button_tag "Toggle Pin", 
                   data: { action: "click->pin#toggle" },
                   icon: "heroicons/outline/bookmark" %>
  <% dd.link_to "Move to...", move_item_path(@item), icon: "heroicons/outline/folder" %>
  <% dd.divider %>
  <% dd.button_to "Archive", archive_item_path(@item), method: :post, 
                  icon: "heroicons/outline/archive-box" %>
<% end %>
```