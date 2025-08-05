# PageHeader Component Guide

The PageHeader component provides a structured way to create page headers with breadcrumb navigation, titles, and action buttons, offering consistent layout and styling across your application.

## Basic Usage

#### Simple Page Header
```erb
<%= ui.page_header do |header| %>
  <% header.row do |row| %>
    <% row.title "Dashboard" %>
  <% end %>
<% end %>
```

#### With Breadcrumbs
```erb
<%= ui.page_header do |header| %>
  <% header.breadcrumbs do |crumb| %>
    <% crumb.link "Home", root_path %>
    <% crumb.link "Settings", settings_path %>
    <% crumb.link "Profile", profile_settings_path, current: true %>
  <% end %>
  <% header.row do |row| %>
    <% row.title "Profile Settings" %>
  <% end %>
<% end %>
```

#### With Actions
```erb
<%= ui.page_header do |header| %>
  <% header.row do |row| %>
    <% row.title "Products" %>
    <% row.actions do %>
      <%= ui.button_to "New Product", new_product_path, variant: :contained, color: :primary %>
      <%= ui.button_tag "Export", variant: :outlined %>
    <% end %>
  <% end %>
<% end %>
```

## Customization Options

The PageHeader component uses a builder pattern with these available methods:

### PageHeaderBuilder Methods
| Method | Purpose |
|--------|---------|
| breadcrumbs | Adds breadcrumb navigation using the breadcrumbs component |
| row | Creates a title row with optional actions |

### PageHeaderRowBuilder Methods
| Method | Purpose |
|--------|---------|
| title | Sets the page title (renders as h1 typography) |
| actions | Adds action buttons aligned to the right |

## Advanced Features

#### Complete Header with All Elements
```erb
<%= ui.page_header do |header| %>
  <% header.breadcrumbs do |crumb| %>
    <% crumb.link "Admin", admin_path %>
    <% crumb.link "Users", admin_users_path %>
    <% crumb.link @user.name, admin_user_path(@user), current: true %>
  <% end %>
  
  <% header.row do |row| %>
    <% row.title @user.name %>
    <% row.actions do %>
      <%= ui.button_to "Edit", edit_admin_user_path(@user), variant: :contained %>
      <%= ui.button_to "Deactivate", deactivate_admin_user_path(@user), 
                       variant: :outlined, color: :danger, method: :post %>
      <%= ui.dropdown_button "More", variant: :ghost do |dropdown| %>
        <% dropdown.link "View Activity", admin_user_activities_path(@user) %>
        <% dropdown.link "Send Email", new_admin_user_email_path(@user) %>
        <% dropdown.divider %>
        <% dropdown.link "Delete", admin_user_path(@user), method: :delete, 
                         data: { confirm: "Are you sure?" } %>
      <% end %>
    <% end %>
  <% end %>
<% end %>
```

#### Dynamic Title with Status
```erb
<%= ui.page_header do |header| %>
  <% header.row do |row| %>
    <% row.title do %>
      <span class="flex items-center gap-2">
        <%= @project.name %>
        <%= ui.badge(@project.status.humanize, 
                     severity: @project.active? ? :success : :warning) %>
      </span>
    <% end %>
    <% row.actions do %>
      <%= ui.button_tag "Settings", variant: :outlined %>
    <% end %>
  <% end %>
<% end %>
```

#### Conditional Actions
```erb
<%= ui.page_header do |header| %>
  <% header.row do |row| %>
    <% row.title "Team Members" %>
    <% row.actions do %>
      <% if can?(:invite, Team) %>
        <%= ui.button_to "Invite Member", new_team_invitation_path, variant: :contained %>
      <% end %>
      <% if can?(:manage, Team) %>
        <%= ui.button_tag "Team Settings", variant: :outlined %>
      <% end %>
    <% end %>
  <% end %>
<% end %>
```

## Styling

#### Default Styles

