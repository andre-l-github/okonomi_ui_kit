# MultiSelect Component Guide

The MultiSelect component provides a grid-based interface for selecting multiple related records through checkboxes, with automatic association handling.

## Basic Usage

#### Simple Multi-Select
```erb
<%= form_with model: @user, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :skills do %>
    <%= f.multi_select :skills %>
  <% end %>
<% end %>
```

#### With Custom Collection
```erb
<%= f.multi_select :categories, collection: @available_categories %>
```

#### With Custom Label Field
```erb
<%= f.multi_select :tags, label: :title %>
```

## Requirements

The MultiSelect component requires:
1. An Active Record association (has_many, has_and_belongs_to_many)
2. A collection of records to choose from
3. A label method on the associated model (defaults to `:name`)

## Customization Options

| Option | Type | Purpose |
|--------|------|---------|
| collection | Array/ActiveRecord::Relation | Records to display as options |
| label | Symbol | Method to call on each record for display text |

## Advanced Features

#### Custom Label Method
```erb
<%= f.multi_select :categories, label: :display_name %>
<%= f.multi_select :products, label: :full_title %>
<%= f.multi_select :users, label: :full_name %>
```

#### Filtered Collections
```erb
<%= f.multi_select :skills, 
    collection: Skill.active.order(:name) %>

<%= f.multi_select :categories, 
    collection: Category.where(active: true).includes(:parent) %>
```

#### Conditional Multi-Select
```erb
<% if @user.premium? %>
  <%= f.field :premium_features do %>
    <%= f.multi_select :premium_features, 
        collection: Feature.premium %>
  <% end %>
<% end %>
```

#### Scoped by Context
```erb
<%= f.multi_select :team_members, 
    collection: @project.available_team_members %>

<%= f.multi_select :permissions, 
    collection: Permission.for_role(@user.role) %>
```

#### With JavaScript Enhancement
```erb
<%= f.multi_select :interests,
    collection: Interest.all,
    data: {
      controller: "multi-select-filter",
      multi_select_filter_searchable: true
    } %>
```

## Styling

#### Default Styles

The MultiSelect component includes these style classes:
- Wrapper: `grid grid-cols-2 gap-2`
- Item: `flex items-center`

#### Customizing Styles

Override the default styles in your configuration:

```ruby
# In your initializer
module OkonomiUiKit
  module Components
    module Forms
      class MultiSelect
        register_styles :custom do
          {
            wrapper: "grid grid-cols-3 gap-4 p-4 bg-gray-50 rounded-lg",
            item: "flex items-center space-x-3 p-2 hover:bg-white rounded-md"
          }
        end
      end
    end
  end
end
```

Or use runtime theme switching:

```erb
<% ui.theme(components: { forms: { multi_select: { 
  wrapper: "grid grid-cols-1 gap-3",
  item: "border border-gray-200 rounded-lg p-3"
} } }) do %>
  <%= f.multi_select :skills %>
<% end %>
```

#### Responsive Layout
```erb
<%= f.multi_select :categories,
    class: "grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4" %>
```

## Best Practices

1. **Association Setup**: Ensure proper has_many or HABTM associations
2. **Performance**: Use includes() to avoid N+1 queries
3. **Ordering**: Order collections consistently
4. **Labels**: Use descriptive label methods
5. **Filtering**: Filter collections to relevant options
6. **Responsive Design**: Consider mobile layout with single columns

## Accessibility

The MultiSelect component ensures accessibility by:
- Using semantic checkbox inputs
- Proper label associations
- Keyboard navigation support
- Screen reader compatibility
- Clear visual grouping
- Focus management

## Examples

#### User Skills Selection
```erb
<!-- Model setup -->
<!-- 
class User < ApplicationRecord
  has_and_belongs_to_many :skills
end

class Skill < ApplicationRecord
  has_and_belongs_to_many :users
  
  scope :active, -> { where(active: true) }
  scope :by_category, ->(cat) { where(category: cat) }
end
-->

<%= form_with model: @user, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <h3>Technical Skills</h3>
    <%= f.field :skills do %>
      <%= f.multi_select :skills, 
          collection: Skill.active.order(:name),
          class: "grid grid-cols-2 md:grid-cols-3 gap-3" %>
    <% end %>
  <% end %>
<% end %>
```

#### Project Team Assignment
```erb
<%= form_with model: @project, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :team_members do %>
    <%= f.multi_select :team_members,
        collection: User.active.order(:last_name, :first_name),
        label: :full_name %>
  <% end %>
  
  <%= f.field :project_managers do %>
    <%= f.multi_select :project_managers,
        collection: User.managers.order(:last_name),
        label: :full_name %>
  <% end %>
<% end %>
```

