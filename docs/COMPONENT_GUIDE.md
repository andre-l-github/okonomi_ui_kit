# OkonomiUiKit Component Implementation Guide

This guide explains how to implement new components in OkonomiUiKit using the plugin-based architecture.

## Component Architecture Overview

OkonomiUiKit uses a plugin-based system where components are dynamically loaded through the `method_missing` mechanism in the `UiBuilder` class. This provides a clean, extensible way to add new components without modifying the core helper.

## Steps to Create a New Component

### 1. Create the Component Class

Create a new file in `app/helpers/okonomi_ui_kit/components/[component_name].rb`:

```ruby
module OkonomiUiKit
  module Components
    class YourComponent < OkonomiUiKit::Component
      def render(*args, &block)
        # Extract options and process arguments
        # Call view.render with the template path and variables
      end
    end
  end
end
```

### 2. Create the Template Structure

Create the template directory and file:
```
app/views/okonomi/components/[component_name]/_[component_name].html.erb
```

The template path follows the convention: `okonomi/components/[name]/[name]`

### 3. Base Component Class

All components inherit from `OkonomiUiKit::Component` which provides:

- `view`: Reference to the template/view context
- `theme`: Access to the current theme configuration
- `template_path`: Automatically generates the path to the component's template
- `name`: Returns the underscored component name

## Example: Alert Component

Here's how the Alert component is implemented:

### Component Class (`app/helpers/okonomi_ui_kit/components/alert.rb`):
```ruby
module OkonomiUiKit
  module Components
    class Alert < OkonomiUiKit::Component
      def render(title, options = {}, &block)
        view.render(template_path, title:, options: options.with_indifferent_access, &block)
      end
    end
  end
end
```

### Template (`app/views/okonomi/components/alert/_alert.html.erb`):
```erb
<div class="hover:bg-blue-700">
  <%= title %>
</div>
```

## Example: Typography Component

A more complex example showing variant handling and theme integration:

### Component Class (`app/helpers/okonomi_ui_kit/components/typography.rb`):
```ruby
module OkonomiUiKit
  module Components
    class Typography < OkonomiUiKit::Component
      TYPOGRAPHY_COMPONENTS = {
        body1: 'p',
        body2: 'p',
        h1: 'h1',
        h2: 'h2',
        h3: 'h3',
        h4: 'h4',
        h5: 'h5',
        h6: 'h6',
      }.freeze

      def render(text = nil, options = {}, &block)
        options, text = text, nil if block_given?
        options ||= {}

        variant = (options.delete(:variant) || 'body1').to_sym
        component = (TYPOGRAPHY_COMPONENTS[variant] || 'span').to_s
        color = (options.delete(:color) || 'default').to_sym
        
        classes = [
          theme.dig(:components, :typography, :variants, variant) || '',
          theme.dig(:components, :typography, :colors, color) || '',
          options.delete(:class) || ''
        ].reject(&:blank?).join(' ')

        view.render(
          template_path,
          text: text,
          options: options,
          variant: variant,
          component: component,
          classes: classes,
          &block
        )
      end
    end
  end
end
```

### Template (`app/views/okonomi/components/typography/_typography.html.erb`):
```erb
<%= content_tag component, class: classes do %>
  <% if defined?(text)%>
    <%= text %>
  <% else %>
    <%= yield %>
  <% end %>
<% end %>
```

## How the Plugin System Works

1. When `ui.your_component(...)` is called, the `method_missing` in `UiBuilder` intercepts it
2. It converts `your_component` to `YourComponent` and checks if `OkonomiUiKit::Components::YourComponent` exists
3. If found, it instantiates the component with the template and theme, then calls `render`
4. If not found, it calls `super` to raise the standard NoMethodError

```ruby
def method_missing(method_name, *args, &block)
  component_name = "OkonomiUiKit::Components::#{method_name.to_s.camelize}"
  if Object.const_defined?(component_name)
    return component_name.constantize.new(@template, get_theme).render(*args, &block)
  else
    super
  end
end
```