The PageHeader component includes these default Tailwind classes:
- Root: `flex flex-col gap-2`
- Row: `flex w-full justify-between items-center`
- Actions: `mt-4 flex md:ml-4 md:mt-0 gap-2`

The title uses the Typography component with variant "h1" for consistent heading styles.

#### Customizing Styles

You can customize the appearance by creating a config class:

```ruby
# app/helpers/okonomi_ui_kit/configs/page_header.rb
module OkonomiUiKit
  module Configs
    class PageHeader < OkonomiUiKit::Config
      register_styles :default do
        {
          root: "flex flex-col gap-4 border-b pb-4",
          row: "flex w-full justify-between items-center",
          actions: "flex gap-3"
        }
      end
    end
  end
end
```

## Best Practices

1. **Consistent Structure**: Always include a title in the page header for clarity
2. **Breadcrumb Usage**: Include breadcrumbs for pages more than one level deep in navigation
3. **Action Grouping**: Group related actions and use dropdown menus for secondary actions
4. **Responsive Design**: The actions container adapts for mobile with margin adjustments
5. **Title Length**: Keep titles concise to prevent layout issues on smaller screens

## Accessibility

The PageHeader component is built with accessibility in mind:
- Uses semantic h1 element for the page title via the Typography component
- Breadcrumbs include proper navigation markup with aria-label
- Maintains logical heading hierarchy
- Action buttons are keyboard accessible
- Proper focus management for interactive elements

## Examples

#### E-commerce Product Management
```erb
<%= ui.page_header do |header| %>
  <% header.breadcrumbs do |crumb| %>
    <% crumb.link "Catalog", catalog_path %>
    <% crumb.link @product.category.name, category_products_path(@product.category) %>
    <% crumb.link @product.name, product_path(@product), current: true %>
  <% end %>
  
  <% header.row do |row| %>
    <% row.title @product.name %>
    <% row.actions do %>
      <%= ui.button_to "Edit Details", edit_product_path(@product), variant: :contained %>
      <%= ui.button_to "Manage Inventory", product_inventory_path(@product), variant: :outlined %>
      <%= ui.dropdown_button "More", variant: :ghost do |menu| %>
        <% menu.link "Duplicate", duplicate_product_path(@product), method: :post %>
        <% menu.link "Archive", archive_product_path(@product), method: :post %>
      <% end %>
    <% end %>
  <% end %>
<% end %>
```

#### Admin Dashboard
```erb
<%= ui.page_header do |header| %>
  <% header.row do |row| %>
    <% row.title "Admin Dashboard" %>
    <% row.actions do %>
      <%= ui.button_tag "Download Reports", variant: :outlined, 
                        data: { controller: "download" } %>
      <%= ui.button_to "System Settings", admin_settings_path, variant: :ghost %>
    <% end %>
  <% end %>
<% end %>
```

#### User Profile with Status
```erb
<%= ui.page_header class: "bg-gray-50 -m-8 p-8 mb-8" do |header| %>
  <% header.breadcrumbs do |crumb| %>
    <% crumb.link "Users", users_path %>
    <% crumb.link @user.department, department_users_path(@user.department) %>
    <% crumb.link @user.full_name, user_path(@user), current: true %>
  <% end %>
  
  <% header.row do |row| %>
    <% row.title do %>
      <div class="flex items-center gap-4">
        <%= image_tag @user.avatar_url, class: "h-12 w-12 rounded-full", 
                      alt: "#{@user.full_name}'s avatar" %>
        <div>
          <h1 class="text-2xl font-bold"><%= @user.full_name %></h1>
          <p class="text-sm text-gray-600"><%= @user.job_title %></p>
        </div>
      </div>
    <% end %>
    <% row.actions do %>
      <%= ui.button_to "Message", new_user_message_path(@user), variant: :contained %>
      <%= ui.button_to "View Activity", user_activities_path(@user), variant: :outlined %>
    <% end %>
  <% end %>
<% end %>
```