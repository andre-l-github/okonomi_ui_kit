# NumberField Component Guide

The NumberField component provides a styled numeric input with built-in validation, step controls, and mobile-optimized numeric keyboard support.

## Basic Usage

#### Simple Number Field
```erb
<%= form_with model: @product, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :price do %>
    <%= f.number_field :price %>
  <% end %>
<% end %>
```

#### With Constraints
```erb
<%= f.number_field :quantity, min: 1, max: 100, step: 1 %>
```

#### Decimal Numbers
```erb
<%= f.number_field :price, step: 0.01, min: 0 %>
```

## Customization Options

| Option | Type | Purpose |
|--------|------|---------|
| min | Number | Minimum allowed value |
| max | Number | Maximum allowed value |
| step | Number | Step increment (e.g., 0.01 for currency) |
| placeholder | String | Placeholder text |
| required | Boolean | Mark field as required |
| disabled | Boolean | Disable the input |
| readonly | Boolean | Make field read-only |
| class | String | Additional CSS classes |
| data | Hash | Data attributes for JavaScript |

## Advanced Features

#### Currency Input
```erb
<%= f.number_field :price,
    step: 0.01,
    min: 0,
    placeholder: "0.00",
    data: {
      controller: "currency-formatter",
      currency_formatter_symbol: "$"
    } %>
```

#### Quantity with Stock Validation
```erb
<%= f.number_field :quantity,
    min: 1,
    max: @product.stock_quantity,
    value: 1,
    data: {
      controller: "stock-validator",
      stock_validator_max_value: @product.stock_quantity
    } %>
```

#### Percentage Input
```erb
<%= f.number_field :discount_percentage,
    min: 0,
    max: 100,
    step: 0.1,
    placeholder: "0.0" %>
```

#### Rating Input
```erb
<%= f.number_field :rating,
    min: 1,
    max: 5,
    step: 0.5,
    data: {
      controller: "star-rating",
      star_rating_display_target: "stars"
    } %>
```

#### Dynamic Range
```erb
<%= f.number_field :budget,
    min: @project.minimum_budget,
    max: @project.maximum_budget,
    step: 100,
    value: @project.suggested_budget %>
```

## Styling

#### Default Styles

The NumberField inherits styles from InputBase:
- Base: `w-full border-0 px-3 py-2 rounded-md ring-1 focus:outline-none focus-within:ring-1`
- Valid state: `text-default-700 ring-gray-300 focus-within:ring-gray-400`
- Error state: `bg-danger-100 text-danger-400 ring-danger-400 focus:ring-danger-600`
- Disabled state: `disabled:bg-gray-50 disabled:cursor-not-allowed`

#### Customizing Styles

Override the default styles in your configuration:

```ruby
# In your initializer
module OkonomiUiKit
  module Components
    module Forms
      class NumberField
        register_styles :custom do
          {
            root: "w-full px-4 py-3 border-2 border-gray-200 rounded-lg text-right",
            valid: "border-gray-200 focus:border-blue-500",
            error: "border-red-500 bg-red-50 text-red-900",
            disabled: "bg-gray-100 text-gray-500 cursor-not-allowed"
          }
        end
      end
    end
  end
end
```

Or use runtime theme switching:

```erb
<% ui.theme(components: { forms: { number_field: { 
  root: "text-right font-mono" 
} } }) do %>
  <%= f.number_field :amount %>
<% end %>
```

## Best Practices

1. **Appropriate Constraints**: Set realistic min/max values
2. **Step Values**: Use appropriate step increments (0.01 for currency, 1 for quantities)
3. **Validation**: Combine client-side and server-side validation
4. **User Feedback**: Provide clear error messages for invalid ranges
5. **Mobile UX**: Leverage numeric keyboard on mobile devices
6. **Formatting**: Consider currency/number formatting for display

## Accessibility

The NumberField component ensures accessibility by:
- Using native HTML5 number input type
- Triggering numeric keyboards on mobile devices
- Supporting keyboard navigation (Tab, Arrow keys)
- Providing clear label associations
- Including proper ARIA attributes for error states
- Working with screen readers
- Supporting step controls via keyboard
- Showing visual focus indicators

