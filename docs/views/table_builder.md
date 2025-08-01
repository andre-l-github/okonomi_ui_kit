# Table Builder System

The Table Builder provides a consistent, accessible way to create data tables without writing repetitive HTML markup. It automatically handles responsive behavior, proper styling, and semantic structure.

## Overview

The table builder creates clean, professional tables with:
- **Auto-detection**: Automatically styles first and last columns appropriately
- **Flexible alignment**: Support for left, center, and right text alignment
- **Responsive design**: Horizontal scrolling on smaller screens
- **Empty states**: Built-in support for tables with no data
- **Consistent styling**: Uniform appearance across the application

## Basic Usage

Every table should use the table builder helper:

```erb
<%= table do |t| %>
  <%= t.head do %>
    <%= t.tr do %>
      <%= t.th { "Column 1" } %>
      <%= t.th { "Column 2" } %>
    <% end %>
  <% end %>
  
  <%= t.body do %>
    <%= t.tr do %>
      <%= t.td { "Data 1" } %>
      <%= t.td { "Data 2" } %>
    <% end %>
  <% end %>
<% end %>
```

## Auto-Detection Features

The table builder automatically detects column positions and applies appropriate styling:

### Automatic Column Styling

```erb
<%= table do |t| %>
  <%= t.head do %>
    <%= t.tr do %>
      <%= t.th { "Name" } %>        <!-- Auto: First column (no left padding) -->
      <%= t.th { "Email" } %>       <!-- Auto: Middle column (normal padding) -->
      <%= t.th { "Role" } %>        <!-- Auto: Middle column (normal padding) -->
      <%= t.th { "Actions" } %>     <!-- Auto: Last column (no right padding) -->
    <% end %>
  <% end %>
  
  <%= t.body do %>
    <%= t.tr do %>
      <%= t.td { "John Doe" } %>         <!-- Auto: First (bold, no left padding) -->
      <%= t.td { "john@example.com" } %>  <!-- Auto: Middle (normal styling) -->
      <%= t.td { "Admin" } %>             <!-- Auto: Middle (normal styling) -->
      <%= t.td { "Edit | Delete" } %>     <!-- Auto: Last (no right padding) -->
    <% end %>
  <% end %>
<% end %>
```

### Column Position Styling Rules

- **First Column**:
  - Headers: No left padding, bold font
  - Data: No left padding, bold text, darker color
- **Middle Columns**:
  - Headers: Normal padding, bold font
  - Data: Normal padding, regular text, lighter color
- **Last Column**:
  - Headers: No right padding, bold font
  - Data: No right padding, regular text

## Text Alignment

Control text alignment with the `align` parameter:

```erb
<%= table do |t| %>
  <%= t.head do %>
    <%= t.tr do %>
      <%= t.th { "Product" } %>                    <!-- Default: left -->
      <%= t.th(align: :center) { "Status" } %>     <!-- Center aligned -->
      <%= t.th(align: :right) { "Price" } %>       <!-- Right aligned -->
      <%= t.th(align: :right) { "Actions" } %>     <!-- Right aligned -->
    <% end %>
  <% end %>
  
  <%= t.body do %>
    <%= t.tr do %>
      <%= t.td { "Widget Pro" } %>                      <!-- Default: left -->
      <%= t.td(align: :center) do %>                    <!-- Center aligned -->
        <%= ui.badge("Active", :success) %>
      <% end %>
      <%= t.td(align: :right) { "$299.99" } %>          <!-- Right aligned -->
      <%= t.td(align: :right) do %>                     <!-- Right aligned -->
        <%= link_to "Edit", edit_path(product) %>
      <% end %>
    <% end %>
  <% end %>
<% end %>
```

### Supported Alignment Values

- **`:left`** (default) - Left-aligned text
- **`:center`** - Center-aligned text  
- **`:right`** - Right-aligned text

## Empty States

Handle tables with no data using the built-in empty state support:

```erb
<%= table do |t| %>
  <%= t.head do %>
    <%= t.tr do %>
      <%= t.th { "Name" } %>
      <%= t.th { "Email" } %>
      <%= t.th { "Role" } %>
    <% end %>
  <% end %>

  <%= t.body do %>
    <% if users.any? %>
      <% users.each do |user| %>
        <%= t.tr do %>
          <%= t.td { user.name } %>
          <%= t.td { user.email } %>
          <%= t.td { user.role } %>
        <% end %>
      <% end %>
    <% else %>
      <%= t.empty_state(title: "No users found", colspan: 3) %>
    <% end %>
  <% end %>
<% end %>
```

