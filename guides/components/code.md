# Code Component Guide

The Code component provides a consistent way to display code snippets, commands, and technical content with syntax highlighting support and multiple display variants.

## Basic Usage

#### Simple Code Block
```erb
<%= ui.code "puts 'Hello, World!'" %>
```

#### Code Block with Language
```erb
<%= ui.code "console.log('Hello, World!');", language: "javascript" %>
```

#### Code Block with Block Syntax
```erb
<%= ui.code do %>
def greet(name)
  puts "Hello, #{name}!"
end
<% end %>
```

## Customization Options

| Option | Type/Values | Purpose |
|--------|-------------|---------|
| language | String | Sets the programming language for syntax highlighting |
| lang | String | Alias for language |
| variant | :default, :inline, :minimal | Controls the display style |
| size | :xs, :sm, :default, :lg | Sets the font size |
| wrap | Boolean | Enables/disables line wrapping (default: true) |
| class | String | Additional CSS classes |
| id | String | HTML id attribute |
| data | Hash | Data attributes |

## Advanced Features

#### Inline Code
```erb
To install the gem, run <%= ui.code "gem install rails", variant: :inline %> in your terminal.
```

#### Minimal Code Block
```erb
<%= ui.code "SELECT * FROM users WHERE active = true", variant: :minimal, language: "sql" %>
```

#### Large Code Block with Custom Styling
```erb
<%= ui.code language: "ruby", size: :lg, class: "shadow-xl" do %>
class User < ApplicationRecord
  has_many :posts
  has_many :comments
  
  validates :email, presence: true, uniqueness: true
  
  def full_name
    "#{first_name} #{last_name}"
  end
end
<% end %>
```

## Styling

#### Default Styles

The code component includes these default Tailwind classes based on variant:
- Default variant: `bg-gray-900 text-gray-100 p-4 rounded-lg`
- Inline variant: `bg-gray-100 text-gray-900 px-1 py-0.5 rounded text-sm font-mono`
- Minimal variant: `bg-gray-900 text-gray-100 p-3 rounded text-xs`

Additional styling:
- Font sizes: xs (text-xs), sm (text-sm), default (text-sm), lg (text-base)
- Wrap behavior: `overflow-x-auto` when enabled, `overflow-hidden` when disabled

#### Customizing Styles

You can customize the appearance by creating a custom config:

```ruby
# app/helpers/okonomi_ui_kit/configs/code.rb
module OkonomiUiKit
  module Configs
    class Code < OkonomiUiKit::Config
      register_styles :custom do
        {
          base: "bg-slate-800 text-slate-100 rounded-xl shadow-inner",
          variants: {
            default: "p-4 rounded-lg",
            inline: "px-1 py-0.5 rounded text-sm font-mono",
            minimal: "p-3 rounded text-xs"
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
OkonomiUiKit::Components::Code.use_config(:custom)
```

## Best Practices

1. **Language Specification**: Always specify the language for better syntax highlighting support
2. **Variant Selection**: Use inline for short snippets within text, minimal for commands, default for code examples
3. **HTML Escaping**: The component automatically escapes HTML entities to prevent XSS
4. **Line Wrapping**: Disable wrapping for code where horizontal scrolling is preferred
5. **Copy Functionality**: Consider adding copy-to-clipboard functionality via data attributes

## Accessibility

The code component is built with accessibility in mind:
- Uses semantic `<pre>` and `<code>` elements
- Maintains proper contrast ratios for readability
- Supports keyboard navigation for scrollable content
- Language attribute aids screen readers in pronunciation

## Examples

#### Terminal Commands
```erb
<div class="space-y-2">
  <p>To get started, run these commands:</p>
  <%= ui.code "git clone https://github.com/user/repo.git", variant: :minimal %>
  <%= ui.code "cd repo && bundle install", variant: :minimal %>
  <%= ui.code "rails server", variant: :minimal %>
</div>
```

#### Configuration Example
```erb
<div class="prose">
  <p>Add this to your <%= ui.code "config/application.rb", variant: :inline %> file:</p>
  <%= ui.code language: "ruby" do %>
config.time_zone = 'Eastern Time (US & Canada)'
config.eager_load_paths << Rails.root.join('lib')
config.active_record.strict_loading_by_default = true
  <% end %>
</div>
```

#### API Response Display
```erb
<div class="bg-white p-6 rounded-lg shadow">
  <h3 class="text-lg font-medium mb-4">API Response</h3>
  <%= ui.code language: "json", size: :sm do %>
{
  "status": "success",
  "data": {
    "id": 123,
    "name": "John Doe",
    "email": "john@example.com",
    "roles": ["admin", "user"]
  },
  "meta": {
    "timestamp": "2024-01-15T10:30:00Z"
  }
}
  <% end %>
</div>
```

#### Code Comparison
```erb
<div class="grid grid-cols-2 gap-4">
  <div>
    <h4 class="font-medium mb-2">Before</h4>
    <%= ui.code language: "ruby", variant: :minimal do %>
users = User.all
users.each { |u| u.process }
    <% end %>
  </div>
  <div>
    <h4 class="font-medium mb-2">After</h4>
    <%= ui.code language: "ruby", variant: :minimal do %>
User.find_each(&:process)
    <% end %>
  </div>
</div>
```

#### Documentation Code Snippets
```erb
<section class="documentation">
  <h2>Usage Example</h2>
  <p>Here's how to use the <%= ui.code "UserService", variant: :inline %> class:</p>
  
  <%= ui.code language: "ruby", class: "mb-4" do %>
# Initialize the service
service = UserService.new(current_user)

# Perform an action
result = service.update_profile(
  name: "Jane Doe",
  email: "jane@example.com"
)

# Check the result
if result.success?
  puts "Profile updated successfully!"
else
  puts "Error: #{result.error_message}"
end
  <% end %>
  
  <p class="text-sm text-gray-600">
    Note: The service automatically handles validation and error logging.
  </p>
</section>
```