## Examples

#### E-commerce Product Form
```erb
<%= form_with model: @product, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <h3>Product Details</h3>
    
    <%= f.field :price do %>
      <%= f.number_field :price,
          step: 0.01,
          min: 0,
          placeholder: "0.00",
          required: true %>
      <span class="text-sm text-gray-500">Price in USD</span>
    <% end %>
    
    <%= f.field :cost do %>
      <%= f.number_field :cost,
          step: 0.01,
          min: 0,
          placeholder: "0.00" %>
      <span class="text-sm text-gray-500">Cost basis for profit calculations</span>
    <% end %>
    
    <%= f.field :stock_quantity do %>
      <%= f.number_field :stock_quantity,
          min: 0,
          step: 1,
          placeholder: "0" %>
    <% end %>
    
    <%= f.field :reorder_level do %>
      <%= f.number_field :reorder_level,
          min: 0,
          step: 1,
          max: -> { f.object.stock_quantity } %>
      <span class="text-sm text-gray-500">Reorder when stock falls below this level</span>
    <% end %>
  <% end %>
<% end %>
```

#### Order Management
```erb
<%= form_with model: @order_item, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :quantity do %>
    <%= f.number_field :quantity,
        min: 1,
        max: @product.available_quantity,
        value: 1,
        step: 1,
        data: {
          controller: "order-calculator",
          order_calculator_price: @product.price,
          order_calculator_target: "quantity"
        } %>
    <span class="text-sm text-gray-500">
      Available: <%= @product.available_quantity %>
    </span>
  <% end %>
  
  <div class="mt-4 p-4 bg-gray-50 rounded-lg">
    <div class="flex justify-between">
      <span>Subtotal:</span>
      <span data-order-calculator-target="subtotal">$0.00</span>
    </div>
  </div>
<% end %>
```

#### Recipe and Cooking
```erb
<%= form_with model: @recipe, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :servings do %>
    <%= f.number_field :servings,
        min: 1,
        max: 50,
        value: 4,
        step: 1,
        data: {
          controller: "recipe-scaler",
          recipe_scaler_base_servings: 4
        } %>
    <span class="text-sm text-gray-500">Number of servings</span>
  <% end %>
  
  <%= f.field :prep_time do %>
    <%= f.number_field :prep_time,
        min: 0,
        step: 5,
        placeholder: "0" %>
    <span class="text-sm text-gray-500">Preparation time (minutes)</span>
  <% end %>
  
  <%= f.field :cook_time do %>
    <%= f.number_field :cook_time,
        min: 0,
        step: 5,
        placeholder: "0" %>
    <span class="text-sm text-gray-500">Cooking time (minutes)</span>
  <% end %>
<% end %>
```

#### Financial Planning
```erb
<%= form_with model: @budget, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <h3>Monthly Budget</h3>
    
    <%= f.field :monthly_income do %>
      <%= f.number_field :monthly_income,
          step: 0.01,
          min: 0,
          placeholder: "0.00",
          class: "text-right font-mono" %>
    <% end %>
    
    <%= f.field :housing_expense do %>
      <%= f.number_field :housing_expense,
          step: 0.01,
          min: 0,
          max: -> { f.object.monthly_income * 0.5 },
          placeholder: "0.00",
          class: "text-right font-mono" %>
      <span class="text-sm text-gray-500">Recommended: 30% of income</span>
    <% end %>
    
    <%= f.field :savings_goal do %>
      <%= f.number_field :savings_goal,
          step: 0.01,
          min: 0,
          placeholder: "0.00",
          class: "text-right font-mono" %>
      <span class="text-sm text-gray-500">Amount to save each month</span>
    <% end %>
  <% end %>
<% end %>
```

