# Select Component Guide

The Select component provides a styled dropdown select with automatic icon decoration, error handling, and Rails integration.

## Basic Usage

#### Simple Select
```erb
<%= form_with model: @user, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :status do %>
    <%= f.select :status, [
      ['Active', 'active'],
      ['Inactive', 'inactive']
    ] %>
  <% end %>
<% end %>
```

#### Select with Prompt
```erb
<%= f.select :category, 
    options_from_collection_for_select(Category.all, :id, :name),
    { prompt: 'Choose a category' } %>
```

#### Select from Collection
```erb
<%= f.select :user_id,
    options_from_collection_for_select(User.all, :id, :name),
    { prompt: 'Select user' } %>
```

## Customization Options

| Option | Type | Purpose |
|--------|------|---------|
| choices | Array | Array of [label, value] pairs |
| options | Hash | Rails select options (prompt, selected, etc.) |
| html_options | Hash | HTML attributes (class, data, etc.) |

## Advanced Features

#### Grouped Options
```erb
<%= f.select :product_id, grouped_options_for_select([
  ['Electronics', [
    ['Phone', 1],
    ['Laptop', 2]
  ]],
  ['Clothing', [
    ['Shirt', 3],
    ['Pants', 4]
  ]]
]) %>
```

#### Multiple Selection
```erb
<%= f.select :skill_ids,
    options_from_collection_for_select(Skill.all, :id, :name),
    {},
    { multiple: true, size: 5 } %>
```

#### Dynamic Options with JavaScript
```erb
<%= f.select :state, [], 
    { prompt: 'Select state' },
    { 
      data: {
        controller: "dependent-select",
        dependent_select_url_value: states_path
      }
    } %>
```

#### Searchable Select
```erb
<%= f.select :user_id,
    options_from_collection_for_select(User.all, :id, :full_name),
    { prompt: 'Search for user' },
    {
      data: {
        controller: "searchable-select",
        searchable_select_placeholder: "Type to search users..."
      }
    } %>
```

#### Conditional Options
```erb
<%= f.select :role,
    current_user.admin? ? admin_role_options : user_role_options,
    { prompt: 'Select role' } %>
```

## Styling

#### Default Styles

The Select component includes these style classes:
- Wrapper: `relative`
- Root: `w-full appearance-none border-0 pl-3 pr-10 py-2 rounded-md ring-1 focus:outline-none focus-within:ring-1`
- Error: `bg-danger-100 text-danger-400 ring-danger-400 focus:ring-danger-600`
- Valid: `text-default-700 ring-gray-300 focus-within:ring-gray-400`
- Icon: `absolute right-2 top-1/2 -translate-y-1/2 size-5 text-gray-400 pointer-events-none`

#### Customizing Styles

Override the default styles in your configuration:

```ruby
# In your initializer
module OkonomiUiKit
  module Components
    module Forms
      class Select
        register_styles :custom do
          {
            wrapper: "relative inline-block w-full",
            root: "w-full px-4 py-3 border-2 border-gray-200 rounded-lg pr-10",
            error: "border-red-500 bg-red-50 text-red-900",
            valid: "border-gray-200 focus:border-blue-500",
            icon: {
              file: "heroicons/mini/chevron-down",
              class: "absolute right-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400"
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
<% ui.theme(components: { forms: { select: { 
  root: "rounded-xl border-2",
  icon: { class: "w-6 h-6 text-blue-500" }
} } }) do %>
  <%= f.select :category, category_options %>
<% end %>
```

## Best Practices

1. **Clear Labels**: Use descriptive option labels
2. **Logical Ordering**: Order options alphabetically or by relevance
3. **Appropriate Prompts**: Use helpful prompt text
4. **Performance**: Consider lazy loading for large option sets
5. **Accessibility**: Ensure proper label associations
6. **Mobile UX**: Test dropdown behavior on mobile devices

## Accessibility

The Select component ensures accessibility by:
- Using semantic HTML select elements
- Supporting keyboard navigation (Tab, Arrow keys, Enter, Space)
- Providing clear label associations
- Including proper ARIA attributes for error states
- Working with screen readers
- Supporting option group navigation
- Showing visual focus indicators
- Maintaining semantic option relationships

## Examples

