# Link To Component Guide

The Link To component extends Rails' `link_to` helper with consistent styling options, allowing you to create links that match your button styles while maintaining semantic HTML.

## Basic Usage

#### Simple Link
```erb
<%= ui.link_to "Home", root_path %>
```

#### Link with Styling
```erb
<%= ui.link_to "View Details", product_path(@product), variant: :contained, color: :primary %>
<%= ui.link_to "Edit", edit_product_path(@product), variant: :outlined, color: :secondary %>
<%= ui.link_to "Cancel", products_path, variant: :text, color: :default %>
```

#### Link with Block Content
```erb
<%= ui.link_to product_path(@product), variant: :outlined do %>
  <span class="font-bold">View</span> Product Details
<% end %>
```

#### Link with Icons
```erb
# Icon at start (default position)
<%= ui.link_to "Home", root_path, icon: "heroicons/outline/home" %>

# Icon at end
<%= ui.link_to "Learn More", docs_path, icon: { end: "heroicons/outline/arrow-right" } %>

# Icon only link
<%= ui.link_to edit_path, icon: "heroicons/outline/pencil", variant: :contained, color: :primary %>
```

## Customization Options

| Option | Type/Values | Purpose |
|--------|-------------|---------|
| variant | :text, :contained, :outlined | Controls the link style (default: :text) |
| color | :default, :primary, :secondary, :success, :danger, :warning, :info | Sets the color scheme |
| icon | String or Hash | Adds an icon (string defaults to start, hash can specify :start or :end) |
| class | String | Additional CSS classes |
| id | String | HTML id attribute |
| data | Hash | Data attributes for Turbo/Stimulus |
| target | String | Link target (e.g., "_blank") |
| rel | String | Link relationship (e.g., "noopener") |

## Advanced Features

#### External Links
```erb
<%= ui.link_to "Documentation", "https://docs.example.com", 
    target: "_blank", 
    rel: "noopener",
    variant: :outlined,
    color: :info %>
```

#### Links with Turbo Attributes
```erb
<%= ui.link_to "Load More", 
    load_more_path,
    data: { 
      turbo_frame: "results",
      turbo_action: "advance"
    },
    variant: :contained,
    color: :primary %>
```

#### Disabled-Looking Links
```erb
<%= ui.link_to "Unavailable", "#", 
    class: "opacity-50 cursor-not-allowed",
    data: { turbo: false },
    variant: :outlined,
    color: :default %>
```

## Styling

#### Default Styles

The link to component inherits all styles from ButtonBase:
- Text variant (default): Simple text styling with hover underline
- Contained variant: Full background with button-like appearance
- Outlined variant: Border with transparent background

Base styling includes:
- Cursor pointer on hover
- Text size of `text-sm`
- Focus states with ring
- Color-specific hover states

#### Customizing Styles

You can customize the appearance by creating a custom config:

```ruby
# app/helpers/okonomi_ui_kit/configs/link_to.rb
module OkonomiUiKit
  module Configs
    class LinkTo < OkonomiUiKit::Config
      register_styles :custom do
        {
          text: {
            root: "font-medium transition-colors duration-200",
            colors: {
              primary: "text-blue-600 hover:text-blue-800 hover:no-underline"
            }
          },
          contained: {
            root: "inline-flex items-center px-4 py-2 rounded-lg no-underline",
            colors: {
              primary: "bg-blue-600 text-white hover:bg-blue-700"
            }
          }
        }
      end
    end
  end
end
```

Then register and use your custom style:

```ruby
# In an initializer or component
OkonomiUiKit::Components::LinkTo.use_config(:custom)
```

## Best Practices

1. **Semantic Usage**: Use links for navigation, buttons for actions
2. **Visual Hierarchy**: Reserve contained variant for primary navigation actions
3. **External Links**: Always use `target="_blank"` with `rel="noopener"` for external links
4. **Descriptive Text**: Use clear, action-oriented link text
5. **Accessibility**: Ensure links have sufficient color contrast and focus indicators

## Accessibility

The link to component maintains web accessibility standards:
- Uses semantic `<a>` elements
- Preserves all standard link behaviors
- Supports keyboard navigation
- Maintains focus states
- Works with screen readers
- Respects user preferences for reduced motion

## Examples

#### Navigation Menu
```erb
<nav class="flex items-center gap-4">
  <%= ui.link_to "Dashboard", dashboard_path, variant: :text, color: :default %>
  <%= ui.link_to "Products", products_path, variant: :text, color: :default %>
  <%= ui.link_to "Orders", orders_path, variant: :text, color: :default %>
  <%= ui.link_to "Settings", settings_path, variant: :text, color: :default %>
</nav>
```

#### Call-to-Action Links
```erb
<div class="hero-section text-center py-12">
  <h1 class="text-4xl font-bold mb-4">Welcome to Our Platform</h1>
  <p class="text-xl mb-8">Start your journey today</p>
  <div class="flex justify-center gap-4">
    <%= ui.link_to "Get Started", signup_path, variant: :contained, color: :primary, class: "px-6 py-3" %>
    <%= ui.link_to "Learn More", about_path, variant: :outlined, color: :primary, class: "px-6 py-3" %>
  </div>
</div>
```

#### Resource Actions
```erb
<%= ui.table do |table| %>
  <% @products.each do |product| %>
    <% table.tr do %>
      <% table.td product.name %>
      <% table.td product.price %>
      <% table.td do %>
        <div class="flex gap-2">
          <%= ui.link_to "View", product_path(product), variant: :text, color: :primary %>
          <%= ui.link_to "Edit", edit_product_path(product), variant: :text, color: :secondary %>
          <%= ui.link_to "Delete", product_path(product), 
              variant: :text, 
              color: :danger,
              data: { 
                turbo_method: :delete,
                turbo_confirm: "Are you sure?"
              } %>
        </div>
      <% end %>
    <% end %>
  <% end %>
<% end %>
```

#### Breadcrumb Links
```erb
<nav aria-label="Breadcrumb">
  <ol class="flex items-center gap-2 text-sm">
    <li><%= ui.link_to "Home", root_path, variant: :text, color: :default %></li>
    <li class="text-gray-400">/</li>
    <li><%= ui.link_to "Products", products_path, variant: :text, color: :default %></li>
    <li class="text-gray-400">/</li>
    <li class="text-gray-600"><%= @product.name %></li>
  </ol>
</nav>
```

#### Social Media Links
```erb
<div class="social-links flex gap-3">
  <%= ui.link_to "https://twitter.com/example", 
      target: "_blank", 
      rel: "noopener",
      variant: :outlined,
      color: :info,
      class: "p-2" do %>
    <%= ui.icon "twitter", size: :sm %>
  <% end %>
  
  <%= ui.link_to "https://github.com/example",
      target: "_blank",
      rel: "noopener", 
      variant: :outlined,
      color: :default,
      class: "p-2" do %>
    <%= ui.icon "github", size: :sm %>
  <% end %>
</div>
```