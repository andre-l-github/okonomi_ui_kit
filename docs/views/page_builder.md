# Page Builder System

The Page Builder is a comprehensive system of helpers and builders designed to create consistent, maintainable page layouts without writing repetitive HTML markup. It provides a semantic, component-based approach to building views.

## Overview

The Page Builder system consists of nested builders that handle different aspects of page layout:

- **`page`** - Root container for all page content
- **`page_header`** - Consistent page headers with breadcrumbs, titles, and actions
- **`section`** - Flexible content sections with titles, subtitles, and various body content
- **`attribute`** - Structured attribute display (within sections)

## Basic Usage

Every page should use the page builder as the root container:

```erb
<%= ui.page do |p| %>
  <!-- All page content goes here -->
<% end %>
```

## Page Header

The page header provides consistent structure for breadcrumbs, page titles, and action buttons.

### Basic Page Header

```erb
<%= ui.page do |p| %>
  <%= p.page_header do |h| %>
    <% h.breadcrumbs do |crumb| %>
      <% crumb.link "Home", root_path %>
      <% crumb.link "Products", products_path %>
      <% crumb.link "iPhone 15", product_path(@product), current: true %>
    <% end %>
    <% h.row do |r| %>
      <% r.title "iPhone 15" %>
    <% end %>
  <% end %>
<% end %>
```

### Page Header with Actions

```erb
<%= ui.page do |p| %>
  <%= p.page_header do |h| %>
    <% h.breadcrumbs do |crumb| %>
      <% crumb.link "Organisation", organisation_path(current_organisation) %>
      <% crumb.link "Products", organisation_products_path(current_organisation) %>
    <% end %>
    <% h.row do |r| %>
      <% r.title "Products" %>
      <% r.actions do %>
        <%= link_to "New Product", new_organisation_product_path(current_organisation), class: "button" %>
        <%= link_to "Import", import_organisation_products_path(current_organisation), class: "button-outline" %>
      <% end %>
    <% end %>
  <% end %>
<% end %>
```

## Sections

Sections are flexible containers that can hold any type of content. They provide consistent styling and optional headers.

### Basic Section

```erb
<%= ui.page do |p| %>
  <%= p.section do |s| %>
    <% s.title "Basic Information" %>
    <% s.body do %>
      <p>Any HTML content can go here.</p>
    <% end %>
  <% end %>
<% end %>
```

### Section with Subtitle

```erb
<%= ui.page do |p| %>
  <%= p.section do |s| %>
    <% s.title "User Settings" %>
    <% s.subtitle "Manage your account preferences and personal information." %>
    <% s.body do %>
      <!-- Content here -->
    <% end %>
  <% end %>
<% end %>
```

### Section with Actions

```erb
<%= ui.page do |p| %>
  <%= p.section do |s| %>
    <% s.title "Team Members" %>
    <% s.subtitle "Manage who has access to this organisation." %>
    <% s.actions do %>
      <%= link_to "Invite Member", new_invitation_path, class: "button" %>
      <%= link_to "Manage Roles", roles_path, class: "button-outline" %>
    <% end %>
    <% s.body do %>
      <!-- Team member table or list -->
    <% end %>
  <% end %>
<% end %>
```

## Attributes

Attributes provide a structured way to display key-value pairs within sections. They're perfect for detail pages, forms, and information displays.

### Basic Attributes

```erb
<%= ui.page do |p| %>
  <%= p.section do |s| %>
    <% s.title "Product Details" %>
    <% s.body do %>
      <%= s.attribute("Name", @product.name) %>
      <%= s.attribute("SKU", @product.sku) %>
      <%= s.attribute("Price", number_to_currency(@product.price)) %>
      <%= s.attribute("Category", @product.category.name) %>
    <% end %>
  <% end %>
<% end %>
```

### Attributes with Custom Content

```erb
<%= ui.page do |p| %>
  <%= p.section do |s| %>
    <% s.title "User Information" %>
    <% s.body do %>
      <%= s.attribute("Name", @user.display_name) %>
      <%= s.attribute("Email", @user.email) %>
      <%= s.attribute("Status") do %>
        <%= ui.badge(@user.active? ? "Active" : "Inactive", @user.active? ? :success : :danger) %>
      <% end %>
      <%= s.attribute("Last Login", l(@user.last_sign_in_at, format: :long)) %>
      <%= s.attribute("Profile Picture") do %>
        <% if @user.avatar.attached? %>
          <%= image_tag @user.avatar, class: "h-10 w-10 rounded-full" %>
        <% else %>
          <span class="text-gray-400">No image uploaded</span>
        <% end %>
      <% end %>
    <% end %>
  <% end %>
<% end %>
```

