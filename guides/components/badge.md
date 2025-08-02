# Badge Component Guide

The Badge component provides a compact way to display labels, statuses, tags, or other small pieces of information with semantic colors.

## Basic Usage

#### Simple Badge
```erb
<%= ui.badge "New" %>
```

#### Badge with Severity
```erb
<%= ui.badge "Active", severity: :success %>
<%= ui.badge "Pending", severity: :warning %>
<%= ui.badge "Archived", severity: :danger %>
```

#### Badge with Custom Attributes
```erb
<%= ui.badge "Priority", severity: :info, id: "priority-badge", data: { value: "high" } %>
```

## Customization Options

| Option | Type/Values | Purpose |
|--------|-------------|---------|
| severity | :default, :success, :danger, :info, :warning | Controls the color scheme |
| variant | :default, :success, :danger, :info, :warning | Alias for severity |
| class | String | Additional CSS classes |
| id | String | HTML id attribute |
| data | Hash | Data attributes |

## Advanced Features

#### Badges with Icons
```erb
<%= ui.badge "Active", severity: :success do %>
  <%= ui.icon "check-circle", size: :xs, class: "mr-1" %>
  Active
<% end %>
```

#### Multiple Badges
```erb
<div class="flex gap-2">
  <%= ui.badge "Admin", severity: :info %>
  <%= ui.badge "Editor", severity: :default %>
  <%= ui.badge "Verified", severity: :success %>
</div>
```

#### Badge Groups
```erb
<div class="inline-flex items-center gap-1">
  <span class="text-sm text-gray-600">Tags:</span>
  <%= ui.badge "Ruby", severity: :danger %>
  <%= ui.badge "Rails", severity: :danger %>
  <%= ui.badge "JavaScript", severity: :warning %>
</div>
```

## Styling

#### Default Styles

The badge component includes these default Tailwind classes:
- Base: `inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium`
- Default severity: `bg-gray-100 text-gray-800`
- Success severity: `bg-green-100 text-green-800`
- Danger severity: `bg-red-100 text-red-800`
- Info severity: `bg-blue-100 text-blue-800`
- Warning severity: `bg-yellow-100 text-yellow-800`

#### Customizing Styles

You can customize the appearance by overriding the registered styles:

```ruby
# In your component or initializer
OkonomiUiKit::Components::Badge.register_styles :custom do
  {
    base: "px-3 py-1 rounded-md text-sm font-semibold",
    severities: {
      default: "bg-slate-200 text-slate-700",
      success: "bg-emerald-200 text-emerald-900",
      danger: "bg-rose-200 text-rose-900"
    }
  }
end
```

Or use runtime theme switching:

```erb
<% ui.theme(components: { badge: { base: "rounded-sm px-4" } }) do %>
  <%= ui.badge "Custom Badge" %>
<% end %>
```

## Best Practices

1. **Consistent Usage**: Use the same severity for the same type of information across your application
2. **Keep Text Short**: Badges should contain brief labels, typically 1-2 words
3. **Appropriate Colors**: Choose severities that match the semantic meaning (success for positive states, danger for errors)
4. **Avoid Overuse**: Too many badges can clutter the interface and reduce their effectiveness
5. **Accessibility**: Ensure sufficient color contrast and don't rely solely on color to convey meaning

## Accessibility

The badge component is built with accessibility in mind:
- Uses semantic HTML (`<span>` element)
- Maintains proper color contrast ratios
- Supports additional ARIA attributes when needed
- Text remains readable at various zoom levels

## Examples

#### User Status Badge
```erb
<div class="flex items-center gap-3">
  <img src="avatar.jpg" class="w-10 h-10 rounded-full">
  <span class="font-medium">John Doe</span>
  <%= ui.badge(@user.active? ? "Active" : "Inactive", severity: @user.active? ? :success : :danger) %>
</div>
```

#### Product Table with Badges
```erb
<%= ui.table do |table| %>
  <% table.head do %>
    <% table.th "Product" %>
    <% table.th "Status" %>
    <% table.th "Stock" %>
  <% end %>
  <% table.body do %>
    <% @products.each do |product| %>
      <% table.tr do %>
        <% table.td product.name %>
        <% table.td do %>
          <%= ui.badge(product.status.humanize, severity: product.status_severity) %>
        <% end %>
        <% table.td do %>
          <% if product.in_stock? %>
            <%= ui.badge "In Stock", severity: :success %>
          <% else %>
            <%= ui.badge "Out of Stock", severity: :danger %>
          <% end %>
        <% end %>
      <% end %>
    <% end %>
  <% end %>
<% end %>
```

#### Notification Count Badge
```erb
<button class="relative p-2">
  <%= ui.icon "bell", size: :md %>
  <% if @unread_count > 0 %>
    <span class="absolute -top-1 -right-1">
      <%= ui.badge @unread_count.to_s, severity: :danger, class: "min-w-[20px] h-5 flex items-center justify-center" %>
    </span>
  <% end %>
</button>
```

#### Tag Cloud
```erb
<div class="flex flex-wrap gap-2">
  <% @tags.each do |tag| %>
    <%= ui.badge tag.name, severity: tag_severity(tag.category) %>
  <% end %>
</div>
```