### Empty State Options

- **`title`**: Custom message (default: "No records found")
- **`icon`**: Icon path from assets/images (default: "heroicons/outline/document")
- **`colspan`**: Number of columns to span (required)
- **Block support**: Pass a block for completely custom empty state content

```erb
<!-- Custom empty state -->
<%= t.empty_state(title: "No products available", icon: "heroicons/outline/archive-box", colspan: 4) %>

<!-- Custom HTML content -->
<%= t.empty_state(colspan: 3) do %>
  <div class="text-center py-12">
    <%= svg_icon("heroicons/outline/plus", class: "mx-auto h-8 w-8 text-gray-400") %>
    <h3 class="mt-4 text-lg font-medium text-gray-900">No items yet</h3>
    <p class="mt-2 text-sm text-gray-500">Get started by creating your first item.</p>
    <%= link_to "Create Item", new_item_path, class: "mt-4 button" %>
  </div>
<% end %>
```

## Advanced Examples

### Complex Data Table

```erb
<%= table do |t| %>
  <%= t.head do %>
    <%= t.tr do %>
      <%= t.th { "Product" } %>
      <%= t.th(align: :center) { "Status" } %>
      <%= t.th(align: :right) { "Price" } %>
      <%= t.th(align: :right) { "Stock" } %>
      <%= t.th(align: :center) { "Featured" } %>
      <%= t.th(align: :right) { "Actions" } %>
    <% end %>
  <% end %>

  <%= t.body do %>
    <% @products.each do |product| %>
      <%= t.tr do %>
        <%= t.td do %>
          <div class="flex items-center">
            <% if product.image.attached? %>
              <%= image_tag product.image, class: "h-10 w-10 rounded object-cover mr-3" %>
            <% end %>
            <div>
              <div class="font-medium text-gray-900"><%= product.name %></div>
              <div class="text-gray-500 text-sm"><%= product.sku %></div>
            </div>
          </div>
        <% end %>
        
        <%= t.td(align: :center) do %>
          <%= ui.badge(product.status.humanize, product.status_color) %>
        <% end %>
        
        <%= t.td(align: :right) { number_to_currency(product.price) } %>
        
        <%= t.td(align: :right) do %>
          <span class="<%= product.low_stock? ? 'text-red-600' : 'text-gray-900' %>">
            <%= product.stock_quantity %>
          </span>
        <% end %>
        
        <%= t.td(align: :center) do %>
          <% if product.featured? %>
            <%= svg_icon("heroicons/solid/star", class: "h-5 w-5 text-yellow-400") %>
          <% end %>
        <% end %>
        
        <%= t.td(align: :right) do %>
          <div class="flex justify-end space-x-2">
            <%= link_to "Edit", edit_product_path(product), class: "text-indigo-600 hover:text-indigo-900" %>
            <%= link_to "Delete", product_path(product), method: :delete, 
                        class: "text-red-600 hover:text-red-900",
                        confirm: "Are you sure?" %>
          </div>
        <% end %>
      <% end %>
    <% end %>
  <% end %>
<% end %>
```

### Table with Custom CSS Classes

```erb
<%= table(class: "custom-table-class") do |t| %>
  <%= t.head do %>
    <%= t.tr do %>
      <%= t.th(class: "custom-header") { "Name" } %>
      <%= t.th { "Status" } %>
    <% end %>
  <% end %>
  
  <%= t.body do %>
    <%= t.tr do %>
      <%= t.td(class: "font-bold text-blue-600") { "Custom styling" } %>
      <%= t.td { "Active" } %>
    <% end %>
  <% end %>
<% end %>
```

## Integration with Page Builder

Tables work seamlessly within the page builder system:

```erb
<%= ui.page do |p| %>
  <%= p.page_header do |h| %>
    <% h.breadcrumbs do |crumb| %>
      <% crumb.link "Dashboard", dashboard_path %>
      <% crumb.link "Users", users_path, current: true %>
    <% end %>
    <% h.row do |r| %>
      <% r.title "User Management" %>
      <% r.actions do %>
        <%= link_to "New User", new_user_path, class: "button" %>
      <% end %>
    <% end %>
  <% end %>

  <%= p.section do |s| %>
    <% s.title "Active Users" %>
    <% s.subtitle "Manage user accounts and permissions" %>
    <% s.body do %>
      <%= table do |t| %>
        <!-- table content -->
      <% end %>
    <% end %>
  <% end %>
<% end %>
```

## Best Practices

### 1. Always Use the Table Builder

Never write table HTML directly. Use the builder for consistency.