### Conditional Attributes

```erb
<%= ui.page do |p| %>
  <%= p.section do |s| %>
    <% s.title "Product Information" %>
    <% s.body do %>
      <%= s.attribute("Name", @product.name) %>
      <%= s.attribute("Description", @product.description) if @product.description.present? %>
      <% if @product.tags.any? %>
        <%= s.attribute("Tags") do %>
          <% @product.tags.each do |tag| %>
            <%= ui.badge(tag.name, :info) %>
          <% end %>
        <% end %>
      <% end %>
    <% end %>
  <% end %>
<% end %>
```

## Complex Content in Sections

Sections can contain any type of content, not just attributes.

### Tables in Sections

```erb
<%= ui.page do |p| %>
  <%= p.section do |s| %>
    <% s.title "Recent Orders" %>
    <% s.subtitle "Your most recent purchases and their status." %>
    <% s.actions do %>
      <%= link_to "View All", orders_path, class: "button-outline" %>
    <% end %>
    <% s.body do %>
      <%= table do |t| %>
        <%= t.head do %>
          <%= t.tr do %>
            <%= t.th { "Order #" } %>
            <%= t.th { "Date" } %>
            <%= t.th { "Status" } %>
            <%= t.th { "Total" } %>
          <% end %>
        <% end %>
        <%= t.body do %>
          <% @recent_orders.each do |order| %>
            <%= t.tr do %>
              <%= t.td { link_to order.number, order_path(order) } %>
              <%= t.td { l(order.created_at, format: :short) } %>
              <%= t.td { badge(order.status.humanize, order.status_color) } %>
              <%= t.td { number_to_currency(order.total) } %>
            <% end %>
          <% end %>
        <% end %>
      <% end %>
    <% end %>
  <% end %>
<% end %>
```

### Forms in Sections

```erb
<%= ui.page do |p| %>
  <%= p.section do |s| %>
    <% s.title "Account Settings" %>
    <% s.subtitle "Update your personal information and preferences." %>
    <% s.body do %>
      <%= form_with model: @user, local: true do |form| %>
        <div class="space-y-6">
          <div>
            <%= form.label :display_name, class: "block text-sm font-medium text-gray-700" %>
            <%= form.text_field :display_name, class: "mt-1 block w-full rounded-md border-gray-300" %>
          </div>
          
          <div>
            <%= form.label :email, class: "block text-sm font-medium text-gray-700" %>
            <%= form.email_field :email, class: "mt-1 block w-full rounded-md border-gray-300" %>
          </div>
          
          <div class="flex justify-end">
            <%= form.submit "Save Changes", class: "button" %>
          </div>
        </div>
      <% end %>
    <% end %>
  <% end %>
<% end %>
```

## Multiple Sections

Pages often contain multiple sections. Each section is independent and can have different content types.

```erb
<%= ui.page do |p| %>
  <%= p.page_header do |h| %>
    <% h.breadcrumbs do |crumb| %>
      <% crumb.link "Dashboard", root_path %>
      <% crumb.link "Profile", profile_path, current: true %>
    <% end %>
    <% h.row do |r| %>
      <% r.title "Profile" %>
      <% r.actions do %>
        <%= link_to "Edit Profile", edit_profile_path, class: "button" %>
      <% end %>
    <% end %>
  <% end %>

  <%= p.section do |s| %>
    <% s.title "Personal Information" %>
    <% s.subtitle "Your basic account details." %>
    <% s.body do %>
      <%= s.attribute("Full Name", current_user.display_name) %>
      <%= s.attribute("Email", current_user.email) %>
      <%= s.attribute("Member Since", l(current_user.created_at, format: :long)) %>
    <% end %>
  <% end %>

  <%= p.section do |s| %>
    <% s.title "Organisation Memberships" %>
    <% s.body do %>
      <%= table do |t| %>
        <!-- table content -->
      <% end %>
    <% end %>
  <% end %>

  <%= p.section do |s| %>
    <% s.title "Activity Log" %>
    <% s.subtitle "Recent actions and changes to your account." %>
    <% s.body do %>
      <!-- activity list -->
    <% end %>
  <% end %>
<% end %>
```

## Best Practices

### 1. Always Use the Page Builder

Every view should use the page builder as its root container. This ensures consistency across the application.

```erb
<!-- ✅ Good -->
<%= ui.page do |p| %>
  <!-- content -->
<% end %>

<!-- ❌ Bad -->
<div class="some-custom-wrapper">
  <!-- content -->
</div>
```

### 2. Use Consistent Header Structure

Always include breadcrumbs and a title in your page header.

