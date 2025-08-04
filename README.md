# OkonomiUiKit

A Rails Engine gem that provides customizable, Tailwind CSS-based UI components for Rails applications. Built with maximum flexibility in mind, OkonomiUiKit allows you to maintain consistent design patterns across projects while giving you complete control over styling and behavior.

## Features

- **🎨 Fully Customizable** - Override any component's styling through a powerful configuration system
- **🚀 Rails Native** - Built as a Rails Engine following Rails conventions
- **💨 Tailwind CSS** - Modern utility-first CSS with intelligent class merging
- **⚡ Stimulus Powered** - Progressive enhancement with Stimulus controllers
- **🔧 Form Builder** - Enhanced form helpers with consistent styling
- **📦 Component Library** - Pre-built components including buttons, badges, tables, alerts, and more
- **🎯 Style System** - Component-based styling with config class overrides
- **🔄 Smart Style Merging** - Intelligent Tailwind class conflict resolution

## Installation

Add this line to your application's Gemfile:

```ruby
gem "okonomi_ui_kit"
```

And then execute:
```bash
$ bundle
```

In your application layout, include the CSS and JavaScript:

```erb
<%= stylesheet_link_tag "okonomi_ui_kit/application.tailwind", "data-turbo-track": "reload" %>
<%= javascript_importmap_tags "okonomi_ui_kit" %>
```

## Quick Start

### Using Components

OkonomiUiKit provides a `ui` helper that gives you access to all components:

```erb
<%= ui.button "Click me", variant: :contained, color: :primary %>
<%= ui.badge "New", color: :success %>
<%= ui.alert "Welcome to OkonomiUiKit!", variant: :info %>
```

### Using the Form Builder

```erb
<%= form_with model: @user, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <%= f.field :email do %>
      <%= f.email_field :email %>
    <% end %>
    
    <%= f.field :password do %>
      <%= f.password_field :password %>
    <% end %>
  <% end %>
  
  <%= f.submit "Sign Up", color: :primary %>
<% end %>
```

## Available Components

### Core Components
- **Button** - Buttons with multiple variants (contained, outlined, text)
- **Badge** - Status indicators and labels
- **Alert** - Notification messages with icons
- **Table** - Data tables with consistent styling
- **Typography** - Headings and text with predefined styles
- **Code** - Inline and block code display

### Form Components
- **Field** - Form field wrapper with label and error handling
- **FieldSet** - Group related form fields
- **Select** - Styled select dropdowns
- **Checkbox/Radio** - Enhanced checkboxes and radio buttons
- **File Upload** - Drag-and-drop file uploads

### Navigation Components
- **Dropdown** - Dropdown menus with Stimulus integration
- **Breadcrumbs** - Navigation breadcrumbs
- **Link** - Styled links with variants

## Customization

OkonomiUiKit is designed to be highly customizable. You can override component styles by creating configuration classes in your Rails application.

### Quick Example

```ruby
# app/helpers/okonomi_ui_kit/configs/button_base.rb
module OkonomiUiKit
  module Configs
    class ButtonBase < OkonomiUiKit::Config
      register_styles :default do
        {
          root: "font-semibold transition-all duration-200",
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

## Documentation

### Core Guides

- [Style Overrides Guide](guides/style-overrides-guide.md) - Complete guide to customizing component styles
- [Component Guide](docs/COMPONENT_GUIDE.md) - Creating custom components
- [CLAUDE.md](CLAUDE.md) - AI assistant instructions and architecture details

### Component Guides

#### Core UI Components
- [Alert](guides/components/alert.md) - Notification messages and alerts
- [Badge](guides/components/badge.md) - Status indicators and labels
- [Button Base](guides/components/button_base.md) - Base button component configuration
- [Button Tag](guides/components/button_tag.md) - Button element with styling
- [Button To](guides/components/button_to.md) - Rails button_to helper with styling
- [Code](guides/components/code.md) - Inline and block code display
- [Link To](guides/components/link_to.md) - Styled link components
- [Typography](guides/components/typography.md) - Text styling with semantic HTML elements

#### Layout Components
- [Page](guides/components/page.md) - Page layout structure
- [Table](guides/components/table.md) - Data tables with consistent styling

#### Navigation Components
- [Breadcrumbs](guides/components/breadcrumbs.md) - Navigation breadcrumb trails
- [Navigation](guides/components/navigation.md) - Sidebar navigation menus with groups and links

#### Interactive Components
- [Confirmation Modal](guides/components/confirmation_modal.md) - Accessible modal dialogs for user confirmations
- [Icon](guides/components/icon.md) - SVG icon rendering with style customization

#### Form Components
- [Forms Overview](guides/components/forms.md) - Form building guide and best practices
- [Check Box with Label](guides/components/forms/check_box_with_label.md) - Checkbox inputs with labels
- [Collection Select](guides/components/forms/collection_select.md) - Select from a collection
- [Date Field](guides/components/forms/date_field.md) - Date input fields
- [DateTime Local Field](guides/components/forms/datetime_local_field.md) - Date and time inputs
- [Email Field](guides/components/forms/email_field.md) - Email input validation
- [Field](guides/components/forms/field.md) - Form field wrapper
- [Field Set](guides/components/forms/field_set.md) - Group related form fields
- [Input Base](guides/components/forms/input_base.md) - Base input configuration
- [Label](guides/components/forms/label.md) - Form labels
- [Multi Select](guides/components/forms/multi_select.md) - Multiple selection inputs
- [Number Field](guides/components/forms/number_field.md) - Numeric inputs
- [Password Field](guides/components/forms/password_field.md) - Password inputs
- [Search Field](guides/components/forms/search_field.md) - Search input fields
- [Select](guides/components/forms/select.md) - Select dropdowns
- [Show If](guides/components/forms/show_if.md) - Conditional field visibility
- [Telephone Field](guides/components/forms/telephone_field.md) - Phone number inputs
- [Text Area](guides/components/forms/text_area.md) - Multi-line text inputs
- [Text Field](guides/components/forms/text_field.md) - Single-line text inputs
- [Time Field](guides/components/forms/time_field.md) - Time input fields
- [Upload Field](guides/components/forms/upload_field.md) - File upload fields
- [URL Field](guides/components/forms/url_field.md) - URL input validation


### Development

For development setup and commands, see [CLAUDE.md](CLAUDE.md#development-commands).

## Architecture Overview

OkonomiUiKit is built as a Rails Engine with:

- **Helper-based components** - Ruby methods that generate semantic HTML
- **Component style system** - Consistent styling with intelligent class merging  
- **Stimulus controllers** - Progressive enhancement for interactivity
- **Tailwind CSS integration** - Modern utility-first styling
- **Smart style merging** - Intelligent conflict resolution for Tailwind classes

## Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Setup

```bash
# Clone the repository
git clone https://github.com/yourusername/okonomi_ui_kit.git
cd okonomi_ui_kit

# Install dependencies
bundle install

# Start the development server
bin/dev

# Run tests
bin/rails test

# Run linter
bin/rubocop
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Credits

OkonomiUiKit is maintained by the Okonomi team. We're passionate about creating tools that make Rails development more enjoyable and productive.

## Support

- 📚 [Documentation](guides/)
- 🐛 [Issue Tracker](https://github.com/yourusername/okonomi_ui_kit/issues)
- 💬 [Discussions](https://github.com/yourusername/okonomi_ui_kit/discussions)