# PageSection Component Guide

The PageSection component provides a flexible container for organizing page content into distinct sections with optional titles, subtitles, actions, and structured attribute displays.

## Basic Usage

#### Simple Section
```erb
<%= ui.page_section do |section| %>
  <% section.body do %>
    <p>Your content goes here</p>
  <% end %>
<% end %>
```

#### Section with Title
```erb
<%= ui.page_section do |section| %>
  <% section.title "Account Information" %>
  <% section.body do %>
    <p>Manage your account details and preferences.</p>
  <% end %>
<% end %>
```

#### Using Title Option
```erb
<%= ui.page_section title: "Quick Stats" do |section| %>
  <% section.body do %>
    <div class="grid grid-cols-3 gap-4">
      <!-- stat cards -->
    </div>
  <% end %>
<% end %>
```

## Customization Options

The PageSection component uses a builder pattern with these methods:

| Method | Purpose |
|--------|---------|
| title | Sets the section title (h3 element) |
| subtitle | Adds descriptive text below the title |
| actions | Adds action buttons aligned to the right of the title |
| body | Contains the main section content |
| attribute | Creates structured attribute displays within the body |

## Advanced Features

#### Section with All Elements
```erb
<%= ui.page_section do |section| %>
  <% section.title "User Profile" %>
  <% section.subtitle "View and manage user information" %>
  <% section.actions do %>
    <%= ui.button_to "Edit", edit_user_path(@user), variant: :outlined %>
    <%= ui.button_tag "Export", variant: :ghost %>
  <% end %>
  <% section.body do |body| %>
    <% body.attribute "Name", @user.full_name %>
    <% body.attribute "Email", @user.email %>
    <% body.attribute "Role", @user.role.humanize %>
    <% body.attribute "Status" do %>
      <%= ui.badge(@user.active? ? "Active" : "Inactive", 
                   severity: @user.active? ? :success : :danger) %>
    <% end %>
  <% end %>
<% end %>
```

#### Mixed Content Section
```erb
<%= ui.page_section title: "Order Details" do |section| %>
  <% section.subtitle "Order ##{@order.number}" %>
  <% section.body do |body| %>
    <!-- Attributes section -->
    <% body.attribute "Date", @order.created_at.strftime("%B %d, %Y") %>
    <% body.attribute "Status", @order.status.humanize %>
    <% body.attribute "Total", number_to_currency(@order.total) %>
    
    <!-- Custom content after attributes -->
    <div class="mt-6">
      <h4 class="font-medium mb-4">Order Items</h4>
      <%= ui.table do |table| %>
        <!-- order items table -->
      <% end %>
    </div>
  <% end %>
<% end %>
```

#### Dynamic Attribute Display
```erb
<%= ui.page_section title: "System Information" do |section| %>
  <% section.body do |body| %>
    <% @system_info.each do |key, value| %>
      <% body.attribute key.humanize, value %>
    <% end %>
  <% end %>
<% end %>
```

## Styling

#### Default Styles

The PageSection component includes these default Tailwind classes:
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

You can customize the appearance by creating a config class:

```ruby
# app/helpers/okonomi_ui_kit/configs/page_section.rb
module OkonomiUiKit
  module Configs
    class PageSection < OkonomiUiKit::Config
      register_styles :default do
        {
          root: "bg-white shadow rounded-lg",
          header: "px-6 py-4 border-b",
          title: "text-lg font-medium text-gray-900",
          subtitle: "mt-1 text-sm text-gray-600",
          attribute_list: "divide-y divide-gray-200",
          attribute_row: "px-6 py-4 sm:grid sm:grid-cols-3 sm:gap-4"
        }
      end
    end
  end
end
```

## Best Practices

1. **Logical Grouping**: Use sections to group related content and functionality
2. **Clear Titles**: Provide descriptive titles that clearly indicate section content
3. **Subtitle Usage**: Use subtitles to provide additional context or instructions
4. **Attribute Consistency**: Use attributes for displaying read-only data in a consistent format
5. **Action Placement**: Include only directly related actions in the section header

## Accessibility

The PageSection component maintains accessibility standards:
- Uses semantic h3 elements for section titles
- Proper heading hierarchy within page structure
- Definition lists (dl, dt, dd) for attribute displays
- Keyboard accessible action buttons
- Clear visual hierarchy with consistent spacing

## Examples

