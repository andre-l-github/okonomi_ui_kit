# Task

Look at all components in app/helpers/okonomi_ui_kit/components and check if a user guide already exists for each component.

1. If a user guide does not exist, create one following the structure outlined in below.
2. If a user guide already exists, ensure it is up-to-date with the latest component features and usage patterns and that it follows the structure outlined below.

# Document Structure

## Instructions for Creating Component User Guides

When creating a user guide for a new OkonomiUiKit component, follow this structure to ensure consistency across all documentation.

### Document Structure Template

#### 1. Title and Introduction
- Use format: "# [Component Name] Component Guide" or "# [Component Name]"
- Write 1-2 sentences describing the component's purpose and main functionality
- Mention any key benefits or use cases

Example:
```markdown
# Button Component Guide

The Button component provides a consistent way to render interactive buttons throughout your application, supporting multiple variants, sizes, and states.
```

#### 2. Basic Usage Section
- Start with "## Basic Usage"
- Show the simplest possible example with erb code blocks
- Include 2-3 progressively complex basic examples
- Use descriptive subsection headings

Structure:
```markdown
## Basic Usage

#### Simple [Component]
```erb
<%= ui.component_name "Basic example" %>
```

#### With Common Options
```erb
<%= ui.component_name "Example", option: value %>
```
```

#### 3. Customization/Configuration Options
- Title as "## Customization Options", "## Available Options", or component-specific title
- List all available parameters/options
- Use tables for listing options when appropriate
- Show code examples for each major option

Table format:
```markdown
| Option | Type/Values | Purpose |
|--------|-------------|---------|
| variant | :primary, :secondary | Controls visual style |
| size | :sm, :md, :lg | Sets component size |
```

#### 4. Advanced Features/Usage
- Title as "## Advanced Features" or "## Advanced Usage"
- Show complex combinations of options
- Include block syntax examples if supported
- Demonstrate integration with other components

Example structure:
```markdown
## Advanced Features

#### Block Content
```erb
<%= ui.component do |builder| %>
  <% builder.part "content" %>
<% end %>
```

#### Integration with Other Components
```erb
<%= ui.parent_component do %>
  <%= ui.child_component %>
<% end %>
```
```

#### 5. Styling Information
- Include "## Styling" or "## Default Styles"
- Document default Tailwind classes applied
- Show style customization examples using config classes
- Document the component's registered styles structure

Template:
```markdown
## Styling

#### Default Styles

The component includes these default Tailwind classes:
- Base: `class-list-here`
- Variants: specific variant classes

#### Customizing Styles

You can customize the appearance by creating a config class:

```ruby
# app/helpers/okonomi_ui_kit/configs/component_name.rb
module OkonomiUiKit
  module Configs
    class ComponentName < OkonomiUiKit::Config
      register_styles :default do
        {
          base: "custom-classes",
          variants: {
            primary: "variant-classes"
          }
        }
      end
    end
  end
end
```
```

#### 6. Best Practices
- Title as "## Best Practices"
- Number each practice
- Keep practices concise and actionable
- Focus on common mistakes to avoid

Format:
```markdown
## Best Practices

1. **Practice Title**: Brief explanation
2. **Another Practice**: Why it's important
3. **Common Pitfall**: What to avoid
```

#### 7. Accessibility
- Title as "## Accessibility" or "## Accessibility Considerations"
- List semantic HTML elements used
- Document ARIA attributes
- Mention keyboard navigation support if applicable

Template:
```markdown
## Accessibility

The component is built with accessibility in mind:
- Uses semantic HTML elements (`<element>`)
- Includes appropriate ARIA attributes
- Supports keyboard navigation
- Maintains proper focus management
```

#### 8. Real-World Examples
- Title as "## Examples" or "## Examples in Context"
- Provide 3-5 contextual examples
- Use descriptive subsection headings
- Show the component within realistic page layouts

Structure:
```markdown
## Examples

#### E-commerce Product Card
```erb
<%= ui.component within: :product_context do %>
  <!-- realistic example -->
<% end %>
```

#### Admin Dashboard Widget
```erb
<!-- another contextual example -->
```
```

## Writing Guidelines

#### Code Examples
- Use `erb` syntax highlighting for all Rails code examples
- Keep examples concise but complete
- Use meaningful variable names (@product, @user, etc.)
- Include HTML output comments when helpful

#### Language and Style
- Write in present tense
- Use active voice
- Keep sentences concise
- Avoid jargon without explanation

#### Cross-References
- Reference other guides with relative links
- Link to related components when relevant
- Include links to external resources sparingly

#### Component-Specific Sections
Some components may need additional sections:
- **Configuration**: For components with complex setup
- **Events**: For components with JavaScript interactions
- **States**: For components with multiple states
- **Validation**: For form-related components

## Checklist for New Component Guides

Before publishing a new component guide, ensure:

- [ ] Title follows the naming convention
- [ ] Introduction clearly explains the component's purpose
- [ ] Basic usage examples are simple and clear
- [ ] All available options are documented
- [ ] Advanced examples show realistic use cases
- [ ] Styling section includes customization examples
- [ ] Best practices are actionable
- [ ] Accessibility features are documented
- [ ] Real-world examples are contextual
- [ ] Code examples are tested and working
- [ ] Language is consistent with other guides
- [ ] No broken links or references

## Example Outline

Here's a complete outline for a hypothetical "Card" component:

```markdown
# Card Component Guide

The Card component provides a flexible container for grouping related content with optional headers, footers, and actions.

## Basic Usage

#### Simple Card
[example code]

#### Card with Header
[example code]

## Customization Options

| Option | Type | Purpose |
|--------|------|---------|
| variant | Symbol | Visual style |
| padding | Symbol | Internal spacing |

[more options and examples]

## Advanced Features

#### Nested Cards
[example code]

#### Card with Actions
[example code]

## Styling

#### Default Styles
[style documentation]

#### Style Customization
[customization examples]

## Best Practices

1. **Consistent Spacing**: Use standard padding options
2. **Semantic Structure**: Include proper headings
3. **Responsive Design**: Test on multiple screen sizes

## Accessibility

- Uses `<article>` element for semantic structure
- Includes proper heading hierarchy
- Supports keyboard navigation for interactive elements

## Examples

#### Blog Post Card
[contextual example]

#### Product Display Card
[contextual example]

#### Dashboard Metric Card
[contextual example]
```

This structure ensures consistency while allowing flexibility for component-specific details.