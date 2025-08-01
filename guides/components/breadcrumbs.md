# Breadcrumbs Component Guide

The breadcrumbs component provides a navigational aid that shows users their current location within a website's hierarchy and enables navigation to parent pages.

## Basic Usage

### Simple Breadcrumbs

```erb
<%= ui.breadcrumbs do |crumb| %>
  <% crumb.link("Home", root_path) %>
  <% crumb.link("Products", products_path) %>
  <% crumb.link("Electronics", electronics_path) %>
<% end %>
```

### Marking Current Page

The last item in breadcrumbs typically represents the current page and should not be a link:

```erb
<%= ui.breadcrumbs do |crumb| %>
  <% crumb.link("Home", root_path) %>
  <% crumb.link("Products", products_path) %>
  <% crumb.link("iPhone 15", product_path(@product), current: true) %>
<% end %>
```

### Without Link for Current Page

You can also omit the path for the current page:

```erb
<%= ui.breadcrumbs do |crumb| %>
  <% crumb.link("Home", root_path) %>
  <% crumb.link("Settings", settings_path) %>
  <% crumb.link("Profile", nil, current: true) %>
<% end %>
```

## Advanced Features

### Adding Icons

You can add an icon to the first breadcrumb item (typically the home link):

```erb
<%= ui.breadcrumbs do |crumb| %>
  <% home_icon = ui.icon("home", class: "h-5 w-5 text-gray-400") %>
  <% crumb.link("Home", root_path, icon: home_icon) %>
  <% crumb.link("Dashboard", dashboard_path) %>
<% end %>
```

### Within Page Headers

Breadcrumbs are commonly used within page headers:

```erb
<%= ui.page do |page| %>
  <% page.page_header do |header| %>
    <% header.breadcrumbs do |crumb| %>
      <% crumb.link("Dashboard", dashboard_path) %>
      <% crumb.link("Projects", projects_path) %>
      <% crumb.link(@project.name, nil, current: true) %>
    <% end %>
    
    <% header.row do |row| %>
      <% row.title(@project.name) %>
      <% row.actions do %>
        <%= ui.button("Edit", edit_project_path(@project), variant: :secondary) %>
      <% end %>
    <% end %>
  <% end %>
<% end %>
```

## Styling

The breadcrumbs component uses semantic HTML and includes:
- A `<nav>` element with `aria-label="Breadcrumb"` for accessibility
- An ordered list (`<ol>`) with `role="list"`
- Chevron separators between items
- `aria-current="page"` on the current page item

### Default Styles

The component includes these default Tailwind classes:
- Navigation container with proper spacing
- Flex layout for horizontal alignment
- Gray text for non-current items
- Darker text for the current item
- Hover states for interactive links
- Chevron icons as separators

### Customizing Styles

You can customize the breadcrumbs appearance by overriding the registered styles:

```ruby
# In your component or initializer
OkonomiUiKit::Components::Breadcrumbs.register_styles :custom do
  {
    base: "flex",
    nav: "mb-4",
    list: "flex items-center space-x-2",
    link: {
      base: "text-sm text-blue-600 hover:text-blue-800",
      current: "text-sm text-gray-900 font-medium"
    }
  }
end
```

## Best Practices

1. **Keep it Simple**: Limit breadcrumbs to 3-5 levels for better usability
2. **Clear Labels**: Use descriptive, concise labels that match page titles
3. **Current Page**: Always mark the current page appropriately
4. **Home Link**: Consider using a home icon for the first item
5. **Consistent Placement**: Place breadcrumbs in the same location across pages

## Accessibility

The breadcrumbs component is built with accessibility in mind:
- Uses semantic HTML elements (`<nav>`, `<ol>`)
- Includes `aria-label` for screen readers
- Marks the current page with `aria-current="page"`
- Separators are marked with `aria-hidden="true"`

## Examples

### E-commerce Product Page

```erb
<%= ui.breadcrumbs do |crumb| %>
  <% crumb.link("Shop", shop_path) %>
  <% crumb.link(@category.name, category_path(@category)) %>
  <% crumb.link(@subcategory.name, subcategory_path(@subcategory)) %>
  <% crumb.link(@product.name, nil, current: true) %>
<% end %>
```

### Admin Dashboard

```erb
<%= ui.breadcrumbs do |crumb| %>
  <% admin_icon = ui.icon("cog", class: "h-5 w-5") %>
  <% crumb.link("Admin", admin_root_path, icon: admin_icon) %>
  <% crumb.link("Users", admin_users_path) %>
  <% crumb.link("Edit User", nil, current: true) %>
<% end %>
```

### Multi-tenant Application

```erb
<%= ui.breadcrumbs do |crumb| %>
  <% crumb.link(@organization.name, organization_path(@organization)) %>
  <% crumb.link("Projects", organization_projects_path(@organization)) %>
  <% crumb.link(@project.name, project_path(@project)) %>
  <% crumb.link("Settings", nil, current: true) %>
<% end %>
```