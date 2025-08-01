# SVG Icon System

The SVG Icon System provides a consistent, performant way to use icons throughout the application. It loads SVG icons from the asset pipeline and provides proper optimization and styling support.

## Overview

The icon system offers:
- **Performance**: Icons are optimized and cached through the asset pipeline
- **Consistency**: Standardized icon library across the application
- **Flexibility**: Full CSS styling support with classes and attributes
- **Maintainability**: Centralized icon management
- **Accessibility**: Proper ARIA support and semantic usage

## Basic Usage

Always use the `svg_icon` helper instead of inlining SVG content:

```erb
<!-- Basic icon -->
<%= svg_icon("heroicons/outline/user") %>

<!-- Icon with styling -->
<%= svg_icon("heroicons/outline/home", class: "h-6 w-6 text-blue-500") %>

<!-- Icon with custom attributes -->
<%= svg_icon("heroicons/outline/search", width: "24", height: "24", class: "text-gray-400") %>
```

## Icon Organization

Icons are stored in `app/assets/images/` and organized by icon set:

```
app/assets/images/
├── heroicons/
│   ├── outline/          # Outline versions (recommended for UI)
│   │   ├── user.svg
│   │   ├── home.svg
│   │   ├── search.svg
│   │   ├── plus.svg
│   │   ├── trash.svg
│   │   └── ...
│   ├── solid/           # Solid filled versions
│   │   ├── user.svg
│   │   ├── home.svg
│   │   └── ...
│   └── mini/            # Small versions (16px)
│       ├── user.svg
│       ├── home.svg
│       └── ...
└── custom/              # Application-specific icons
    ├── logo.svg
    └── brand-icon.svg
```

## Available Icon Sets

### Heroicons (Primary Set)

