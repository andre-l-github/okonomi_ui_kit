# CollectionSelect Component Guide

The CollectionSelect component provides a styled dropdown select input for choosing from ActiveRecord collections, with automatic error handling and consistent styling.

## Basic Usage

#### Simple Collection Select
```erb
<%= form_with model: @post, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :author do %>
    <%= f.collection_select :author_id, User.all, :id, :name %>
  <% end %>
<% end %>
```

#### With Prompt Option
```erb
<%= f.collection_select :category_id, 
    Category.all, 
    :id, 
    :name, 
    { prompt: "Select a category..." } %>
```

#### With Default Selection
```erb
<%= f.collection_select :status, 
    Status.all, 
    :value, 
    :label, 
    { selected: "active" } %>
```

## Customization Options

| Parameter | Type | Purpose |
|-----------|------|---------|
| method | Symbol | The attribute name to bind to |
| collection | ActiveRecord::Relation/Array | The collection of objects to select from |
| value_method | Symbol | Method to call for option values |
| text_method | Symbol | Method to call for option display text |
| options | Hash | Rails select options (prompt, include_blank, selected, etc.) |
| html_options | Hash | HTML attributes (class, disabled, required, etc.) |

### Common Options

```erb
{
  prompt: "Select an option...",      # Add a prompt option
  include_blank: true,                # Add a blank option
  selected: value,                    # Pre-select a value
  disabled: -> (user) { !user.active? } # Disable specific options
}
```

## Advanced Features

#### Complex Display Text
```erb
<%= f.collection_select :assigned_to_id,
    User.active,
    :id,
    :name_with_email,
    { prompt: "Assign to user..." } %>

# In User model:
def name_with_email
  "#{name} (#{email})"
end
```

#### Grouped Collection Select
```erb
<%= f.grouped_collection_select :city_id,
    State.includes(:cities),
    :cities,
    :name,
    :id,
    :name,
    { prompt: "Select a city..." } %>
```

#### With Conditional Options
```erb
<%= f.collection_select :manager_id,
    User.where(role: "manager"),
    :id,
    :name,
    {
      prompt: "Select a manager...",
      disabled: -> (user) { user.on_leave? }
    } %>
```

#### Multiple Selection
```erb
<%= f.collection_select :tag_ids,
    Tag.all,
    :id,
    :name,
    { selected: @post.tag_ids },
    { multiple: true, size: 5 } %>
```

## Styling

#### Default Styles

The component applies these default Tailwind classes:
- Wrapper: `relative`
- Select: `w-full appearance-none border-0 pl-3 pr-10 py-2 rounded-md ring-1 focus:outline-none focus-within:ring-1`
- Valid state: `text-default-700 ring-gray-300 focus-within:ring-gray-400`
- Error state: `bg-danger-100 text-danger-400 ring-danger-400 focus:ring-danger-600`
- Chevron icon: `absolute right-2 top-1/2 -translate-y-1/2 size-5 text-gray-400`

#### Customizing Styles

Override the default styles in your configuration:

```ruby
# In your initializer
module OkonomiUiKit
  module Components
    module Forms
      class CollectionSelect
        register_styles :custom do
          {
            wrapper: "relative inline-block",
            root: "w-full px-4 py-3 border-2 border-gray-200 rounded-lg",
            valid: "border-gray-200 focus:border-blue-500",
            error: "border-red-500 bg-red-50",
            icon: {
              file: "heroicons/outline/chevron-down",
              class: "absolute right-3 top-1/2 -translate-y-1/2 size-6"
            }
          }
        end
      end
    end
  end
end
```

Or use runtime theme switching:

```erb
<% ui.theme(components: { forms: { collection_select: { 
  root: "rounded-xl shadow-sm" 
} } }) do %>
  <%= f.collection_select :user_id, User.all, :id, :name %>
<% end %>
```

## Best Practices

1. **Use Scopes**: Leverage ActiveRecord scopes for filtered collections
2. **Include Relationships**: Use `includes` to avoid N+1 queries
3. **Meaningful Prompts**: Provide clear prompt text that guides selection
4. **Order Collections**: Sort collections logically (alphabetically, by priority, etc.)
5. **Handle Nil Values**: Consider whether to include blank options
6. **Optimize Queries**: Only load necessary data for large collections

## Accessibility

The CollectionSelect component ensures accessibility by:
- Using semantic `<select>` elements
- Supporting keyboard navigation (arrow keys, typing to search)
- Maintaining proper label associations
- Including focus states for keyboard users
- Supporting screen reader announcements
- Showing clear error states

## Examples

#### User Assignment
```erb
<%= form_with model: @task, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :assigned_to do %>
    <%= f.collection_select :assigned_to_id,
        User.active.order(:name),
        :id,
        :name_with_role,
        { 
          prompt: "Assign to team member...",
          selected: @task.assigned_to_id
        } %>
  <% end %>
<% end %>
```

#### Product Category Selection
```erb
<%= form_with model: @product, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :category do %>
    <%= f.collection_select :category_id,
        Category.active.includes(:parent),
        :id,
        :full_path,
        {
          prompt: "Choose a category...",
          include_blank: false
        },
        {
          required: true,
          data: { controller: "category-select" }
        } %>
  <% end %>
<% end %>

# In Category model:
def full_path
  parent ? "#{parent.name} > #{name}" : name
end
```

#### Location Selection with Grouping
```erb
<%= form_with model: @store, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :location do %>
    <%= f.grouped_collection_select :city_id,
        Region.includes(:cities).order(:name),
        :cities,
        :name,
        :id,
        :name,
        {
          prompt: "Select city...",
          selected: @store.city_id
        } %>
  <% end %>
<% end %>
```

#### Role-Based Access Selection
```erb
<%= form_with model: @document, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <h3>Access Control</h3>
    
    <%= f.field :owner do %>
      <%= f.collection_select :owner_id,
          User.with_role(:admin),
          :id,
          :name,
          { prompt: "Select document owner..." } %>
    <% end %>
    
    <%= f.field :viewers do %>
      <%= f.collection_select :viewer_ids,
          User.active,
          :id,
          :name_with_department,
          { selected: @document.viewer_ids },
          { multiple: true, size: 6 } %>
    <% end %>
  <% end %>
<% end %>
```

#### Dynamic Filtering Example
```erb
<%= form_with model: @order, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :product do %>
    <%= f.collection_select :product_id,
        Product.available.where(category: @order.category),
        :id,
        :name_with_price,
        {
          prompt: "Select a product...",
          disabled: -> (product) { product.out_of_stock? }
        },
        {
          data: { 
            controller: "product-select",
            action: "change->order-form#updatePrice"
          }
        } %>
  <% end %>
<% end %>

# In Product model:
def name_with_price
  "#{name} - #{ActionController::Base.helpers.number_to_currency(price)}"
end
```