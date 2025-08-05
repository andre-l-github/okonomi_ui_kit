# Page Component Guide

The Page component provides a comprehensive layout system for building consistent, structured pages with headers, sections, and content organization capabilities.

## Basic Usage

#### Simple Page
```erb
<%= ui.page do |p| %>
  <% p.page_header do |h| %>
    <% h.row do |r| %>
      <% r.title "Welcome" %>
    <% end %>
  <% end %>
  
  <% p.section do |s| %>
    <% s.body do %>
      <p>Your content here</p>
    <% end %>
  <% end %>
<% end %>
```

#### Page with Breadcrumbs
```erb
<%= ui.page do |p| %>
  <% p.page_header do |h| %>
    <% h.breadcrumbs do |crumb| %>
      <% crumb.link "Home", root_path %>
      <% crumb.link "Products", products_path %>
      <% crumb.link @product.name, product_path(@product), current: true %>
    <% end %>
    <% h.row do |r| %>
      <% r.title @product.name %>
    <% end %>
  <% end %>
<% end %>
```

#### Page with Actions
```erb
<%= ui.page do |p| %>
  <% p.page_header do |h| %>
    <% h.row do |r| %>
      <% r.title "Users" %>
      <% r.actions do %>
        <%= ui.button_to "New User", new_user_path, variant: :contained, color: :primary %>
        <%= ui.button_to "Export", export_users_path, variant: :outlined %>
      <% end %>
    <% end %>
  <% end %>
<% end %>
```

## Customization Options

The Page component uses a nested builder pattern with these available methods:

| Builder | Method | Purpose |
|---------|--------|---------|
| PageBuilder | page_header | Creates a page header with breadcrumbs and title row |
| PageBuilder | section | Creates content sections with optional titles and structured body |
| PageHeaderBuilder | breadcrumbs | Adds breadcrumb navigation |
| PageHeaderBuilder | row | Creates a title row with optional actions |
| PageHeaderRowBuilder | title | Sets the page title (h1 element) |
| PageHeaderRowBuilder | actions | Adds action buttons aligned to the right |
| SectionBuilder | title | Sets the section title (h3 element) |
| SectionBuilder | subtitle | Sets a descriptive subtitle |
| SectionBuilder | actions | Adds action buttons to the section header |
| SectionBuilder | body | Contains the main section content |
| SectionBuilder | attribute | Creates structured attribute displays within body |

## Advanced Features

#### Sections with Attributes
```erb
<%= ui.page do |p| %>
  <% p.section do |s| %>
    <% s.title "User Details" %>
    <% s.body do |b| %>
      <% b.attribute "Name", @user.name %>
      <% b.attribute "Email", @user.email %>
      <% b.attribute "Status" do %>
        <%= ui.badge(@user.status.humanize, severity: @user.active? ? :success : :danger) %>
      <% end %>
      <% b.attribute "Joined", @user.created_at.strftime("%B %d, %Y") %>
    <% end %>
  <% end %>
<% end %>
```

#### Multiple Sections
```erb
<%= ui.page do |p| %>
  <% p.page_header do |h| %>
    <% h.row do |r| %>
      <% r.title "Account Settings" %>
    <% end %>
  <% end %>
  
  <% p.section title: "Profile Information" do |s| %>
    <% s.subtitle "Update your personal details" %>
    <% s.body do %>
      <%= form_with model: @user do |f| %>
        <!-- form fields -->
      <% end %>
    <% end %>
  <% end %>
  
  <% p.section title: "Security" do |s| %>
    <% s.subtitle "Manage your password and authentication" %>
    <% s.actions do %>
      <%= ui.button_tag "Change Password", variant: :outlined %>
    <% end %>
    <% s.body do %>
      <!-- security settings -->
    <% end %>
  <% end %>
<% end %>
```

#### Custom Section Content
```erb
<%= ui.page do |p| %>
  <% p.section do |s| %>
    <% s.title "Activity Feed" %>
    <% s.body do %>
      <div class="space-y-4">
        <% @activities.each do |activity| %>
          <div class="border rounded-lg p-4">
            <h4 class="font-medium"><%= activity.title %></h4>
            <p class="text-sm text-gray-600"><%= activity.description %></p>
            <time class="text-xs text-gray-500"><%= activity.created_at %></time>
          </div>
        <% end %>
      </div>
    <% end %>
  <% end %>
<% end %>
```