The application primarily uses [Heroicons](https://heroicons.com/) for UI elements:

#### Outline Icons (Recommended)
- **Usage**: Primary UI elements, navigation, buttons
- **Style**: 24px, 1.5px stroke, outline style
- **Path**: `heroicons/outline/icon-name`

```erb
<%= svg_icon("heroicons/outline/user") %>
<%= svg_icon("heroicons/outline/cog-6-tooth") %>  <!-- Settings -->
<%= svg_icon("heroicons/outline/bell") %>         <!-- Notifications -->
```

#### Solid Icons
- **Usage**: Filled states, emphasis, small UI elements
- **Style**: 24px, filled style
- **Path**: `heroicons/solid/icon-name`

```erb
<%= svg_icon("heroicons/solid/star") %>           <!-- Filled star -->
<%= svg_icon("heroicons/solid/heart") %>          <!-- Filled heart -->
```

#### Mini Icons
- **Usage**: Very small UI elements, inline with text
- **Style**: 20px, filled style
- **Path**: `heroicons/mini/icon-name`

```erb
<%= svg_icon("heroicons/mini/check") %>           <!-- Small checkmark -->
<%= svg_icon("heroicons/mini/x-mark") %>          <!-- Small close -->
```

## Common Usage Patterns

### Navigation Icons

```erb
<!-- Main navigation -->
<%= svg_icon("heroicons/outline/home", class: "h-6 w-6") %>
<%= svg_icon("heroicons/outline/building-office-2", class: "h-6 w-6") %>  <!-- Manufacturers -->
<%= svg_icon("heroicons/outline/circle-stack", class: "h-6 w-6") %>       <!-- Datasets -->
<%= svg_icon("heroicons/outline/chart-pie", class: "h-6 w-6") %>          <!-- Reports -->

<!-- Sidebar navigation -->
<nav class="space-y-1">
  <%= link_to dashboard_path, class: "nav-link" do %>
    <%= svg_icon("heroicons/outline/home", class: "h-5 w-5 mr-3") %>
    Dashboard
  <% end %>
  <%= link_to users_path, class: "nav-link" do %>
    <%= svg_icon("heroicons/outline/user-group", class: "h-5 w-5 mr-3") %>
    Users  
  <% end %>
</nav>
```

### Button Icons

```erb
<!-- Primary actions -->
<%= link_to new_user_path, class: "button" do %>
  <%= svg_icon("heroicons/outline/plus", class: "h-4 w-4 mr-2") %>
  Add User
<% end %>

<!-- Secondary actions -->
<%= link_to edit_path(record), class: "button-outline" do %>
  <%= svg_icon("heroicons/outline/pencil", class: "h-4 w-4 mr-2") %>
  Edit
<% end %>

<!-- Danger actions -->
<%= link_to delete_path(record), method: :delete, class: "button-danger" do %>
  <%= svg_icon("heroicons/outline/trash", class: "h-4 w-4 mr-2") %>
  Delete
<% end %>

<!-- Icon-only buttons -->
<%= button_to like_path(post), class: "icon-button" do %>
  <%= svg_icon("heroicons/outline/heart", class: "h-5 w-5") %>
  <span class="sr-only">Like post</span>
<% end %>
```

### Status Indicators

```erb
<!-- Success states -->
<%= svg_icon("heroicons/outline/check-circle", class: "h-5 w-5 text-green-500") %>

<!-- Warning states -->
<%= svg_icon("heroicons/outline/exclamation-triangle", class: "h-5 w-5 text-yellow-500") %>

<!-- Error states -->
<%= svg_icon("heroicons/outline/x-circle", class: "h-5 w-5 text-red-500") %>

<!-- Information -->
<%= svg_icon("heroicons/outline/information-circle", class: "h-5 w-5 text-blue-500") %>
```

### Form Elements

```erb
<!-- Search inputs -->
<div class="relative">
  <div class="absolute inset-y-0 left-0 flex items-center pl-3">
    <%= svg_icon("heroicons/outline/magnifying-glass", class: "h-5 w-5 text-gray-400") %>
  </div>
  <%= text_field_tag :search, params[:search], class: "input pl-10", placeholder: "Search..." %>
</div>

<!-- Input validation -->
<div class="mt-1 flex items-center">
  <%= svg_icon("heroicons/outline/exclamation-circle", class: "h-5 w-5 text-red-500 mr-2") %>
  <span class="text-sm text-red-600">This field is required</span>
</div>
```

### Empty States

```erb
<!-- No data states -->
<div class="text-center py-12">
  <%= svg_icon("heroicons/outline/document", class: "mx-auto h-12 w-12 text-gray-400") %>
  <h3 class="mt-4 text-lg font-medium text-gray-900">No documents</h3>
  <p class="mt-2 text-sm text-gray-500">Get started by creating a new document.</p>
</div>

<!-- No results states -->
<div class="text-center py-8">
  <%= svg_icon("heroicons/outline/magnifying-glass", class: "mx-auto h-8 w-8 text-gray-400") %>
  <p class="mt-2 text-sm text-gray-500">No results found for your search.</p>
</div>
```

### Table Integration

Icons work seamlessly with the table builder:

```erb
<%= table do |t| %>
  <%= t.head do %>
    <%= t.tr do %>
      <%= t.th { "Status" } %>
      <%= t.th { "Actions" } %>
    <% end %>
  <% end %>
  
  <%= t.body do %>
    <% records.each do |record| %>
      <%= t.tr do %>
        <%= t.td(align: :center) do %>
          <% if record.active? %>
            <%= svg_icon("heroicons/solid/check-circle", class: "h-5 w-5 text-green-500") %>
          <% else %>
            <%= svg_icon("heroicons/outline/x-circle", class: "h-5 w-5 text-gray-400") %>
          <% end %>
        <% end %>
        
        <%= t.td(align: :right) do %>
          <%= link_to edit_path(record) do %>
            <%= svg_icon("heroicons/outline/pencil", class: "h-4 w-4") %>
            <span class="sr-only">Edit <%= record.name %></span>
          <% end %>
        <% end %>
      <% end %>
    <% end %>
  <% end %>
<% end %>
```

## Styling and Sizing

### Standard Sizes

Use consistent sizing classes throughout the application:

```erb
<!-- Very small (16px) -->
<%= svg_icon("heroicons/mini/check", class: "h-4 w-4") %>

<!-- Small (20px) -->
<%= svg_icon("heroicons/outline/user", class: "h-5 w-5") %>

<!-- Medium (24px) - Default -->
<%= svg_icon("heroicons/outline/home", class: "h-6 w-6") %>

<!-- Large (32px) -->
<%= svg_icon("heroicons/outline/cog", class: "h-8 w-8") %>

<!-- Extra Large (48px) -->
<%= svg_icon("heroicons/outline/document", class: "h-12 w-12") %>
```

### Color Variations

Apply semantic colors using Tailwind classes:

```erb
<!-- Neutral colors -->
<%= svg_icon("heroicons/outline/user", class: "h-6 w-6 text-gray-400") %>
<%= svg_icon("heroicons/outline/user", class: "h-6 w-6 text-gray-600") %>

<!-- Semantic colors -->
<%= svg_icon("heroicons/outline/check", class: "h-6 w-6 text-green-500") %>    <!-- Success -->
<%= svg_icon("heroicons/outline/exclamation-triangle", class: "h-6 w-6 text-yellow-500") %> <!-- Warning -->
<%= svg_icon("heroicons/outline/x-circle", class: "h-6 w-6 text-red-500") %>   <!-- Error -->
<%= svg_icon("heroicons/outline/information-circle", class: "h-6 w-6 text-blue-500") %> <!-- Info -->

<!-- Brand colors -->
<%= svg_icon("heroicons/outline/star", class: "h-6 w-6 text-indigo-500") %>
<%= svg_icon("heroicons/outline/heart", class: "h-6 w-6 text-pink-500") %>
```

### Interactive States

Icons can respond to hover and focus states:

```erb
<!-- Hover states -->
<%= link_to "#", class: "p-2 rounded hover:bg-gray-100" do %>
  <%= svg_icon("heroicons/outline/heart", class: "h-5 w-5 text-gray-400 group-hover:text-red-500") %>
<% end %>

<!-- Button with icon state changes -->
<%= button_to favorite_path(item), class: "favorite-button group" do %>
  <%= svg_icon("heroicons/outline/heart", class: "h-5 w-5 text-gray-400 group-hover:text-red-500") %>
  <span class="ml-2">Add to favorites</span>
<% end %>
```

## Integration with Components

### Page Builder Integration

Icons work seamlessly within the page builder system:

```erb
<%= ui.page do |p| %>
  <%= p.page_header do |h| %>
    <% h.row do |r| %>
      <% r.title "Dashboard" %>
      <% r.actions do %>
        <%= link_to new_item_path, class: "button" do %>
          <%= svg_icon("heroicons/outline/plus", class: "h-4 w-4 mr-2") %>
          New Item
        <% end %>
      <% end %>
    <% end %>
  <% end %>
  
  <%= p.section do |s| %>
    <% s.title "Quick Actions" %>
    <% s.body do %>
      <div class="grid grid-cols-2 gap-4">
        <%= link_to users_path, class: "action-card" do %>
          <%= svg_icon("heroicons/outline/user-group", class: "h-8 w-8 mb-2") %>
          <span>Manage Users</span>
        <% end %>
        <%= link_to reports_path, class: "action-card" do %>
          <%= svg_icon("heroicons/outline/chart-bar", class: "h-8 w-8 mb-2") %>
          <span>View Reports</span>
        <% end %>
      </div>
    <% end %>
  <% end %>
<% end %>
```

### Badge Integration

Icons can be used within badges for enhanced meaning:

```erb
<!-- Status badges with icons -->
<%= ui.badge("Active", :success) do %>
  <%= svg_icon("heroicons/mini/check-circle", class: "h-3 w-3 mr-1") %>
  Active
<% end %>

<%= ui.badge("Pending", :warning) do %>
  <%= svg_icon("heroicons/mini/clock", class: "h-3 w-3 mr-1") %>
  Pending
<% end %>
```

## Accessibility

### Screen Reader Support

Always provide proper accessibility for icons:

```erb
<!-- Decorative icons (no meaning) -->
<%= svg_icon("heroicons/outline/star", class: "h-4 w-4", "aria-hidden": "true") %>

<!-- Meaningful icons with labels -->
<%= button_to like_path(post) do %>
  <%= svg_icon("heroicons/outline/heart", class: "h-5 w-5") %>
  <span class="sr-only">Like this post</span>
<% end %>

<!-- Icons with visible text -->
<%= link_to new_user_path do %>
  <%= svg_icon("heroicons/outline/plus", class: "h-4 w-4 mr-2") %>
  Add User  <!-- Text provides context -->
<% end %>

<!-- Icons as status indicators -->
<%= svg_icon("heroicons/solid/check-circle", 
             class: "h-5 w-5 text-green-500", 
             "aria-label": "Completed") %>
```

### Focus States

Ensure interactive icons have proper focus states:

```erb
<%= link_to edit_path(record), class: "icon-link focus:outline-none focus:ring-2 focus:ring-blue-500" do %>
  <%= svg_icon("heroicons/outline/pencil", class: "h-4 w-4") %>
  <span class="sr-only">Edit <%= record.name %></span>
<% end %>
```

## Best Practices

### 1. Always Use the Helper

Never inline SVG XML directly in templates:

```erb
<!-- ✅ Good -->
<%= svg_icon("heroicons/outline/user", class: "h-6 w-6") %>

<!-- ❌ Bad -->
<svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
  <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 6a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0zM4.501 20.118a7.5 7.5 0 0114.998 0A17.933 17.933 0 0112 21.75c-2.676 0-5.216-.584-7.499-1.632z" />
</svg>
```

### 2. Use Consistent Sizing

Stick to standard size classes for consistency:

```erb
<!-- ✅ Good - Standard sizes -->
<%= svg_icon("heroicons/outline/home", class: "h-4 w-4") %>  <!-- 16px -->
<%= svg_icon("heroicons/outline/home", class: "h-5 w-5") %>  <!-- 20px -->
<%= svg_icon("heroicons/outline/home", class: "h-6 w-6") %>  <!-- 24px -->

<!-- ❌ Bad - Custom sizes -->
<%= svg_icon("heroicons/outline/home", width: "23", height: "23") %>
```

### 3. Choose Appropriate Icon Styles

- **Outline**: Primary UI, navigation, buttons
- **Solid**: Emphasis, filled states, small UI elements  
- **Mini**: Inline with text, very small spaces

```erb
<!-- ✅ Good style choices -->
<%= svg_icon("heroicons/outline/user", class: "h-6 w-6") %>      <!-- UI element -->
<%= svg_icon("heroicons/solid/star", class: "h-5 w-5") %>        <!-- Filled state -->
<%= svg_icon("heroicons/mini/check", class: "h-4 w-4") %>        <!-- Small indicator -->
```

### 4. Use Semantic Colors

Apply colors that convey meaning:

```erb
<!-- ✅ Good semantic usage -->
<%= svg_icon("heroicons/outline/check-circle", class: "h-5 w-5 text-green-500") %>  <!-- Success -->
<%= svg_icon("heroicons/outline/x-circle", class: "h-5 w-5 text-red-500") %>        <!-- Error -->
<%= svg_icon("heroicons/outline/information-circle", class: "h-5 w-5 text-blue-500") %> <!-- Info -->

<!-- ❌ Bad - Misleading colors -->
<%= svg_icon("heroicons/outline/check-circle", class: "h-5 w-5 text-red-500") %>    <!-- Confusing -->
```

### 5. Provide Accessibility

Always consider screen reader users:

```erb
<!-- ✅ Good accessibility -->
<%= button_to delete_path(record), method: :delete do %>
  <%= svg_icon("heroicons/outline/trash", class: "h-4 w-4") %>
  <span class="sr-only">Delete <%= record.name %></span>
<% end %>

<!-- ❌ Bad - No context for screen readers -->
<%= button_to delete_path(record), method: :delete do %>
  <%= svg_icon("heroicons/outline/trash", class: "h-4 w-4") %>
<% end %>
```

## Common Icon Reference

### Navigation & UI
- `heroicons/outline/home` - Home/Dashboard
- `heroicons/outline/user-group` - Users/Teams
- `heroicons/outline/building-office-2` - Organizations/Companies
- `heroicons/outline/circle-stack` - Data/Databases
- `heroicons/outline/chart-pie` - Reports/Analytics
- `heroicons/outline/cog-6-tooth` - Settings/Configuration

### Actions
- `heroicons/outline/plus` - Add/Create
- `heroicons/outline/pencil` - Edit
- `heroicons/outline/trash` - Delete
- `heroicons/outline/eye` - View/Show
- `heroicons/outline/magnifying-glass` - Search
- `heroicons/outline/arrow-down-tray` - Download
- `heroicons/outline/arrow-up-tray` - Upload

### Status & Feedback
- `heroicons/solid/check-circle` - Success/Complete
- `heroicons/outline/x-circle` - Error/Failed
- `heroicons/outline/exclamation-triangle` - Warning
- `heroicons/outline/information-circle` - Information
- `heroicons/outline/clock` - Pending/Time

### Content
- `heroicons/outline/document` - Documents/Files
- `heroicons/outline/folder` - Folders/Collections
- `heroicons/outline/photo` - Images/Media
- `heroicons/outline/chart-bar` - Charts/Data
- `heroicons/outline/table-cells` - Tables/Grids

This icon system provides a comprehensive foundation for consistent, accessible, and maintainable icon usage throughout the application.