# Navigation Component

The Navigation component provides a flexible way to create sidebar navigation menus with support for grouped links, icons, user initials, and profile sections. It's designed for building application sidebars with consistent styling and behavior.

## Basic Usage

The simplest way to use the Navigation component is with grouped links:

```erb
<%= ui.navigation do |nav| %>
  <% nav.group "Dashboard" do |group| %>
    <% group.nav_link "Overview", dashboard_path, icon: "home" %>
    <% group.nav_link "Analytics", analytics_path, icon: "chart-pie" %>
  <% end %>
<% end %>
```

## Features

### Grouped Links

Organize navigation links into logical groups with titles:

```erb
<%= ui.navigation do |nav| %>
  <% nav.group "Content" do |group| %>
    <% group.nav_link "Posts", posts_path, icon: "document-text" %>
    <% group.nav_link "Pages", pages_path, icon: "document" %>
    <% group.nav_link "Media", media_path, icon: "photograph" %>
  <% end %>
  
  <% nav.group "Settings" do |group| %>
    <% group.nav_link "General", settings_path, icon: "cog" %>
    <% group.nav_link "Users", users_path, icon: "users" %>
  <% end %>
<% end %>
```

### Icons

Navigation links support icons from the Heroicons library:

```erb
<% group.nav_link "Dashboard", dashboard_path, icon: "home" %>
<% group.nav_link "Reports", reports_path, icon: "chart-bar" %>
<% group.nav_link "Settings", settings_path, icon: "cog-6-tooth" %>
```

### User Initials

Display user initials instead of icons for project or user-specific links:

```erb
<% nav.group "Projects" do |group| %>
  <% group.nav_link "Marketing Site", project_path(1), initials: "MS" %>
  <% group.nav_link "Customer Portal", project_path(2), initials: "CP" %>
  <% group.nav_link "Admin Dashboard", project_path(3), initials: "AD" %>
<% end %>
```

### Profile Section

Add a profile section at the bottom of the navigation:

```erb
<%= ui.navigation do |nav| %>
  <% nav.group "Main" do |group| %>
    <% group.nav_link "Dashboard", dashboard_path, icon: "home" %>
  <% end %>
  
  <% nav.profile_section do %>
    <div class="flex items-center gap-x-4 px-6 py-3 text-sm/6 font-semibold text-gray-900 hover:bg-gray-50">
      <%= image_tag current_user.avatar_url, class: "size-8 rounded-full", alt: "" %>
      <span><%= current_user.name %></span>
    </div>
  <% end %>
<% end %>
```

### Active Link Detection

The Navigation component uses the `active_link_to` helper to automatically highlight the current page:

```erb
# Exact matching (only highlights when on exact path)
<% group.nav_link "Dashboard", dashboard_path, icon: "home", exact: true %>

# Inclusive matching (highlights for path and sub-paths)
<% group.nav_link "Settings", settings_path, icon: "cog", exact: false %>
```

## Complete Example

Here's a complete sidebar navigation example:

```erb
<div class="flex h-full flex-col bg-gray-900 px-6">
  <div class="flex h-16 shrink-0 items-center">
    <%= image_tag "logo.svg", class: "h-8 w-auto", alt: "Your Company" %>
  </div>
  
  <nav class="flex flex-1 flex-col">
    <%= ui.navigation do |nav| %>
      <% nav.group "Dashboard" do |group| %>
        <% group.nav_link "Overview", dashboard_path, icon: "home", exact: true %>
        <% group.nav_link "Analytics", analytics_dashboard_path, icon: "chart-pie" %>
        <% group.nav_link "Reports", reports_dashboard_path, icon: "document-chart-bar" %>
      <% end %>
      
      <% nav.group "Content" do |group| %>
        <% group.nav_link "Posts", posts_path, icon: "document-text" %>
        <% group.nav_link "Pages", pages_path, icon: "document" %>
        <% group.nav_link "Media Library", media_path, icon: "photograph" %>
      <% end %>
      
      <% nav.group "Team" do |group| %>
        <% group.nav_link "Members", team_members_path, icon: "users" %>
        <% group.nav_link "Invitations", invitations_path, icon: "mail" %>
        <% group.nav_link "Settings", team_settings_path, icon: "cog-6-tooth" %>
      <% end %>
      
      <% nav.profile_section do %>
        <a href="<%= profile_path %>" class="flex items-center gap-x-4 px-6 py-3 text-sm/6 font-semibold text-white hover:bg-gray-800">
          <%= image_tag current_user.avatar_url, class: "size-8 rounded-full", alt: "" %>
          <span><%= current_user.name %></span>
        </a>
      <% end %>
    <% end %>
  </nav>
</div>
```

## Customization

### Theme Configuration

Customize the Navigation component styles through the theme system:

```ruby
# config/initializers/okonomi_ui_kit.rb
Rails.application.config.after_initialize do
  OkonomiUiKit::Theme::DEFAULT_THEME.deep_merge!({
    components: {
      navigation: {
        menu: {
          base: "flex flex-1 flex-col gap-y-5" # Adjust spacing
        },
        group: {
          title: "text-xs font-bold uppercase text-gray-500", # Different title style
          list: "-mx-3 mt-3 space-y-2" # Adjust group spacing
        },
        link: {
          base: "group flex gap-x-3 rounded-lg px-3 py-2 text-sm font-medium hover:bg-gray-100",
          active: "bg-blue-50 text-blue-700 hover:bg-blue-100",
          icon: "size-5 text-gray-500 group-hover:text-gray-700"
        }
      }
    }
  })
end
```

### Custom Styling

You can pass custom classes to individual elements:

```erb
<%= ui.navigation class: "custom-nav-class" do |nav| %>
  <!-- navigation content -->
<% end %>
```

## Best Practices

1. **Group Related Links**: Organize navigation items into logical groups for better user experience
2. **Use Descriptive Icons**: Choose icons that clearly represent the link's destination
3. **Keep Groups Small**: Limit each group to 3-5 items for better scanability
4. **Active State**: Use `exact: true` for root paths to prevent multiple items from being highlighted
5. **Responsive Design**: Consider hiding labels on mobile and showing only icons
6. **Accessibility**: The component includes proper ARIA attributes and semantic HTML

## API Reference

### Navigation Methods

- `nav.group(title, &block)` - Creates a navigation group with the given title
- `nav.profile_section(&block)` - Creates a profile section at the bottom

### Group Methods

- `group.nav_link(title, path, options = {})` - Adds a navigation link
  - `icon:` - Icon name from Heroicons (optional)
  - `initials:` - Text initials to display (optional)
  - `exact:` - Use exact path matching for active state (default: false)

## Related Components

- [Icon](./icon.md) - For available icon names and usage
- [Typography](./typography.md) - For text styling within navigation
- [Page](./page.md) - For page layouts that work well with sidebar navigation