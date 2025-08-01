# Typography Component Guide

The Typography component provides consistent text styling across your application, supporting various heading levels, body text, and color variations.

## Basic Usage

The Typography component renders semantic HTML elements with predefined styles:

```erb
<%= ui.typography "Hello World", variant: :h1 %>
<%= ui.typography "Welcome to our application", variant: :body1 %>
```

### Block Content

You can also use block syntax for longer content:

```erb
<%= ui.typography variant: :body1 do %>
  This is a longer paragraph with multiple lines of text.
  It can contain any HTML content you need.
<% end %>
```

## Available Variants

The Typography component supports the following variants, each mapping to a semantic HTML element:

| Variant | HTML Element | Purpose |
|---------|--------------|---------|
| `:h1` | `<h1>` | Main page headings |
| `:h2` | `<h2>` | Section headings |
| `:h3` | `<h3>` | Subsection headings |
| `:h4` | `<h4>` | Sub-subsection headings |
| `:h5` | `<h5>` | Minor headings |
| `:h6` | `<h6>` | Smallest headings |
| `:body1` | `<p>` | Default body text |
| `:body2` | `<p>` | Smaller body text |

## Color Options

Typography components support multiple color variants:

| Color | Use Case |
|-------|----------|
| `:default` | Standard text color (gray-700) |
| `:dark` | Darker text (gray-900) |
| `:muted` | De-emphasized text (gray-500) |
| `:primary` | Primary brand color |
| `:secondary` | Secondary brand color |
| `:success` | Success/positive messaging |
| `:danger` | Error/warning messaging |
| `:warning` | Caution messaging |
| `:info` | Informational messaging |

### Color Examples

```erb
<%= ui.typography "Success!", variant: :h3, color: :success %>
<%= ui.typography "Error message", variant: :body1, color: :danger %>
<%= ui.typography "Muted footnote", variant: :body2, color: :muted %>
```

## Default Styles

Here are the default Tailwind classes applied to each variant:

### Heading Variants

```ruby
h1: "text-3xl font-bold"       # 30px, bold
h2: "text-2xl font-bold"        # 24px, bold
h3: "text-xl font-semibold"     # 20px, semibold
h4: "text-lg font-semibold"     # 18px, semibold
h5: "text-base font-semibold"   # 16px, semibold
h6: "text-sm font-semibold"     # 14px, semibold
```

### Body Variants

```ruby
body1: "text-base font-normal"  # 16px, normal weight
body2: "text-sm font-normal"    # 14px, normal weight
```

### Color Classes

```ruby
default: "text-default-700"     # text-gray-700
dark: "text-default-900"        # text-gray-900
muted: "text-default-500"       # text-gray-500
primary: "text-primary-600"     # text-blue-600
secondary: "text-secondary-600" # text-purple-600
success: "text-success-600"     # text-green-600
danger: "text-danger-600"       # text-red-600
warning: "text-warning-600"     # text-yellow-600
info: "text-info-600"          # text-cyan-600
```

## Advanced Usage

### Custom Classes

Add additional CSS classes to any typography element:

```erb
<%= ui.typography "Custom styled heading", 
    variant: :h2, 
    class: "uppercase tracking-wide" %>
```

### HTML Attributes

Pass any HTML attributes through the options hash:

```erb
<%= ui.typography "Heading with ID", 
    variant: :h1, 
    id: "main-heading",
    data: { turbo_permanent: true } %>
```

### Responsive Typography

Combine with Tailwind's responsive utilities:

```erb
<%= ui.typography "Responsive heading", 
    variant: :h1, 
    class: "text-2xl md:text-3xl lg:text-4xl" %>
```

## Common Patterns

### Page Headers

```erb
<header class="mb-8">
  <%= ui.typography "Dashboard", variant: :h1 %>
  <%= ui.typography "Welcome back! Here's your overview.", 
      variant: :body1, 
      color: :muted %>
</header>
```

### Content Sections

```erb
<section class="space-y-4">
  <%= ui.typography "About Us", variant: :h2 %>
  <%= ui.typography variant: :body1 do %>
    We are committed to providing excellent service...
  <% end %>
</section>
```

### Alert Messages

```erb
<div class="p-4 border rounded">
  <%= ui.typography "Warning", variant: :h4, color: :warning %>
  <%= ui.typography "Please review your settings before continuing.", 
      variant: :body2, 
      color: :warning %>
</div>
```

### Lists with Typography

```erb
<ul class="space-y-2">
  <li>
    <%= ui.typography "Feature One", variant: :h5 %>
    <%= ui.typography "Description of the first feature", 
        variant: :body2, 
        color: :muted %>
  </li>
  <li>
    <%= ui.typography "Feature Two", variant: :h5 %>
    <%= ui.typography "Description of the second feature", 
        variant: :body2, 
        color: :muted %>
  </li>
</ul>
```

## Customizing Typography Styles

To override the default typography styles, create a config class:

```ruby
# app/helpers/okonomi_ui_kit/configs/typography.rb
module OkonomiUiKit
  module Configs
    class Typography < OkonomiUiKit::Config
      register_styles :default do
        {
          variants: {
            h1: "text-4xl font-light tracking-tight",
            h2: "text-3xl font-light tracking-tight",
            body1: "text-base leading-relaxed",
            # ... more overrides
          },
          colors: {
            primary: "text-brand-600",
            # ... more color overrides
          }
        }
      end
    end
  end
end
```

For more details on customizing styles, see the [Style Overrides Guide](../style-overrides-guide.md).

## Accessibility Considerations

1. **Semantic HTML**: Always use the appropriate variant for your content structure
2. **Heading Hierarchy**: Don't skip heading levels (e.g., don't go from h1 to h3)
3. **Color Contrast**: Ensure sufficient contrast between text and background colors
4. **Content Structure**: Use headings to create a logical document outline

## Examples in Context

### Blog Post Layout

```erb
<article class="max-w-prose mx-auto">
  <%= ui.typography @post.title, variant: :h1 %>
  
  <div class="flex gap-4 mb-6">
    <%= ui.typography @post.author.name, variant: :body2, color: :muted %>
    <%= ui.typography @post.published_at.to_s(:long), 
        variant: :body2, 
        color: :muted %>
  </div>
  
  <div class="prose">
    <%= ui.typography variant: :body1 do %>
      <%= @post.content %>
    <% end %>
  </div>
</article>
```

### Form Section Headers

```erb
<%= form_with model: @user do |f| %>
  <div class="space-y-6">
    <section>
      <%= ui.typography "Personal Information", variant: :h3 %>
      <%= ui.typography "Please provide your basic details", 
          variant: :body2, 
          color: :muted %>
      <!-- form fields -->
    </section>
    
    <section>
      <%= ui.typography "Account Settings", variant: :h3 %>
      <!-- form fields -->
    </section>
  </div>
<% end %>
```

### Dashboard Cards

```erb
<div class="grid grid-cols-1 md:grid-cols-3 gap-6">
  <div class="p-6 bg-white rounded-lg shadow">
    <%= ui.typography "Total Revenue", variant: :h6, color: :muted %>
    <%= ui.typography "$12,345", variant: :h2 %>
    <%= ui.typography "+12% from last month", 
        variant: :body2, 
        color: :success %>
  </div>
  <!-- more cards -->
</div>
```

## Summary

The Typography component provides a consistent, semantic way to render text throughout your application. By using predefined variants and colors, you maintain visual consistency while keeping your code clean and maintainable. The component's flexibility allows for customization when needed while encouraging best practices for accessibility and document structure.