## Best Practices

1. **Theme Integration**: Always use the `theme` accessor to get styling classes
2. **Flexible Arguments**: Support both text/content as first argument and block form
3. **Options Processing**: Use `with_indifferent_access` for options hashes
4. **Class Composition**: Build classes arrays and join them, filtering out blanks
5. **Template Variables**: Pass all necessary variables to the template explicitly

## Defining and Using Styles in Components

### Style Registration

Components can define their default styles using the `register_styles` class method. This approach provides:
- Clean separation of styling from logic
- Easy style overrides via theme system
- Consistent style access patterns

#### Basic Style Registration

```ruby
module OkonomiUiKit
  module Components
    class Button < OkonomiUiKit::Component
      register_styles :default do
        {
          base: "inline-flex items-center justify-center rounded-md font-medium",
          sizes: {
            sm: "px-3 py-1.5 text-sm",
            md: "px-4 py-2 text-base",
            lg: "px-6 py-3 text-lg"
          },
          variants: {
            primary: "bg-primary-600 text-white hover:bg-primary-700",
            secondary: "bg-secondary-600 text-white hover:bg-secondary-700",
            outlined: "border border-gray-300 bg-white text-gray-700 hover:bg-gray-50"
          }
        }
      end
    end
  end
end
```

### Accessing Styles in Components

The `Component` base class provides a `style` method to access registered styles:

```ruby
def render(text, options = {})
  size = (options.delete(:size) || :md).to_sym
  variant = (options.delete(:variant) || :primary).to_sym
  
  classes = [
    style(:base),                    # Access base styles
    style(:sizes, size),             # Access nested styles
    style(:variants, variant),       # Access variant styles
    options.delete(:class)           # Include custom classes
  ].compact.join(' ')
  
  view.tag.button(text, class: classes, **options)
end
```

### Style Registration Patterns

#### 1. Simple Components
For components with basic styling needs:

```ruby
register_styles :default do
  {
    base: "inline-block rounded px-2 py-1 text-sm",
    colors: {
      default: "bg-gray-100 text-gray-800",
      primary: "bg-blue-100 text-blue-800",
      success: "bg-green-100 text-green-800"
    }
  }
end
```

#### 2. Complex Components
For components with multiple style dimensions:

```ruby
register_styles :default do
  {
    base: "relative inline-flex items-center",
    variants: {
      solid: "shadow-sm",
      ghost: "shadow-none",
      raised: "shadow-lg"
    },
    sizes: {
      sm: "h-8 text-sm",
      md: "h-10 text-base",
      lg: "h-12 text-lg"
    },
    states: {
      disabled: "opacity-50 cursor-not-allowed",
      loading: "cursor-wait",
      active: "ring-2 ring-offset-2"
    }
  }
end
```

#### 3. Conditional Styles
When styles depend on multiple conditions:

```ruby
def render(content, options = {})
  variant = options.delete(:variant) || :solid
  size = options.delete(:size) || :md
  disabled = options.delete(:disabled)
  loading = options.delete(:loading)
  
  classes = [
    style(:base),
    style(:variants, variant),
    style(:sizes, size),
    disabled ? style(:states, :disabled) : nil,
    loading ? style(:states, :loading) : nil
  ].compact.join(' ')
  
  # ...
end
```

### Theme Integration

Registered styles automatically integrate with the theme system. Users can override component styles via theme configuration:

```ruby
# In an initializer
Rails.application.config.after_initialize do
  OkonomiUiKit::Theme::DEFAULT_THEME.deep_merge!({
    components: {
      button: {
        base: "custom-button-base-classes",
        variants: {
          primary: "bg-brand-500 hover:bg-brand-600"
        }
      }
    }
  })
end
```

### Style Method Reference

The `style` method supports multiple access patterns:

```ruby
# Access base styles
style(:base)                     # => "inline-flex items-center..."

# Access nested styles
style(:variants, :primary)       # => "bg-primary-600 text-white..."

# Access deeply nested styles
style(:states, :hover, :primary) # => "hover:bg-primary-700"

# Returns nil for non-existent keys (safe access)
style(:variants, :unknown)       # => nil
```