#### Integration with Other Components
```erb
<%= ui.page do |p| %>
  <% p.page_header do |h| %>
    <% h.row do |r| %>
      <% r.title "Order Management" %>
      <% r.actions do %>
        <%= ui.dropdown_button "Actions", variant: :contained do |dropdown| %>
          <% dropdown.link "Export Orders", export_orders_path %>
          <% dropdown.link "Import Orders", import_orders_path %>
          <% dropdown.divider %>
          <% dropdown.link "Settings", order_settings_path %>
        <% end %>
      <% end %>
    <% end %>
  <% end %>
  
  <% p.section title: "Orders" do |s| %>
    <% s.body do %>
      <%= ui.table do |table| %>
        <% table.header do |header| %>
          <% header.column "Order #" %>
          <% header.column "Customer" %>
          <% header.column "Status" %>
          <% header.column "Total" %>
          <% header.column "Actions" %>
        <% end %>
        <% table.body do |body| %>
          <% @orders.each do |order| %>
            <% body.row do |row| %>
              <% row.cell order.number %>
              <% row.cell order.customer_name %>
              <% row.cell do %>
                <%= ui.badge(order.status.humanize, 
                             severity: order_status_severity(order.status)) %>
              <% end %>
              <% row.cell number_to_currency(order.total) %>
              <% row.cell do %>
                <%= ui.link_to "View", order_path(order), variant: :text, size: :sm %>
              <% end %>
            <% end %>
          <% end %>
        <% end %>
      <% end %>
    <% end %>
  <% end %>
<% end %>
```

## Styling

#### Default Styles

The Page component includes these default Tailwind classes:
- Root: `flex flex-col gap-8 p-8`

The PageHeader component styles:
- Root: `flex flex-col gap-2`
- Row: `flex w-full justify-between items-center`
- Actions: `mt-4 flex md:ml-4 md:mt-0 gap-2`

The PageSection component styles:
- Root: `overflow-hidden bg-white`
- Header: `py-6`
- Header with actions: `flex w-full justify-between items-start`
- Title: `text-base/7 font-semibold text-gray-900`
- Subtitle: `mt-1 max-w-2xl text-sm/6 text-gray-500`
- Actions: `mt-4 flex md:ml-4 md:mt-0`
- Attribute list: `divide-y divide-gray-100`
- Attribute row: `py-6 sm:grid sm:grid-cols-3 sm:gap-4`
- Attribute label: `text-sm font-medium text-gray-900`
- Attribute value: `mt-1 text-sm/6 text-gray-700 sm:col-span-2 sm:mt-0`

#### Customizing Styles

You can customize the appearance by creating config classes for each component:

```ruby
# app/helpers/okonomi_ui_kit/configs/page.rb
module OkonomiUiKit
  module Configs
    class Page < OkonomiUiKit::Config
      register_styles :default do
        {
          root: "flex flex-col gap-6 p-6 max-w-7xl mx-auto"
        }
      end
    end
  end
end
```

Or pass custom classes directly:

```erb
<%= ui.page class: "custom-page-wrapper" do |p| %>
  <!-- page content -->
<% end %>
```

## Best Practices

1. **Consistent Structure**: Always use page headers for main pages to maintain navigation consistency
2. **Meaningful Sections**: Group related content into sections with descriptive titles
3. **Breadcrumb Navigation**: Include breadcrumbs for deep navigation hierarchies
4. **Action Placement**: Place primary actions in the page header, secondary actions in sections
5. **Attribute Usage**: Use attributes for displaying read-only data in a structured format

## Accessibility

The page component maintains accessibility standards:
- Semantic HTML structure with proper heading hierarchy
- Breadcrumb navigation uses nav element with aria-label
- Proper heading levels (h1 for page title, h3 for sections)
- Definition lists for attribute displays
- Keyboard navigation support

## Examples in Context

#### Product Detail Page
```erb
<%= ui.page do |p| %>
  <% p.page_header do |h| %>
    <% h.breadcrumbs do |crumb| %>
      <% crumb.link "Store", store_path %>
      <% crumb.link "Products", products_path %>
      <% crumb.link @product.category, category_products_path(@product.category) %>
      <% crumb.link @product.name, product_path(@product), current: true %>
    <% end %>
    <% h.row do |r| %>
      <% r.title @product.name %>
      <% r.actions do %>
        <%= ui.button_to "Edit", edit_product_path(@product), variant: :contained %>
        <%= ui.button_to "Delete", product_path(@product), method: :delete, variant: :outlined, color: :danger %>
      <% end %>
    <% end %>
  <% end %>
  
  <% p.section title: "Product Information" do |s| %>
    <% s.body do |b| %>
      <% b.attribute "SKU", @product.sku %>
      <% b.attribute "Price", number_to_currency(@product.price) %>
      <% b.attribute "Stock" do %>
        <%= ui.badge(@product.in_stock? ? "In Stock" : "Out of Stock", 
                     severity: @product.in_stock? ? :success : :danger) %>
      <% end %>
      <% b.attribute "Category", @product.category %>
    <% end %>
  <% end %>
  
  <% p.section title: "Description" do |s| %>
    <% s.body do %>
      <div class="prose">
        <%= @product.description %>
      </div>
    <% end %>
  <% end %>
<% end %>
```