#### Event Planning
```erb
<%= form_with model: @event, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :max_attendees do %>
    <%= f.number_field :max_attendees,
        min: 1,
        max: @venue.capacity,
        step: 1 %>
    <span class="text-sm text-gray-500">
      Venue capacity: <%= @venue.capacity %>
    </span>
  <% end %>
  
  <%= f.field :ticket_price do %>
    <%= f.number_field :ticket_price,
        step: 0.01,
        min: 0,
        placeholder: "0.00" %>
    <span class="text-sm text-gray-500">Leave blank for free events</span>
  <% end %>
  
  <%= f.field :early_bird_discount do %>
    <%= f.number_field :early_bird_discount,
        min: 0,
        max: 100,
        step: 1,
        placeholder: "0" %>
    <span class="text-sm text-gray-500">Discount percentage for early registration</span>
  <% end %>
<% end %>
```

#### Survey Rating Form
```erb
<%= form_with model: @survey_response, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <h3>Rate Your Experience</h3>
    <p class="text-gray-600 mb-4">Please rate each aspect from 1 (poor) to 5 (excellent)</p>
    
    <%= f.field :overall_satisfaction do %>
      <%= f.number_field :overall_satisfaction,
          min: 1,
          max: 5,
          step: 1,
          data: {
            controller: "star-display",
            star_display_target: "overall"
          } %>
      <div data-star-display-target="overall" class="mt-1"></div>
    <% end %>
    
    <%= f.field :ease_of_use do %>
      <%= f.number_field :ease_of_use,
          min: 1,
          max: 5,
          step: 1,
          data: {
            controller: "star-display",
            star_display_target: "ease"
          } %>
      <div data-star-display-target="ease" class="mt-1"></div>
    <% end %>
    
    <%= f.field :value_for_money do %>
      <%= f.number_field :value_for_money,
          min: 1,
          max: 5,
          step: 1,
          data: {
            controller: "star-display",
            star_display_target: "value"
          } %>
      <div data-star-display-target="value" class="mt-1"></div>
    <% end %>
  <% end %>
<% end %>
```

#### Fitness Tracker
```erb
<%= form_with model: @workout, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :duration_minutes do %>
    <%= f.number_field :duration_minutes,
        min: 1,
        max: 300,
        step: 1,
        placeholder: "30" %>
    <span class="text-sm text-gray-500">Workout duration in minutes</span>
  <% end %>
  
  <%= f.field :calories_burned do %>
    <%= f.number_field :calories_burned,
        min: 0,
        step: 1,
        placeholder: "0",
        data: {
          controller: "calorie-estimator",
          calorie_estimator_weight: current_user.weight,
          calorie_estimator_activity: f.object.activity_type
        } %>
    <span class="text-sm text-gray-500">Estimated or measured calories</span>
  <% end %>
  
  <%= f.field :heart_rate_avg do %>
    <%= f.number_field :heart_rate_avg,
        min: 60,
        max: 220,
        step: 1,
        placeholder: "120" %>
    <span class="text-sm text-gray-500">Average heart rate (BPM)</span>
  <% end %>
<% end %>
```

#### Project Estimation
```erb
<%= form_with model: @project_estimate, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :hours_estimated do %>
    <%= f.number_field :hours_estimated,
        min: 1,
        max: 1000,
        step: 0.5,
        data: {
          controller: "cost-calculator",
          cost_calculator_hourly_rate: @developer.hourly_rate
        } %>
    <span class="text-sm text-gray-500">Estimated development hours</span>
  <% end %>
  
  <%= f.field :complexity_factor do %>
    <%= f.number_field :complexity_factor,
        min: 0.5,
        max: 3.0,
        step: 0.1,
        value: 1.0 %>
    <span class="text-sm text-gray-500">
      Complexity multiplier (0.5 = simple, 1.0 = normal, 3.0 = very complex)
    </span>
  <% end %>
  
  <div class="mt-4 p-4 bg-blue-50 rounded-lg">
    <div class="flex justify-between">
      <span class="font-medium">Estimated Cost:</span>
      <span data-cost-calculator-target="total" class="font-bold">$0.00</span>
    </div>
  </div>
<% end %>
```