#### User Profile Form
```erb
<%= form_with model: @user, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <h3>Personal Information</h3>
    
    <%= f.field :title do %>
      <%= f.select :title, [
        ['Mr.', 'mr'],
        ['Ms.', 'ms'],
        ['Mrs.', 'mrs'],
        ['Dr.', 'dr'],
        ['Prof.', 'prof']
      ], { prompt: 'Select title (optional)' } %>
    <% end %>
    
    <%= f.field :country do %>
      <%= f.select :country,
          options_from_collection_for_select(Country.all, :code, :name, @user.country),
          { prompt: 'Select country' },
          { 
            data: {
              controller: "country-select",
              action: "change->country-select#updateStates"
            }
          } %>
    <% end %>
    
    <%= f.field :state do %>
      <%= f.select :state, [],
          { prompt: 'Select state/province' },
          {
            data: {
              country_select_target: "states"
            }
          } %>
    <% end %>
    
    <%= f.field :timezone do %>
      <%= f.select :timezone,
          time_zone_options_for_select(@user.timezone),
          { prompt: 'Select timezone' } %>
    <% end %>
  <% end %>
<% end %>
```

#### E-commerce Product Configuration
```erb
<%= form_with model: @product, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :category do %>
    <%= f.select :category_id,
        grouped_options_for_select(category_groups),
        { prompt: 'Choose product category' } %>
  <% end %>
  
  <%= f.field :status do %>
    <%= f.select :status, [
      ['Draft', 'draft'],
      ['Active', 'active'],
      ['Discontinued', 'discontinued']
    ], { selected: @product.status } %>
  <% end %>
  
  <%= f.field :visibility do %>
    <%= f.select :visibility, [
      ['Public', 'public'],
      ['Private', 'private'],
      ['Members Only', 'members']
    ], { prompt: 'Who can see this product?' } %>
  <% end %>
  
  <%= f.field :tags do %>
    <%= f.select :tag_ids,
        options_from_collection_for_select(Tag.all, :id, :name, @product.tag_ids),
        {},
        { 
          multiple: true,
          size: 6,
          data: {
            controller: "multi-select",
            multi_select_search: true
          }
        } %>
  <% end %>
<% end %>
```

#### Order Management
```erb
<%= form_with model: @order, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :priority do %>
    <%= f.select :priority, [
      ['Low', 'low'],
      ['Normal', 'normal'],
      ['High', 'high'],
      ['Urgent', 'urgent']
    ], { selected: 'normal' } %>
  <% end %>
  
  <%= f.field :shipping_method do %>
    <%= f.select :shipping_method_id,
        options_from_collection_for_select(
          ShippingMethod.available_for(@order),
          :id,
          :name_with_price,
          @order.shipping_method_id
        ),
        { prompt: 'Choose shipping method' },
        {
          data: {
            controller: "shipping-calculator",
            action: "change->shipping-calculator#updateTotal"
          }
        } %>
  <% end %>
  
  <%= f.field :payment_method do %>
    <%= f.select :payment_method, [
      ['Credit Card', 'credit_card'],
      ['PayPal', 'paypal'],
      ['Bank Transfer', 'bank_transfer'],
      ['Cash on Delivery', 'cod']
    ], { prompt: 'Select payment method' } %>
  <% end %>
<% end %>
```

#### Event Registration
```erb
<%= form_with model: @registration, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :ticket_type do %>
    <%= f.select :ticket_type_id,
        options_from_collection_for_select(
          @event.ticket_types.available,
          :id,
          :name_with_price
        ),
        { prompt: 'Choose ticket type' },
        {
          data: {
            controller: "ticket-selector",
            action: "change->ticket-selector#updatePrice"
          }
        } %>
  <% end %>
  
  <%= f.field :dietary_requirements do %>
    <%= f.select :dietary_requirements, [
      ['None', 'none'],
      ['Vegetarian', 'vegetarian'],
      ['Vegan', 'vegan'],
      ['Gluten-free', 'gluten_free'],
      ['Other (please specify)', 'other']
    ], { prompt: 'Any dietary requirements?' } %>
  <% end %>
  
  <%= f.field :session_preference do %>
    <%= f.select :preferred_session_ids,
        options_from_collection_for_select(
          @event.sessions,
          :id,
          :title_with_time
        ),
        {},
        { 
          multiple: true,
          size: 5,
          data: {
            controller: "session-conflict-checker"
          }
        } %>
    <span class="text-sm text-gray-500">Hold Ctrl/Cmd to select multiple sessions</span>
  <% end %>
<% end %>
```

