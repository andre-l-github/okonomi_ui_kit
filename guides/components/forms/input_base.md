# InputBase Component Guide

The InputBase component provides the foundational styling and behavior for all form input components in OkonomiUiKit. It handles error states, styling, and common input functionality.

## Overview

InputBase is the parent class for most form input components including:
- TextField
- EmailField
- PasswordField
- NumberField
- DateField
- TimeField
- DatetimeLocalField
- SearchField
- UrlField
- TelephoneField
- TextArea

## Architecture

InputBase provides:
- Consistent styling across all input types
- Error state management
- Automatic CSS class generation
- Integration with Rails form validation
- Accessibility attributes

## Usage

InputBase is typically not used directly but through its child components:

```erb
<%= f.text_field :name %>          <!-- Uses InputBase -->
<%= f.email_field :email %>        <!-- Uses InputBase -->
<%= f.password_field :password %>  <!-- Uses InputBase -->
```

## Core Methods

#### render_arguments(object, method, options = {})
Generates the arguments passed to Rails form helpers:
- Merges default options with user options
- Applies CSS classes based on validation state
- Sets autocomplete to "off" by default

#### input_field_classes(object, method, type, options)
Builds CSS classes for the input field:
- Base styling classes
- Error state classes when validation fails
- Valid state classes when no errors
- Disabled state classes

## Styling System

#### Default Styles

InputBase provides these base styles:
- Root: `w-full border-0 px-3 py-2 rounded-md ring-1 focus:outline-none focus-within:ring-1`
- Error: `bg-danger-100 text-danger-400 ring-danger-400 focus:ring-danger-600`
- Valid: `text-default-700 ring-gray-300 focus-within:ring-gray-400`
- Disabled: `disabled:bg-gray-50 disabled:cursor-not-allowed`

#### Error State Logic

InputBase automatically applies error styling when:
- The object has validation errors for the field
- Associated fields have errors (e.g., `name` errors apply to `name_id`)

## Customization

#### Global Style Override

```ruby
# In your initializer
module OkonomiUiKit
  module Components
    module Forms
      class InputBase
        register_styles :custom do
          {
            root: "w-full px-4 py-3 border-2 border-gray-200 rounded-lg",
            error: "border-red-500 bg-red-50 text-red-900 ring-red-500",
            valid: "border-gray-200 focus:border-blue-500 ring-blue-500",
            disabled: "bg-gray-100 text-gray-500 cursor-not-allowed"
          }
        end
      end
    end
  end
end
```

#### Per-Component Override

Each input type can have its own styling:

```ruby
module OkonomiUiKit
  module Components
    module Forms
      class EmailField
        register_styles :email_specific do
          {
            root: "border-2 border-blue-200 focus:border-blue-400",
            error: "border-red-400 bg-red-50",
            valid: "border-blue-200 focus:border-blue-400"
          }
        end
      end
    end
  end
end
```

#### Runtime Theme Switching

```erb
<% ui.theme(components: { forms: { input_base: { 
  root: "rounded-xl shadow-sm",
  error: "ring-red-400 bg-red-25"
} } }) do %>
  <%= f.text_field :name %>
<% end %>
```

## Error Handling

#### Automatic Error Detection

InputBase automatically detects errors from:
- Direct field errors: `object.errors[:email]`
- Association errors: `object.errors[:user]` for `user_id` field
- Custom error keys

#### Error State CSS

When errors are present:
- Error styles override valid styles
- Visual indicators (red borders, backgrounds)
- Focus states maintain error styling

## Advanced Features

#### Custom Input Types

Create new input types by inheriting from InputBase:

```ruby
module OkonomiUiKit
  module Components
    module Forms
      class ColorField < OkonomiUiKit::Components::Forms::InputBase
        type :color
        
        register_styles :default do
          {
            root: "w-20 h-10 rounded-md border-0 ring-1 ring-gray-300 cursor-pointer",
            error: "ring-red-500",
            valid: "ring-gray-300"
          }
        end
      end
    end
  end
end
```

#### Custom Validation Logic

Override error detection for specific needs:

```ruby
class CustomInputBase < OkonomiUiKit::Components::Forms::InputBase
  def when_errors(object, method, value, default_value = nil)
    # Custom error detection logic
    if custom_error_condition?(object, method)
      value
    else
      default_value
    end
  end
  
  private
  
  def custom_error_condition?(object, method)
    # Your custom logic here
  end
end
```

## Best Practices

1. **Consistent Inheritance**: Always inherit from InputBase for new input types
2. **Error States**: Ensure error styling is clearly visible and accessible
3. **Focus Management**: Maintain clear focus indicators
4. **Type Specificity**: Use appropriate HTML input types for better UX
5. **Validation Integration**: Leverage Rails validation for error detection
6. **Custom Styling**: Override styles thoughtfully to maintain consistency

## Accessibility

InputBase ensures accessibility by:
- Using semantic HTML input types
- Maintaining focus indicators
- Supporting ARIA attributes through Rails helpers
- Providing clear error state visuals
- Working with screen readers
- Supporting keyboard navigation

## Implementation Details

#### Type System

Each input component defines its type:

```ruby
class EmailField < InputBase
  type :email  # Sets HTML input type="email"
end

class NumberField < InputBase
  type :number  # Sets HTML input type="number"
end
```

#### CSS Class Merging

InputBase uses TWMerge for intelligent CSS class combination:
- Removes duplicate classes
- Handles Tailwind CSS conflicts
- Maintains proper precedence

#### Form Integration

InputBase integrates with Rails FormBuilder:
- Accesses form object for validation state
- Works with Rails error handling
- Supports all standard form helper options

## Examples

#### Custom Input Component

```ruby
# app/helpers/okonomi_ui_kit/components/forms/rating_field.rb
module OkonomiUiKit
  module Components
    module Forms
      class RatingField < OkonomiUiKit::Components::Forms::InputBase
        type :range
        
        def render_arguments(object, method, options = {})
          default_options = {
            min: 1,
            max: 5,
            step: 1,
            autocomplete: "off"
          }
          
          css = input_field_classes(object, method, self.class.type_value, options)
          [ method, default_options.merge(options).merge(class: css) ]
        end
        
        register_styles :default do
          {
            root: "w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer",
            error: "bg-red-200",
            valid: "bg-gray-200"
          }
        end
      end
    end
  end
end
```

#### Usage in Forms

```erb
<%= form_with model: @review, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :rating do %>
    <%= f.rating_field :rating, min: 1, max: 10 %>
  <% end %>
<% end %>
```

#### Integration with Stimulus

```erb
<%= f.text_field :search_query,
    data: {
      controller: "search",
      search_target: "input",
      action: "input->search#perform"
    } %>
```

The InputBase component provides the foundation for all OkonomiUiKit form inputs, ensuring consistency, accessibility, and proper integration with Rails validation systems.