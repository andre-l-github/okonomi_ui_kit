# Table Component Guide

The Table component provides a flexible builder for creating responsive, accessible data tables with consistent styling and built-in features like empty states.

## Basic Usage

#### Simple Table
```erb
<%= ui.table do |table| %>
  <% table.head do %>
    <% table.tr do %>
      <% table.th %>Name<% end %>
      <% table.th %>Email<% end %>
      <% table.th %>Status<% end %>
    <% end %>
  <% end %>
  
  <% table.body do %>
    <% @users.each do |user| %>
      <% table.tr do %>
        <% table.td %><%= user.name %><% end %>
        <% table.td %><%= user.email %><% end %>
        <% table.td %><%= user.status %><% end %>
      <% end %>
    <% end %>
  <% end %>
<% end %>
```

#### Table with Block Syntax
```erb
<%= ui.table do |table| %>
  <% table.head do %>
    <% table.tr do %>
      <% table.th { "Product" } %>
      <% table.th { "Price" } %>
      <% table.th { "Stock" } %>
    <% end %>
  <% end %>
  
  <% table.body do %>
    <% @products.each do |product| %>
      <% table.tr do %>
        <% table.td { product.name } %>
        <% table.td { number_to_currency(product.price) } %>
        <% table.td { product.stock_count } %>
      <% end %>
    <% end %>
  <% end %>
<% end %>
```

## Customization Options

### Table Options
| Option | Type/Values | Purpose |
|--------|-------------|---------|
| variant | :default | Controls the table style |
| class | String | Additional CSS classes |
| id | String | HTML id attribute |
| data | Hash | Data attributes |

### Cell Options
| Option | Type/Values | Purpose |
|--------|-------------|---------|
| align | :left, :center, :right | Text alignment |
| scope | "col", "row" | Scope for th elements |
| colspan | Integer | Number of columns to span |
| class | String | Additional CSS classes |

## Advanced Features

#### Table with Aligned Columns
```erb
<%= ui.table do |table| %>
  <% table.head do %>
    <% table.tr do %>
      <% table.th align: :left %>Item<% end %>
      <% table.th align: :center %>Quantity<% end %>
      <% table.th align: :right %>Price<% end %>
      <% table.th align: :right %>Total<% end %>
    <% end %>
  <% end %>
  
  <% table.body do %>
    <% @order_items.each do |item| %>
      <% table.tr do %>
        <% table.td align: :left %><%= item.name %><% end %>
        <% table.td align: :center %><%= item.quantity %><% end %>
        <% table.td align: :right %><%= number_to_currency(item.price) %><% end %>
        <% table.td align: :right %><%= number_to_currency(item.total) %><% end %>
      <% end %>
    <% end %>
  <% end %>
<% end %>
```

#### Table with Rich Content
```erb
<%= ui.table do |table| %>
  <% table.head do %>
    <% table.tr do %>
      <% table.th %>User<% end %>
      <% table.th %>Role<% end %>
      <% table.th %>Status<% end %>
      <% table.th %>Actions<% end %>
    <% end %>
  <% end %>
  
  <% table.body do %>
    <% @users.each do |user| %>
      <% table.tr do %>
        <% table.td do %>
          <div class="flex items-center gap-3">
            <img src="<%= user.avatar_url %>" class="h-10 w-10 rounded-full">
            <div>
              <div class="font-medium"><%= user.name %></div>
              <div class="text-sm text-gray-500"><%= user.email %></div>
            </div>
          </div>
        <% end %>
        <% table.td do %>
          <%= ui.badge user.role.humanize, severity: :info %>
        <% end %>
        <% table.td do %>
          <%= ui.badge(user.active? ? "Active" : "Inactive", 
                       severity: user.active? ? :success : :danger) %>
        <% end %>
        <% table.td do %>
          <div class="flex gap-2">
            <%= ui.link_to "Edit", edit_user_path(user), variant: :text, color: :primary %>
            <%= ui.link_to "Delete", user_path(user), 
                variant: :text, 
                color: :danger,
                data: { turbo_method: :delete, turbo_confirm: "Are you sure?" } %>
          </div>
        <% end %>
      <% end %>
    <% end %>
  <% end %>
<% end %>
```

#### Empty State
```erb
<%= ui.table do |table| %>
  <% table.head do %>
    <% table.tr do %>
      <% table.th %>Name<% end %>
      <% table.th %>Email<% end %>
      <% table.th %>Status<% end %>
    <% end %>
  <% end %>
  
  <% table.body do %>
    <% if @users.empty? %>
      <% table.empty_state(
          title: "No users found",
          icon: "users",
          colspan: 3
      ) %>
    <% else %>
      <% @users.each do |user| %>
        <!-- table rows -->
      <% end %>
    <% end %>
  <% end %>
<% end %>
```

#### Custom Empty State
```erb
<%= ui.table do |table| %>
  <% table.body do %>
    <% if @products.empty? %>
      <% table.empty_state colspan: 4 do %>
        <div class="py-12">
          <%= ui.icon "package", class: "mx-auto h-12 w-12 text-gray-400" %>
          <h3 class="mt-2 text-sm font-medium text-gray-900">No products</h3>
          <p class="mt-1 text-sm text-gray-500">Get started by creating a new product.</p>
          <div class="mt-6">
            <%= ui.button_to "New Product", new_product_path, variant: :contained, color: :primary %>
          </div>
        </div>
      <% end %>
    <% end %>
  <% end %>
<% end %>
```

## Styling

#### Default Styles

The table component includes these default Tailwind classes:
- Body: `divide-y divide-gray-200 bg-white`
- Header cells: `text-sm font-semibold text-gray-900`
- Data cells: `text-sm whitespace-nowrap`
- First column: Special styling with `font-medium text-gray-900`
- Alignment classes: `text-left`, `text-center`, `text-right`
- Empty state: Centered content with gray text