#### Content Categorization
```erb
<%= form_with model: @article, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <h3>Content Classification</h3>
    
    <%= f.field :categories do %>
      <%= f.multi_select :categories,
          collection: Category.published.order(:name),
          class: "grid grid-cols-1 md:grid-cols-2 gap-2" %>
    <% end %>
    
    <%= f.field :tags do %>
      <%= f.multi_select :tags,
          collection: Tag.popular.limit(20),
          label: :display_name,
          class: "grid grid-cols-3 md:grid-cols-4 gap-2" %>
    <% end %>
  <% end %>
<% end %>
```

#### Role-Based Permissions
```erb
<%= form_with model: @user, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <h3>User Permissions</h3>
    <p class="text-gray-600 mb-4">Select the permissions for this user role</p>
    
    <%= f.field :permissions do %>
      <%= f.multi_select :permissions,
          collection: Permission.for_role(@user.role).order(:category, :name),
          label: :description,
          class: "grid grid-cols-1 gap-3" %>
    <% end %>
  <% end %>
<% end %>
```

#### Product Features Selection
```erb
<%= form_with model: @product, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set class: "space-y-6" do %>
    <div>
      <h3>Standard Features</h3>
      <%= f.field :standard_features do %>
        <%= f.multi_select :standard_features,
            collection: Feature.standard.order(:name),
            class: "grid grid-cols-2 gap-2" %>
      <% end %>
    </div>
    
    <div>
      <h3>Premium Features</h3>
      <%= f.field :premium_features do %>
        <%= f.multi_select :premium_features,
            collection: Feature.premium.order(:name),
            class: "grid grid-cols-2 gap-2" %>
      <% end %>
    </div>
  <% end %>
<% end %>
```

#### Event Registration Preferences
```erb
<%= form_with model: @registration, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <h3>Session Preferences</h3>
    <p class="text-gray-600 mb-4">Select the sessions you'd like to attend</p>
    
    <%= f.field :sessions do %>
      <%= f.multi_select :sessions,
          collection: @event.sessions.order(:start_time),
          label: :title_with_time,
          class: "grid grid-cols-1 gap-3" %>
    <% end %>
  <% end %>
  
  <%= f.field_set do %>
    <h3>Dietary Preferences</h3>
    <%= f.field :dietary_restrictions do %>
      <%= f.multi_select :dietary_restrictions,
          collection: DietaryRestriction.common,
          class: "grid grid-cols-2 md:grid-cols-3 gap-2" %>
    <% end %>
  <% end %>
<% end %>
```

#### Survey Interest Areas
```erb
<%= form_with model: @survey_response, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :interest_areas do %>
    <h3 class="mb-3">What topics interest you most?</h3>
    <p class="text-gray-600 mb-4">Select all that apply</p>
    
    <%= f.multi_select :interest_areas,
        collection: InterestArea.active.order(:name),
        class: "grid grid-cols-1 md:grid-cols-2 gap-3" %>
  <% end %>
  
  <%= f.field :communication_preferences do %>
    <h3 class="mb-3">How would you like to hear from us?</h3>
    
    <%= f.multi_select :communication_preferences,
        collection: CommunicationMethod.all,
        label: :description,
        class: "grid grid-cols-1 gap-2" %>
  <% end %>
<% end %>
```

#### Advanced with Grouping
```erb
<%= form_with model: @user, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <h3>Skills by Category</h3>
    
    <% %w[frontend backend devops design].each do |category| %>
      <div class="mb-6">
        <h4 class="text-md font-semibold mb-3 capitalize"><%= category %> Skills</h4>
        <%= f.field "#{category}_skills".to_sym do %>
          <%= f.multi_select :skills,
              collection: Skill.by_category(category).order(:name),
              class: "grid grid-cols-2 md:grid-cols-3 gap-2" %>
        <% end %>
      </div>
    <% end %>
  <% end %>
<% end %>
```

#### With Search and Filter
```erb
<%= form_with model: @project, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :contributors do %>
    <div data-controller="multi-select-search">
      <input type="text" 
             placeholder="Search users..." 
             data-multi-select-search-target="input"
             data-action="input->multi-select-search#filter"
             class="mb-4 w-full px-3 py-2 border rounded-md">
      
      <div data-multi-select-search-target="container">
        <%= f.multi_select :contributors,
            collection: User.active.order(:last_name, :first_name),
            label: :full_name,
            class: "grid grid-cols-1 md:grid-cols-2 gap-2" %>
      </div>
    </div>
  <% end %>
<% end %>
```