### Best Practices for Component Styles

1. **Use Semantic Keys**: Name style groups based on their purpose (variants, sizes, states)
2. **Provide Defaults**: Always include sensible defaults for optional style parameters
3. **Keep Base Minimal**: Base styles should only include essential, always-applied classes
4. **Avoid Conflicts**: Design style groups to be composable without conflicts
5. **Use Tailwind Utilities**: Leverage Tailwind's utility classes for consistency
6. **Document Style Options**: Include comments describing available style options

### Complete Example: Badge Component

```ruby
module OkonomiUiKit
  module Components
    class Badge < OkonomiUiKit::Component
      def render(text, options = {})
        options = options.with_indifferent_access
        severity = (options.delete(:severity) || :default).to_sym
        
        classes = [
          style(:base),
          style(:severities, severity) || '',
          options.delete(:class) || ''
        ].reject(&:blank?).join(' ')

        view.tag.span(text, class: classes, **options)
      end

      register_styles :default do
        {
          base: "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium",
          severities: {
            default: "bg-gray-100 text-gray-800",
            success: "bg-green-100 text-green-800",
            danger: "bg-red-100 text-red-800",
            info: "bg-blue-100 text-blue-800",
            warning: "bg-yellow-100 text-yellow-800"
          }
        }
      end
    end
  end
end
```

## Adding Theme Support

**DEPRECATION NOTICE**: The old theme system using `theme.rb` and `theme.dig` is deprecated and will be removed once all components are refactored. New components should use the `register_styles` approach exclusively.

### Legacy Theme System (Deprecated)

The old approach of accessing theme configuration via `theme.dig` is deprecated:

```ruby
# DEPRECATED - Do not use in new components
theme.dig(:components, :your_component, :base)
theme.dig(:components, :your_component, :variants, variant_name)
theme.dig(:components, :your_component, :colors, color_name)
```

### Current Approach (Required for New Components)

All new components must use the `register_styles` method and access styles via the `style` helper:

```ruby
class MyComponent < OkonomiUiKit::Component
  register_styles :default do
    {
      base: "...",
      variants: { ... }
    }
  end
  
  def render(...)
    style(:base)  # Use this instead of theme.dig
  end
end
```

The `style` method provides cleaner syntax, automatic style registration, and better integration with the component system.

## Testing Your Component

After creating a component, test it in your views:

```erb
<%= ui.your_component("Content", variant: :primary, color: :success) %>

<%= ui.your_component(variant: :secondary) do %>
  <span>Block content</span>
<% end %>
```

## Component Naming Conventions

- Component class: `PascalCase` (e.g., `ButtonGroup`)
- Method name: `snake_case` (e.g., `button_group`)
- Template directory: `snake_case` (e.g., `button_group`)
- Template file: `_snake_case.html.erb` (e.g., `_button_group.html.erb`)

This architecture ensures components are:
- Easy to add without modifying core code
- Automatically available through the `ui` helper
- Consistent in structure and behavior
- Fully integrated with the theme system

## Testing Components

Components should be thoroughly tested to ensure they work correctly and integrate properly with the theme system. Here's how to test components:

### Test File Location

Create test files in `test/helpers/okonomi_ui_kit/components/[component_name]_test.rb`

### Basic Test Structure

```ruby
require "test_helper"

module OkonomiUiKit
  module Components
    class YourComponentTest < ActionView::TestCase
      include OkonomiUiKit::UiHelper

      test "component renders with default options" do
        html = ui.your_component("Content")
        
        assert_includes html, "expected content"
        assert_includes html, "<expected_tag"
      end
    end
  end
end
```

### Key Testing Areas

1. **Default Rendering**
   ```ruby
   test "renders with minimal arguments" do
     html = ui.typography("Hello World")
     
     assert_includes html, "<p"
     assert_includes html, "Hello World"
     assert_includes html, "</p>"
   end
   ```

