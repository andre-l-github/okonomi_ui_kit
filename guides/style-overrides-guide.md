# OkonomiUiKit Style Override Guide

This guide explains how to customize and override component styles in OkonomiUiKit. The gem provides a flexible system that allows you to modify the appearance of components while maintaining consistency across your application.

## Table of Contents
1. [Understanding the Style System](#understanding-the-style-system)
2. [Creating Config Classes](#creating-config-classes)
3. [Style Merging with TWMerge](#style-merging-with-twmerge)
4. [Component Hierarchy](#component-hierarchy)
5. [Practical Examples](#practical-examples)
6. [Best Practices](#best-practices)

## Understanding the Style System

OkonomiUiKit uses a two-layer style system that combines:
1. **Internal Styles**: Default styles defined within component classes
2. **Config Styles**: Override styles defined in separate config classes

### How Styles Are Applied

When a component renders, it combines styles in this order:
1. Internal component styles (defined with `register_styles`)
2. Config class styles (if a matching config exists)
3. Runtime classes passed to the component

The system uses intelligent Tailwind class merging to resolve conflicts, ensuring later styles properly override earlier ones.

## Creating Config Classes

To override a component's styles, create a config class in your Rails application:

### Step 1: Create the Config Directory

```bash
mkdir -p app/helpers/okonomi_ui_kit/configs
```

### Step 2: Create a Config Class

Create a file matching the component name. For example, to override the `ButtonBase` component:

```ruby
# app/helpers/okonomi_ui_kit/configs/button_base.rb
module OkonomiUiKit
  module Configs
    class ButtonBase < OkonomiUiKit::Config
      register_styles :default do
        {
          root: "text-base font-semibold transition-all duration-200",
          outlined: {
            root: "border-2 shadow-sm",
            colors: {
              primary: "border-blue-500 text-blue-500 hover:bg-blue-500 hover:text-white",
              secondary: "border-gray-500 text-gray-500 hover:bg-gray-500 hover:text-white"
            }
          },
          contained: {
            root: "border-2 shadow-md",
            colors: {
              primary: "bg-blue-500 border-blue-600 hover:bg-blue-600",
              secondary: "bg-gray-500 border-gray-600 hover:bg-gray-600"
            }
          }
        }
      end
    end
  end
end
```

### Config Class Naming Convention

The config class name must match the component class name:
- Component: `OkonomiUiKit::Components::ButtonBase`
- Config: `OkonomiUiKit::Configs::ButtonBase`

## Style Merging with TWMerge

OkonomiUiKit uses an intelligent Tailwind class merger that:
- Resolves conflicts between competing utility classes
- Preserves non-conflicting classes
- Maintains variant prefixes (like `hover:`, `sm:`)

### Example of Style Merging

```ruby
# Internal component styles
"text-sm text-gray-600 hover:text-gray-800"

# Config override styles
"text-base text-blue-600"

# Result after merging
"text-base text-blue-600 hover:text-gray-800"
```

The merger identifies that `text-base` conflicts with `text-sm` and `text-blue-600` conflicts with `text-gray-600`, keeping the override values while preserving the non-conflicting `hover:` state.

## Component Hierarchy

Config classes respect component inheritance. For example:

```
ButtonBase
├── ButtonTo
├── ButtonTag
└── LinkTo
```

A config for `ButtonBase` will affect all child components unless they have their own specific configs.

### Creating Child Component Configs

```ruby
# app/helpers/okonomi_ui_kit/configs/button_to.rb
module OkonomiUiKit
  module Configs
    class ButtonTo < OkonomiUiKit::Config
      register_styles :default do
        {
          root: "inline-flex items-center gap-2",
          # Inherits and extends ButtonBase styles
        }
      end
    end
  end
end
```

## Practical Examples

### Example 1: Brand-Specific Button Styles

Create a config to match your brand guidelines:

```ruby
# app/helpers/okonomi_ui_kit/configs/button_base.rb
module OkonomiUiKit
  module Configs
    class ButtonBase < OkonomiUiKit::Config
      register_styles :default do
        {
          root: "font-brand tracking-wide uppercase text-xs",
          contained: {
            root: "px-6 py-3 rounded-none",
            colors: {
              primary: "bg-brand-primary border-brand-primary hover:bg-brand-primary-dark",
              secondary: "bg-brand-secondary border-brand-secondary hover:bg-brand-secondary-dark"
            }
          }
        }
      end
    end
  end
end
```

### Example 2: Dark Mode Support

Add dark mode variants to components:

```ruby
# app/helpers/okonomi_ui_kit/configs/badge.rb
module OkonomiUiKit
  module Configs
    class Badge < OkonomiUiKit::Config
      register_styles :default do
        {
          root: "dark:ring-1 dark:ring-white/10",
          colors: {
            primary: "bg-blue-100 text-blue-800 dark:bg-blue-900 dark:text-blue-200",
            success: "bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-200",
            danger: "bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-200"
          }
        }
      end
    end
  end
end
```

### Example 3: Typography Customization

Override typography styles for consistent text rendering:

```ruby
# app/helpers/okonomi_ui_kit/configs/typography.rb
module OkonomiUiKit
  module Configs
    class Typography < OkonomiUiKit::Config
      register_styles :default do
        {
          h1: "text-4xl lg:text-5xl font-display font-light leading-tight",
          h2: "text-3xl lg:text-4xl font-display font-light leading-tight",
          h3: "text-2xl lg:text-3xl font-display font-normal",
          body: "text-base lg:text-lg font-body leading-relaxed",
          small: "text-sm lg:text-base font-body"
        }
      end
    end
  end
end
```

### Example 4: Table Styling

Customize table appearance:

```ruby
# app/helpers/okonomi_ui_kit/configs/table.rb
module OkonomiUiKit
  module Configs
    class Table < OkonomiUiKit::Config
      register_styles :default do
        {
          root: "min-w-full divide-y divide-gray-200 dark:divide-gray-700",
          thead: "bg-gray-50 dark:bg-gray-800",
          th: "px-6 py-4 text-left text-xs font-semibold text-gray-900 dark:text-gray-100 uppercase tracking-wider",
          tbody: "bg-white dark:bg-gray-900 divide-y divide-gray-200 dark:divide-gray-700",
          td: "px-6 py-4 whitespace-nowrap text-sm text-gray-900 dark:text-gray-100"
        }
      end
    end
  end
end
```

## Best Practices

### 1. Use Semantic Naming

Define color aliases that match your design system:

```ruby
# config/tailwind.config.js
module.exports = {
  theme: {
    extend: {
      colors: {
        'brand-primary': '#0066CC',
        'brand-secondary': '#6B7280',
        // ... more brand colors
      }
    }
  }
}
```

### 2. Keep Configs DRY

Extract common patterns into constants:

```ruby
module OkonomiUiKit
  module Configs
    TRANSITION_CLASSES = "transition-all duration-200 ease-in-out"
    FOCUS_CLASSES = "focus:outline-none focus:ring-2 focus:ring-offset-2"
    
    class ButtonBase < OkonomiUiKit::Config
      register_styles :default do
        {
          root: "#{TRANSITION_CLASSES} #{FOCUS_CLASSES}",
          # ... rest of styles
        }
      end
    end
  end
end
```

### 3. Document Your Overrides

Add comments explaining why specific overrides exist:

```ruby
module OkonomiUiKit
  module Configs
    class Alert < OkonomiUiKit::Config
      register_styles :default do
        {
          # Reduced padding and border radius to match compact design system
          root: "p-3 rounded-sm border-l-4",
          # Using custom icon sizes for consistency with other components
          icon: "w-4 h-4"
        }
      end
    end
  end
end
```

### 4. Test Across Themes

If you support multiple themes, test your overrides:

```ruby
# app/helpers/okonomi_ui_kit/configs/button_base.rb
module OkonomiUiKit
  module Configs
    class ButtonBase < OkonomiUiKit::Config
      # Default theme
      register_styles :default do
        { root: "rounded-md" }
      end
      
      # Corporate theme
      register_styles :corporate do
        { root: "rounded-none shadow-lg" }
      end
      
      # Playful theme
      register_styles :playful do
        { root: "rounded-full" }
      end
    end
  end
end
```

### 5. Avoid Over-Specificity

Let the TWMerge system handle conflicts rather than using overly specific selectors:

```ruby
# Good - let TWMerge handle conflicts
register_styles :default do
  {
    root: "text-gray-700 hover:text-gray-900"
  }
end

# Avoid - too specific
register_styles :default do
  {
    root: "text-gray-700 hover:text-gray-900 !important"
  }
end
```

## Troubleshooting

### Styles Not Applying

1. **Check naming**: Ensure config class name matches component name exactly
2. **Check file location**: Config must be in `app/helpers/okonomi_ui_kit/configs/`
3. **Restart server**: Rails may need to reload to pick up new config classes
4. **Check load order**: Ensure your app's helpers are loaded after the gem

### Conflicting Styles

Use the browser's developer tools to inspect applied classes. The TWMerge system should resolve most conflicts, but you may need to be more specific with your overrides.

### Finding Component Names

To find the correct component name for your config:

```ruby
# In rails console
ui = OkonomiUiKit::UiHelper.new(self)
ui.button("Test")
# Look for the component class in the stack trace or add debugging
```

## Summary

The OkonomiUiKit style override system provides a clean, maintainable way to customize component appearance:

1. Create config classes matching component names
2. Define styles using the `register_styles` method
3. Leverage TWMerge for intelligent class merging
4. Follow naming conventions and best practices
5. Test your overrides across different contexts

This approach keeps your customizations separate from the core gem, making upgrades easier and your styling more maintainable.