```erb
<!-- ✅ Good -->
<%= p.page_header do |h| %>
  <% h.breadcrumbs do |crumb| %>
    <!-- breadcrumb items -->
  <% end %>
  <% h.row do |r| %>
    <% r.title "Page Title" %>
  <% end %>
<% end %>

<!-- ❌ Bad - Missing breadcrumbs -->
<%= p.page_header do |h| %>
  <% h.row do |r| %>
    <% r.title "Page Title" %>
  <% end %>
<% end %>
```

### 3. Group Related Information in Sections

Use sections to logically group related information. Don't put everything in one large section.

```erb
<!-- ✅ Good -->
<%= p.section do |s| %>
  <% s.title "Basic Information" %>
  <% s.body do %>
    <%= s.attribute("Name", @user.name) %>
    <%= s.attribute("Email", @user.email) %>
  <% end %>
<% end %>

<%= p.section do |s| %>
  <% s.title "Permissions" %>
  <% s.body do %>
    <%= s.attribute("Role", @user.role) %>
    <%= s.attribute("Admin", @user.admin?) %>
  <% end %>
<% end %>

<!-- ❌ Bad - Everything in one section -->
<%= p.section do |s| %>
  <% s.title "User Details" %>
  <% s.body do %>
    <%= s.attribute("Name", @user.name) %>
    <%= s.attribute("Email", @user.email) %>
    <%= s.attribute("Role", @user.role) %>
    <%= s.attribute("Admin", @user.admin?) %>
  <% end %>
<% end %>
```

### 4. Use Semantic Section Titles

Section titles should clearly describe the content and be helpful for users.

```erb
<!-- ✅ Good -->
<% s.title "Shipping Address" %>
<% s.title "Payment Methods" %>
<% s.title "Order History" %>

<!-- ❌ Bad -->
<% s.title "Information" %>
<% s.title "Details" %>
<% s.title "Data" %>
```

### 5. Use Helpers for Common Patterns

Always use the provided helpers like `badge()`, `l()`, and `svg_icon()` within your page builder content.

```erb
<!-- ✅ Good -->
<%= s.attribute("Status") do %>
  <%= ui.badge(@record.active? ? "Active" : "Inactive", @record.active? ? :success : :danger) %>
<% end %>
<%= s.attribute("Created", l(@record.created_at, format: :long)) %>

<!-- ❌ Bad -->
<%= s.attribute("Status") do %>
  <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
    Active
  </span>
<% end %>
<%= s.attribute("Created", @record.created_at.strftime("%B %d, %Y")) %>
```

## Migration Guide

### From Old Markup

**Before:**
```erb
<div class="flex flex-col gap-8">
  <div class="flex flex-col gap-2">
    <%= breadcrumbs do |crumb| %>
      <!-- breadcrumbs -->
    <% end %>
    <h1>Page Title</h1>
  </div>
  
  <div class="bg-white shadow rounded-lg">
    <div class="px-4 py-6">
      <h3>Section Title</h3>
      <!-- content -->
    </div>
  </div>
</div>
```

**After:**
```erb
<%= ui.page do |p| %>
  <%= p.page_header do |h| %>
    <% h.breadcrumbs do |crumb| %>
      <!-- breadcrumbs -->
    <% end %>
    <% h.row do |r| %>
      <% r.title "Page Title" %>
    <% end %>
  <% end %>
  
  <%= p.section do |s| %>
    <% s.title "Section Title" %>
    <% s.body do %>
      <!-- content -->
    <% end %>
  <% end %>
<% end %>
```

### From attribute_section Helper

**Before:**
```erb
<%= attribute_section(title: "Settings", description: "Configuration options") do |section| %>
  <%= section.attribute("Name", @record.name) %>
<% end %>
```

**After:**
```erb
<%= p.section do |s| %>
  <% s.title "Settings" %>
  <% s.subtitle "Configuration options" %>
  <% s.body do %>
    <%= s.attribute("Name", @record.name) %>
  <% end %>
<% end %>
```

## Extending the System

The page builder system is designed to be extended. You can add new methods to the builders or create additional builder classes for specific content types.

For example, to add a new content type to sections:

```ruby
# In SectionBuilder class
def custom_content_type(&block)
  @body_content = tag.div(class: "custom-content-wrapper") do
    capture(&block) if block_given?
  end
end
```

Then use it in views:

```erb
<%= p.section do |s| %>
  <% s.title "Custom Content" %>
  <% s.custom_content_type do %>
    <!-- Your custom content -->
  <% end %>
<% end %>
```

The system provides a solid foundation for consistent, maintainable views while remaining flexible enough for custom requirements.