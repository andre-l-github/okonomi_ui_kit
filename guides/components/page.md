# Page Component Guide

The Page component provides a comprehensive system for building consistent, structured page layouts with headers, sections, and attribute displays.

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

The page component consists of several nested builders:

### Page Builder
- `page_header` - Creates a page header with breadcrumbs and title row
- `section` - Creates content sections with optional titles and structured body

### Page Header Builder
- `breadcrumbs` - Adds breadcrumb navigation
- `row` - Creates a title row with optional actions

### Section Builder
- `title` - Sets the section title
- `subtitle` - Sets a descriptive subtitle
- `actions` - Adds action buttons to the section header
- `body` - Contains the main section content
- `attribute` - Creates structured attribute displays

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

## Styling

#### Default Styles

The page component applies these default styles:
- Page header: `flex flex-col gap-2`
- Title: `text-2xl font-bold leading-7 text-gray-900 truncate sm:text-3xl sm:tracking-tight`
- Actions container: `mt-4 flex md:ml-4 md:mt-0 gap-2`
- Section: `overflow-hidden bg-white`
- Section title: `text-base/7 font-semibold text-gray-900`
- Section subtitle: `mt-1 max-w-2xl text-sm/6 text-gray-500`
- Attribute container: `divide-y divide-gray-100`
- Attribute label: `text-sm font-medium text-gray-900`
- Attribute value: `mt-1 text-sm/6 text-gray-700 sm:col-span-2 sm:mt-0`

#### Customizing Styles

Since the page component uses template rendering, customize styles by overriding the template or passing custom classes:

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

## Examples

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