```erb
<!-- ✅ Good -->
<%= table do |t| %>
  <!-- table content -->
<% end %>

<!-- ❌ Bad -->
<table class="min-w-full">
  <!-- manual HTML -->
</table>
```

### 2. Use Appropriate Alignment

- **Left**: Text, names, descriptions
- **Center**: Status badges, icons, short labels  
- **Right**: Numbers, prices, actions

```erb
<!-- ✅ Good alignment choices -->
<%= t.th { "Customer Name" } %>              <!-- Left (default) -->
<%= t.th(align: :center) { "Status" } %>     <!-- Center for badges -->
<%= t.th(align: :right) { "Total" } %>       <!-- Right for numbers -->
<%= t.th(align: :right) { "Actions" } %>     <!-- Right for actions -->
```

### 3. Provide Empty States

Always handle the case where tables have no data.

```erb
<!-- ✅ Good -->
<%= t.body do %>
  <% if records.any? %>
    <% records.each do |record| %>
      <!-- table rows -->
    <% end %>
  <% else %>
    <%= t.empty_state(title: "No records found", colspan: column_count) %>
  <% end %>
<% end %>

<!-- ❌ Bad - No empty state handling -->
<%= t.body do %>
  <% records.each do |record| %>
    <!-- table rows -->
  <% end %>
<% end %>
```

### 4. Use Semantic Column Headers

Make headers descriptive and helpful for users and accessibility.

```erb
<!-- ✅ Good -->
<%= t.th { "Customer Name" } %>
<%= t.th { "Order Total" } %>
<%= t.th { "Order Date" } %>
<%= t.th { "Status" } %>

<!-- ❌ Bad -->
<%= t.th { "Name" } %>
<%= t.th { "Amount" } %>
<%= t.th { "Date" } %>
<%= t.th { "Info" } %>
```

### 5. Use Helper Methods for Complex Content

Keep table cells clean by using helper methods for complex formatting.

```erb
<!-- ✅ Good -->
<%= t.td { user_avatar_and_name(user) } %>
<%= t.td(align: :right) { formatted_currency(order.total) } %>
<%= t.td(align: :center) { status_badge(order.status) } %>

<!-- ❌ Bad - Complex inline logic -->
<%= t.td do %>
  <div class="flex items-center">
    <%= image_tag user.avatar, class: "h-8 w-8 rounded-full mr-2" if user.avatar.attached? %>
    <div>
      <div class="font-medium"><%= user.name %></div>
      <div class="text-sm text-gray-500"><%= user.email %></div>
    </div>
  </div>
<% end %>
```

## Migration from Manual Tables

### Before (Manual HTML)

```erb
<div class="overflow-x-auto">
  <table class="min-w-full divide-y divide-gray-300">
    <thead>
      <tr>
        <th class="py-3.5 pr-3 text-left text-sm font-semibold text-gray-900">Name</th>
        <th class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900">Email</th>
      </tr>
    </thead>
    <tbody class="divide-y divide-gray-200 bg-white">
      <% users.each do |user| %>
        <tr>
          <td class="py-4 pr-3 text-sm font-medium text-gray-900"><%= user.name %></td>
          <td class="px-3 py-4 text-sm text-gray-500"><%= user.email %></td>
        </tr>
      <% end %>
    </tbody>
  </table>
</div>
```

### After (Table Builder)

```erb
<%= table do |t| %>
  <%= t.head do %>
    <%= t.tr do %>
      <%= t.th { "Name" } %>
      <%= t.th { "Email" } %>
    <% end %>
  <% end %>
  
  <%= t.body do %>
    <% users.each do |user| %>
      <%= t.tr do %>
        <%= t.td { user.name } %>
        <%= t.td { user.email } %>
      <% end %>
    <% end %>
  <% end %>
<% end %>
```

## Technical Implementation

The table builder:

1. **Collects cell data** during `th`/`td` calls
2. **Auto-detects positions** when `tr` block completes  
3. **Applies appropriate styling** based on first/middle/last position
4. **Handles alignment** through CSS classes
5. **Provides responsive wrapper** with horizontal scrolling

This ensures consistent styling and behavior across all tables while maintaining flexibility for custom requirements.

## Extending the Table Builder

The system can be extended for specific needs:

```ruby
# Add custom cell types
def status_cell(status, **options, &block)
  td(align: :center, **options) do
    badge(status.humanize, status_color(status))
  end
end

# Add custom table variants
def compact_table(**options, &block)
  table(class: "compact-table #{options[:class]}", &block)
end
```

The table builder provides a solid foundation for data presentation while remaining extensible for application-specific requirements.