#### User Settings Section
```erb
<%= ui.page_section title: "Personal Information" do |section| %>
  <% section.subtitle "Update your personal details" %>
  <% section.actions do %>
    <%= ui.button_to "Edit", edit_profile_path, variant: :outlined, size: :sm %>
  <% end %>
  <% section.body do |body| %>
    <% body.attribute "Full Name", current_user.full_name %>
    <% body.attribute "Email", current_user.email %>
    <% body.attribute "Phone", current_user.phone_number || "Not provided" %>
    <% body.attribute "Time Zone", current_user.time_zone %>
    <% body.attribute "Language", current_user.locale.upcase %>
    <% body.attribute "Two-Factor Auth" do %>
      <%= ui.badge(current_user.two_factor_enabled? ? "Enabled" : "Disabled",
                   severity: current_user.two_factor_enabled? ? :success : :warning) %>
    <% end %>
  <% end %>
<% end %>
```

#### Product Details Section
```erb
<%= ui.page_section class: "mt-6" do |section| %>
  <% section.title "Product Specifications" %>
  <% section.body do |body| %>
    <% body.attribute "SKU", @product.sku %>
    <% body.attribute "Weight", "#{@product.weight} kg" %>
    <% body.attribute "Dimensions", @product.dimensions %>
    <% body.attribute "Material", @product.material %>
    <% body.attribute "Country of Origin", @product.country_of_origin %>
    <% body.attribute "Warranty" do %>
      <span class="font-medium"><%= @product.warranty_period %></span>
      <%= link_to "View terms", warranty_path(@product), class: "ml-2 text-sm text-blue-600 hover:text-blue-500" %>
    <% end %>
  <% end %>
<% end %>
```

#### Activity Feed Section
```erb
<%= ui.page_section title: "Recent Activity" do |section| %>
  <% section.subtitle "Last 7 days" %>
  <% section.actions do %>
    <%= ui.link_to "View All", activities_path, variant: :text, size: :sm %>
  <% end %>
  <% section.body do %>
    <div class="space-y-4">
      <% @recent_activities.each do |activity| %>
        <div class="flex items-start space-x-3 py-4 border-b last:border-0">
          <div class="flex-shrink-0">
            <%= ui.icon activity.icon, size: :sm, class: "text-gray-400" %>
          </div>
          <div class="flex-1 min-w-0">
            <p class="text-sm text-gray-900"><%= activity.description %></p>
            <p class="text-xs text-gray-500 mt-1">
              <%= activity.user.name %> • 
              <%= time_ago_in_words(activity.created_at) %> ago
            </p>
          </div>
        </div>
      <% end %>
    </div>
  <% end %>
<% end %>
```

#### Form Section
```erb
<%= ui.page_section title: "Notification Preferences" do |section| %>
  <% section.subtitle "Choose how you want to be notified" %>
  <% section.body do %>
    <%= form_with model: current_user, url: notification_preferences_path do |f| %>
      <div class="space-y-4">
        <%= f.check_box :email_notifications %>
        <%= f.label :email_notifications, "Email notifications" %>
        
        <%= f.check_box :sms_notifications %>
        <%= f.label :sms_notifications, "SMS notifications" %>
        
        <%= f.check_box :push_notifications %>
        <%= f.label :push_notifications, "Push notifications" %>
        
        <div class="pt-4">
          <%= f.submit "Save Preferences", class: "btn btn-primary" %>
        </div>
      </div>
    <% end %>
  <% end %>
<% end %>
```

#### Stats Grid Section
```erb
<%= ui.page_section do |section| %>
  <% section.title "Performance Metrics" %>
  <% section.subtitle "Current month vs previous month" %>
  <% section.body do %>
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
      <% @metrics.each do |metric| %>
        <div class="bg-gray-50 rounded-lg p-6">
          <dt class="text-sm font-medium text-gray-500 truncate">
            <%= metric.name %>
          </dt>
          <dd class="mt-1">
            <div class="text-2xl font-semibold text-gray-900">
              <%= metric.value %>
            </div>
            <div class="flex items-center mt-2">
              <% if metric.change.positive? %>
                <%= ui.icon "arrow-up", size: :xs, class: "text-green-500" %>
                <span class="text-sm text-green-600 ml-1">
                  <%= metric.change %>%
                </span>
              <% else %>
                <%= ui.icon "arrow-down", size: :xs, class: "text-red-500" %>
                <span class="text-sm text-red-600 ml-1">
                  <%= metric.change.abs %>%
                </span>
              <% end %>
              <span class="text-sm text-gray-500 ml-2">vs last month</span>
            </div>
          </dd>
        </div>
      <% end %>
    </div>
  <% end %>
<% end %>
```