#### User Profile Page
```erb
<%= ui.page do |p| %>
  <% p.page_header do |h| %>
    <% h.row do |r| %>
      <% r.title "Profile Settings" %>
    <% end %>
  <% end %>
  
  <% p.section title: "Personal Information" do |s| %>
    <% s.subtitle "Update your personal details and preferences" %>
    <% s.actions do %>
      <%= ui.link_to "Edit", edit_profile_path, variant: :outlined %>
    <% end %>
    <% s.body do |b| %>
      <% b.attribute "Full Name", current_user.full_name %>
      <% b.attribute "Email", current_user.email %>
      <% b.attribute "Phone", current_user.phone || "Not provided" %>
      <% b.attribute "Time Zone", current_user.time_zone %>
      <% b.attribute "Member Since", current_user.created_at.strftime("%B %Y") %>
    <% end %>
  <% end %>
  
  <% p.section title: "Notifications" do |s| %>
    <% s.subtitle "Configure how you receive notifications" %>
    <% s.body do %>
      <%= form_with model: current_user, url: notifications_path do |f| %>
        <!-- notification preferences form -->
      <% end %>
    <% end %>
  <% end %>
<% end %>
```

#### Dashboard Page
```erb
<%= ui.page do |p| %>
  <% p.page_header do |h| %>
    <% h.row do |r| %>
      <% r.title "Dashboard" %>
      <% r.actions do %>
        <%= ui.button_tag "Download Report", variant: :outlined %>
      <% end %>
    <% end %>
  <% end %>
  
  <% p.section title: "Overview" do |s| %>
    <% s.subtitle "Key metrics for #{Date.current.strftime('%B %Y')}" %>
    <% s.body do %>
      <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        <!-- metric cards -->
      </div>
    <% end %>
  <% end %>
  
  <% p.section title: "Recent Activity" do |s| %>
    <% s.body do %>
      <%= ui.table do |table| %>
        <!-- activity table -->
      <% end %>
    <% end %>
  <% end %>
<% end %>
```

#### Settings Page with Multiple Sections
```erb
<%= ui.page do |p| %>
  <% p.page_header do |h| %>
    <% h.breadcrumbs do |crumb| %>
      <% crumb.link "Account", account_path %>
      <% crumb.link "Settings", settings_path, current: true %>
    <% end %>
    <% h.row do |r| %>
      <% r.title "Settings" %>
    <% end %>
  <% end %>
  
  <% p.section title: "Profile" do |s| %>
    <% s.subtitle "Manage your public profile information" %>
    <% s.actions do %>
      <%= ui.button_to "Edit Profile", edit_profile_path, variant: :outlined, size: :sm %>
    <% end %>
    <% s.body do |b| %>
      <% b.attribute "Display Name", current_user.display_name %>
      <% b.attribute "Bio", current_user.bio || "No bio provided" %>
      <% b.attribute "Profile URL" do %>
        <%= link_to user_url(current_user), user_url(current_user), 
                    class: "text-blue-600 hover:text-blue-500", target: "_blank" %>
      <% end %>
    <% end %>
  <% end %>
  
  <% p.section title: "Security" do |s| %>
    <% s.subtitle "Keep your account secure" %>
    <% s.body do |b| %>
      <% b.attribute "Password" do %>
        <div class="flex items-center justify-between">
          <span class="text-gray-500">Last changed <%= time_ago_in_words(current_user.password_changed_at) %> ago</span>
          <%= ui.button_tag "Change Password", variant: :outlined, size: :sm %>
        </div>
      <% end %>
      <% b.attribute "Two-Factor Authentication" do %>
        <div class="flex items-center justify-between">
          <%= ui.badge(current_user.two_factor_enabled? ? "Enabled" : "Disabled",
                       severity: current_user.two_factor_enabled? ? :success : :warning) %>
          <%= ui.button_tag current_user.two_factor_enabled? ? "Manage" : "Enable", 
                            variant: :outlined, size: :sm %>
        </div>
      <% end %>
      <% b.attribute "Active Sessions" do %>
        <%= link_to "View all sessions", sessions_path, 
                    class: "text-blue-600 hover:text-blue-500" %>
      <% end %>
    <% end %>
  <% end %>
  
  <% p.section title: "Privacy" do |s| %>
    <% s.subtitle "Control your privacy preferences" %>
    <% s.body do %>
      <%= form_with model: current_user.privacy_settings, url: privacy_settings_path do |f| %>
        <div class="space-y-4">
          <%= f.check_box :profile_public %>
          <%= f.label :profile_public, "Make my profile public" %>
          
          <%= f.check_box :show_email %>
          <%= f.label :show_email, "Display email on profile" %>
          
          <div class="pt-4">
            <%= f.submit "Save Privacy Settings", class: "btn btn-primary" %>
          </div>
        </div>
      <% end %>
    <% end %>
  <% end %>
<% end %>
```