# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

OkonomiUiKit is a Rails Engine gem that provides reusable UI components for Rails applications based on Tailwind CSS and Stimulus controllers. The engine is designed with maximum customizability in mind, allowing client projects to adapt both structure and styling to their specific needs.

## Design Philosophy

The engine follows these core principles:
1. **Reusability** - Components work across multiple Rails projects
2. **Customizability** - Every aspect can be overridden by client applications
3. **Convention over Configuration** - Sensible defaults that follow Rails patterns
4. **Progressive Enhancement** - Stimulus controllers enhance server-rendered HTML

### Customization Mechanisms
1. **Template Overrides** - All component templates can be overridden using Rails' standard view lookup
2. **Theme Configuration** - All styling is controlled through a centralized theme that can be customized

## Development Commands

### Running the Development Server
```bash
bin/dev                    # Start Rails server and Tailwind CSS watcher
```

### Testing
```bash
bin/rails test             # Run the test suite
bin/rails db:test:prepare test  # Prepare test database and run tests
bin/rails test test/helpers/okonomi_ui_kit/form_builder_test.rb  # Run specific test file
```

### Linting
```bash
bin/rubocop               # Run RuboCop linter
bin/rubocop -a            # Auto-fix correctable offenses
bin/rubocop -f github     # Format output for GitHub Actions
```

### Building the Gem
```bash
bundle exec rake build    # Build the gem
bundle exec rake release  # Release the gem
```

## Architecture

### Rails Engine Structure
This gem is built as a Rails Engine, isolated in the `OkonomiUiKit` namespace. The engine configuration in `lib/okonomi_ui_kit/engine.rb` sets up:
- Importmap integration for JavaScript modules
- Asset pipeline configuration for Tailwind CSS
- Automatic inclusion of helper modules in ActionView

### Component Structure
Components consist of three parts:
1. **Helper Methods** - Ruby methods that generate HTML with configurable classes
2. **View Templates** - ERB templates in `app/views/okonomi/` that define component structure
3. **Stimulus Controllers** - JavaScript controllers in `app/javascript/okonomi_ui_kit/controllers/`

### Helper Modules
The UI components are organized as helper modules in `app/helpers/okonomi_ui_kit/`:
- **FormBuilder** (`form_builder.rb`) - Custom form builder with Tailwind-styled inputs
- **Component** (`component.rb`) - Base class for components with style registration
- **NavigationHelper** - Navigation components (menus, breadcrumbs)
- **IconHelper** - Icon system integration
- **PageBuilderHelper** - Page layout components
- **AttributeSectionHelper** - Attribute display sections
- **UiHelper** - Core UI builder with theme context management

### Component Plugin System
OkonomiUiKit uses a plugin-based architecture for components. New components are automatically available through the `ui` helper via the `method_missing` mechanism. Components are implemented as classes in `app/helpers/okonomi_ui_kit/components/` that inherit from `OkonomiUiKit::Component`.

For detailed instructions on creating new components, see [Component Implementation Guide](docs/COMPONENT_GUIDE.md).

### Component Styling System
The component styling system provides:
- Component-based style registration via `register_styles`
- Config class overrides for customization
- Intelligent Tailwind class merging with TWMerge
- Style inheritance through component hierarchy

### View Templates
Templates are organized by component type:
- `app/views/okonomi/forms/tailwind/` - Form field templates
- `app/views/okonomi/components/` - Component templates (alert, badge, table, typography, etc.)
- `app/views/okonomi/attribute_sections/` - Attribute display templates

### Stimulus Controllers
JavaScript behaviors are implemented as Stimulus controllers:
- `dropdown_controller.js` - Dropdown menu interactions
- `flash_controller.js` - Flash message handling
- `upload_controller.js` - File upload enhancements
- `form_field_visibility_controller.js` - Conditional field visibility

### Tailwind CSS Integration
- Configuration in `config/tailwind.config.js`
- Watches both gem and dummy app files
- Built CSS output to `app/assets/builds/okonomi_ui_kit/application.tailwind.css`

### Test Dummy Application
The `test/dummy/` directory contains a full Rails application used for:
- Testing the engine in a real Rails environment
- Development server for previewing components
- Integration testing

## Customization Guide

### 1. Template Overrides
Client applications can override any component template by creating the same file path in their `app/views` directory. Rails' view lookup will prioritize the application's version.

#### Example: Customizing a Form Field
To override the default field template, create:
```
app/views/okonomi/forms/tailwind/_field.html.erb
```

The original template structure can be found at:
```
gem_path/app/views/okonomi/forms/tailwind/_field.html.erb
```

### 2. Style Customization
Customize component styles by creating config classes:

```ruby
# app/helpers/okonomi_ui_kit/configs/button_base.rb
module OkonomiUiKit
  module Configs
    class ButtonBase < OkonomiUiKit::Config
      register_styles :default do
        {
          root: "custom-button-classes",
          contained: {
            colors: {
              primary: "bg-brand-500 hover:bg-brand-600"
            }
          }
        }
      end
    end
  end
end
```

For detailed customization instructions, see the [Style Override Guide](guides/style-overrides-guide.md).

### 3. Stimulus Controller Extension
Extend or replace Stimulus controllers by registering your own:

```javascript
// app/javascript/controllers/custom_dropdown_controller.js
import DropdownController from "okonomi_ui_kit/controllers/dropdown_controller"

export default class extends DropdownController {
  connect() {
    super.connect()
    // Add custom behavior
  }
}

// Register with a different identifier
application.register("custom-dropdown", CustomDropdownController)
```

## Key Implementation Details

### Form Builder Usage
The custom FormBuilder extends Rails' default with Tailwind-styled components:
```ruby
# In views, use with form_with
form_with model: @user, builder: OkonomiUiKit::FormBuilder do |f|
  f.field_set do
    f.field :email do
      f.email_field :email
    end
  end
end
```

### Helper Module Access
All helper modules are automatically included in ActionView, accessible via:
```ruby
ui.button("Click me", variant: :primary)
ui.badge("New", color: :success)
ui.link_to("Home", root_path, variant: :outlined, color: :primary)
```

### Asset Pipeline
The gem provides:
- JavaScript via Importmap: `okonomi_ui_kit_manifest.js`
- CSS via Tailwind: `okonomi_ui_kit/application.tailwind.css`

Include in your application:
```erb
<%= stylesheet_link_tag "okonomi_ui_kit/application.tailwind", "data-turbo-track": "reload" %>
<%= javascript_importmap_tags "okonomi_ui_kit" %>
```

## Dependencies
- Rails >= 8.0.0
- Tailwind CSS (via tailwindcss-rails)
- Turbo Rails
- Stimulus Rails
- Importmap Rails