Position-based styling:
- First cell: `py-3.5 pr-3` (th) or `py-4 pr-3` (td)
- Middle cells: `pl-3 pr-3 py-3.5` (th) or `pl-3 pr-3 py-4` (td)
- Last cell: `relative py-3.5` (th) or `relative py-4` (td)

#### Customizing Styles

You can customize the appearance by overriding the registered styles:

```ruby
# In your component or initializer
OkonomiUiKit::Components::Table.register_styles :custom do
  {
    default: {
      body: {
        base: "divide-y divide-gray-100 bg-gray-50"
      },
      th: {
        base: "text-xs uppercase tracking-wider text-gray-700",
        first: "py-4 pr-4",
        middle: "px-4 py-4"
      },
      td: {
        base: "text-sm",
        first: "py-3 pr-4 font-semibold",
        middle: "px-4 py-3"
      }
    }
  }
end
```

## Best Practices

1. **Semantic Markup**: Always use proper table structure with thead and tbody
2. **Header Scope**: Include scope attribute on th elements for accessibility
3. **Responsive Design**: Consider mobile layouts - tables may need horizontal scrolling
4. **Empty States**: Always handle empty data sets with meaningful messages
5. **Alignment**: Align numeric data to the right, text to the left
6. **Loading States**: Consider showing skeleton rows while data loads

## Accessibility

The table component is built with accessibility in mind:
- Uses semantic table elements (`<table>`, `<thead>`, `<tbody>`, `<tr>`, `<th>`, `<td>`)
- Includes proper scope attributes on header cells
- Maintains logical reading order
- Supports keyboard navigation
- Empty states are announced to screen readers

## Examples

#### Invoice Table
```erb
<%= ui.table do |table| %>
  <% table.head do %>
    <% table.tr do %>
      <% table.th align: :left %>Description<% end %>
      <% table.th align: :center %>Qty<% end %>
      <% table.th align: :right %>Unit Price<% end %>
      <% table.th align: :right %>Amount<% end %>
    <% end %>
  <% end %>
  
  <% table.body do %>
    <% @invoice.line_items.each do |item| %>
      <% table.tr do %>
        <% table.td align: :left %><%= item.description %><% end %>
        <% table.td align: :center %><%= item.quantity %><% end %>
        <% table.td align: :right %><%= number_to_currency(item.unit_price) %><% end %>
        <% table.td align: :right %><%= number_to_currency(item.total) %><% end %>
      <% end %>
    <% end %>
    
    <% table.tr do %>
      <% table.td colspan: 3, align: :right, class: "font-medium" %>Subtotal<% end %>
      <% table.td align: :right %><%= number_to_currency(@invoice.subtotal) %><% end %>
    <% end %>
    
    <% table.tr do %>
      <% table.td colspan: 3, align: :right, class: "font-medium" %>Tax<% end %>
      <% table.td align: :right %><%= number_to_currency(@invoice.tax) %><% end %>
    <% end %>
    
    <% table.tr do %>
      <% table.td colspan: 3, align: :right, class: "font-bold text-lg" %>Total<% end %>
      <% table.td align: :right, class: "font-bold text-lg" %>
        <%= number_to_currency(@invoice.total) %>
      <% end %>
    <% end %>
  <% end %>
<% end %>
```

#### Task List Table
```erb
<%= ui.table do |table| %>
  <% table.head do %>
    <% table.tr do %>
      <% table.th %>Task<% end %>
      <% table.th %>Assigned To<% end %>
      <% table.th %>Priority<% end %>
      <% table.th %>Due Date<% end %>
      <% table.th %>Status<% end %>
    <% end %>
  <% end %>
  
  <% table.body do %>
    <% @tasks.each do |task| %>
      <% table.tr do %>
        <% table.td do %>
          <div>
            <div class="font-medium"><%= task.title %></div>
            <div class="text-sm text-gray-500"><%= task.project.name %></div>
          </div>
        <% end %>
        <% table.td do %>
          <div class="flex items-center gap-2">
            <img src="<%= task.assignee.avatar_url %>" class="h-6 w-6 rounded-full">
            <%= task.assignee.name %>
          </div>
        <% end %>
        <% table.td do %>
          <% priority_color = case task.priority
             when "high" then :danger
             when "medium" then :warning
             else :default
             end %>
          <%= ui.badge task.priority.capitalize, severity: priority_color %>
        <% end %>
        <% table.td %>
          <%= task.due_date&.strftime("%b %d, %Y") || "-" %>
        <% end %>
        <% table.td do %>
          <% status_color = case task.status
             when "completed" then :success
             when "in_progress" then :info
             else :default
             end %>
          <%= ui.badge task.status.humanize, severity: status_color %>
        <% end %>
      <% end %>
    <% end %>
  <% end %>
<% end %>
```

#### Sortable Table Headers
```erb
<%= ui.table data: { controller: "sortable-table" } do |table| %>
  <% table.head do %>
    <% table.tr do %>
      <% table.th do %>
        <%= link_to products_path(sort: "name"), 
            class: "flex items-center gap-1",
            data: { turbo_frame: "products" } do %>
          Name
          <%= ui.icon "chevron-up-down", size: :xs %>
        <% end %>
      <% end %>
      <% table.th do %>
        <%= link_to products_path(sort: "price"),
            class: "flex items-center gap-1",
            data: { turbo_frame: "products" } do %>
          Price
          <%= ui.icon "chevron-up-down", size: :xs %>
        <% end %>
      <% end %>
    <% end %>
  <% end %>
  
  <% table.body do %>
    <!-- table rows -->
  <% end %>
<% end %>
```