2. **Variant Support**
   ```ruby
   test "renders all variants correctly" do
     %i[primary secondary outlined].each do |variant|
       html = ui.button("Click", variant: variant)
       
       # Assert variant-specific rendering
     end
   end
   ```

3. **Block Content**
   ```ruby
   test "accepts block content" do
     html = ui.card do
       "<strong>Custom content</strong>".html_safe
     end
     
     assert_includes html, "<strong>Custom content</strong>"
   end
   ```

4. **Theme Integration**
   ```ruby
   test "applies theme classes" do
     html = ui.alert("Message", variant: :success)
     
     # Check that theme classes are applied
     assert_match /class="[^"]*"/, html
   end
   ```

5. **HTML Options**
   ```ruby
   test "accepts html options" do
     html = ui.badge("New", id: "my-badge", data: { value: "1" })
     
     assert_includes html, 'id="my-badge"'
     assert_includes html, 'data-value="1"'
   end
   ```

6. **Theme Overrides**
   ```ruby
   test "respects theme overrides" do
     ui.theme(components: { button: { base: "custom-class" } }) do
       html = ui.button("Test")
       
       assert_includes html, "custom-class"
     end
   end
   ```

7. **Edge Cases**
   ```ruby
   test "handles nil content gracefully" do
     html = ui.typography(nil)
     
     assert_includes html, "<p"
     refute_includes html, "nil"
   end
   ```

8. **Plugin System**
   ```ruby
   test "component loads via plugin system" do
     assert_nothing_raised do
       ui.your_component("Test")
     end
   end
   ```

### Complete Typography Test Example

Here's the complete test suite for the Typography component as a reference:

```ruby
require "test_helper"

module OkonomiUiKit
  module Components
    class TypographyTest < ActionView::TestCase
      include OkonomiUiKit::UiHelper

      test "typography renders with default variant and text" do
        html = ui.typography("Hello World")
        
        assert_includes html, "<p"
        assert_includes html, "Hello World"
        assert_includes html, "</p>"
      end

      test "typography renders all heading variants correctly" do
        %i[h1 h2 h3 h4 h5 h6].each do |variant|
          html = ui.typography("Heading #{variant}", variant: variant)
          
          assert_includes html, "<#{variant}"
          assert_includes html, "Heading #{variant}"
          assert_includes html, "</#{variant}>"
        end
      end

      test "typography accepts block content" do
        html = ui.typography(variant: :h2) do
          "<strong>Bold content</strong>".html_safe
        end
        
        assert_includes html, "<h2"
        assert_includes html, "<strong>Bold content</strong>"
        assert_includes html, "</h2>"
      end

      test "typography applies color classes" do
        html = ui.typography("Colored text", color: :primary)
        
        assert_match /class="[^"]*"/, html
      end

      test "typography merges custom classes" do
        html = ui.typography("Custom styled", class: "custom-class")
        
        assert_includes html, "custom-class"
      end

      test "typography accepts html options" do
        html = ui.typography("Text with ID", id: "my-typography", data: { testid: "typography-element" })
        
        assert_includes html, 'id="my-typography"'
        assert_includes html, 'data-testid="typography-element"'
      end
    end
  end
end
```

### Running Component Tests

Run tests for a specific component:
```bash
bin/rails test test/helpers/okonomi_ui_kit/components/typography_test.rb
```

Run all component tests:
```bash
bin/rails test test/helpers/okonomi_ui_kit/components/
```

### Testing Best Practices

1. **Test Public Interface** - Focus on testing what users of the component will use
2. **Avoid Implementation Details** - Don't test internal methods or exact HTML structure unless critical
3. **Test Edge Cases** - Include tests for nil values, empty strings, missing options
4. **Test Integration** - Ensure components work with the theme system and view helpers
5. **Keep Tests Fast** - Use ActionView::TestCase for unit tests rather than integration tests
6. **Use Descriptive Names** - Test names should clearly indicate what behavior they verify

This testing approach ensures your components are reliable, maintainable, and properly integrated with the OkonomiUiKit system.