#### Settings and Preferences
```erb
<%= form_with model: @user_preferences, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <h3>Display Preferences</h3>
    
    <%= f.field :theme do %>
      <%= f.select :theme, [
        ['Light', 'light'],
        ['Dark', 'dark'],
        ['Auto (system)', 'auto']
      ], { selected: @user_preferences.theme } %>
    <% end %>
    
    <%= f.field :language do %>
      <%= f.select :language,
          options_from_collection_for_select(
            Language.supported,
            :code,
            :name,
            @user_preferences.language
          ),
          { prompt: 'Choose language' } %>
    <% end %>
    
    <%= f.field :items_per_page do %>
      <%= f.select :items_per_page, [
        ['10 items', 10],
        ['25 items', 25],
        ['50 items', 50],
        ['100 items', 100]
      ], { selected: @user_preferences.items_per_page } %>
    <% end %>
  <% end %>
  
  <%= f.field_set do %>
    <h3>Notification Preferences</h3>
    
    <%= f.field :email_frequency do %>
      <%= f.select :email_frequency, [
        ['Never', 'never'],
        ['Daily', 'daily'],
        ['Weekly', 'weekly'],
        ['Monthly', 'monthly']
      ], { selected: @user_preferences.email_frequency } %>
    <% end %>
    
    <%= f.field :notification_types do %>
      <%= f.select :notification_type_ids,
          options_from_collection_for_select(
            NotificationType.all,
            :id,
            :description,
            @user_preferences.notification_type_ids
          ),
          {},
          { multiple: true, size: 4 } %>
    <% end %>
  <% end %>
<% end %>
```

#### Survey Form
```erb
<%= form_with model: @survey_response, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :satisfaction_level do %>
    <%= f.select :satisfaction_level, [
      ['Very Dissatisfied', 1],
      ['Dissatisfied', 2],
      ['Neutral', 3],
      ['Satisfied', 4],
      ['Very Satisfied', 5]
    ], { prompt: 'How satisfied are you?' } %>
  <% end %>
  
  <%= f.field :recommendation_likelihood do %>
    <%= f.select :recommendation_likelihood,
        (0..10).map { |i| ["#{i}#{i == 0 ? ' - Not at all likely' : i == 10 ? ' - Extremely likely' : ''}", i] },
        { prompt: 'How likely are you to recommend us?' } %>
  <% end %>
  
  <%= f.field :age_group do %>
    <%= f.select :age_group, [
      ['18-24', '18-24'],
      ['25-34', '25-34'],
      ['35-44', '35-44'],
      ['45-54', '45-54'],
      ['55-64', '55-64'],
      ['65+', '65+']
    ], { prompt: 'Age group (optional)' } %>
  <% end %>
<% end %>
```

#### Advanced Search Form
```erb
<%= form_with url: search_path, method: :get, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <h3>Filter Results</h3>
    
    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
      <%= f.field :category do %>
        <%= f.select :category,
            options_from_collection_for_select(Category.all, :slug, :name),
            { prompt: 'All Categories' },
            {
              data: {
                controller: "search-filter",
                action: "change->search-filter#updateResults"
              }
            } %>
      <% end %>
      
      <%= f.field :sort_by do %>
        <%= f.select :sort, [
          ['Relevance', 'relevance'],
          ['Date (Newest)', 'date_desc'],
          ['Date (Oldest)', 'date_asc'],
          ['Price (Low to High)', 'price_asc'],
          ['Price (High to Low)', 'price_desc'],
          ['Rating', 'rating']
        ], { selected: params[:sort] } %>
      <% end %>
      
      <%= f.field :availability do %>
        <%= f.select :availability, [
          ['All Items', ''],
          ['In Stock Only', 'in_stock'],
          ['On Sale', 'on_sale'],
          ['New Arrivals', 'new']
        ], { selected: params[:availability] } %>
      <% end %>
    </div>
  <% end %>
<% end %>
```