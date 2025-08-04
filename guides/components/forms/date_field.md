# DateField Component Guide

The DateField component provides a styled date input with native browser date picker support and consistent error handling across all browsers.

## Basic Usage

#### Simple Date Field
```erb
<%= form_with model: @event, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :start_date do %>
    <%= f.date_field :start_date %>
  <% end %>
<% end %>
```

#### With Constraints
```erb
<%= f.date_field :birth_date, 
    min: 100.years.ago.to_date,
    max: Date.today %>
```

#### With Default Value
```erb
<%= f.date_field :scheduled_date, 
    value: 1.week.from_now.to_date %>
```

## Customization Options

| Option | Type | Purpose |
|--------|------|---------|
| min | Date/String | Minimum allowed date |
| max | Date/String | Maximum allowed date |
| value | Date/String | Default or current value |
| placeholder | String | Placeholder text (browser support varies) |
| required | Boolean | Mark field as required |
| disabled | Boolean | Disable the input |
| readonly | Boolean | Make field read-only |
| class | String | Additional CSS classes |
| data | Hash | Data attributes for JavaScript |

## Advanced Features

#### Date Range Selection
```erb
<%= f.field_set do %>
  <div class="grid grid-cols-2 gap-4">
    <%= f.field :start_date, class: "col-span-1" do %>
      <%= f.date_field :start_date, 
          min: Date.today,
          data: { 
            controller: "date-range",
            date_range_target: "start" 
          } %>
    <% end %>
    
    <%= f.field :end_date, class: "col-span-1" do %>
      <%= f.date_field :end_date,
          min: Date.today,
          data: { 
            controller: "date-range",
            date_range_target: "end" 
          } %>
    <% end %>
  </div>
<% end %>
```

#### With JavaScript Enhancement
```erb
<%= f.date_field :appointment_date,
    min: Date.today,
    max: 3.months.from_now.to_date,
    data: {
      controller: "datepicker",
      datepicker_disable_weekends: true,
      datepicker_highlight_today: true
    } %>
```

#### Dynamic Constraints
```erb
<%= f.date_field :delivery_date,
    min: @order.earliest_delivery_date,
    max: @order.latest_delivery_date,
    value: @order.suggested_delivery_date %>
```

## Styling

#### Default Styles

The DateField inherits styles from InputBase:
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
      class DateField
        register_styles :custom do
          {
            root: "w-full px-4 py-3 border-2 border-gray-200 rounded-lg",
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
<% ui.theme(components: { forms: { date_field: { 
  root: "rounded-xl shadow-sm" 
} } }) do %>
  <%= f.date_field :event_date %>
<% end %>
```

## Best Practices

1. **Clear Constraints**: Always set appropriate min/max dates for business logic
2. **Format Hints**: Consider adding helper text about expected date format
3. **Validation Messages**: Provide clear error messages for invalid dates
4. **Mobile Experience**: Test date picker on mobile devices
5. **Fallback Options**: Consider alternatives for browsers with poor date input support
6. **Timezone Awareness**: Be clear about timezone handling if relevant

## Accessibility

The DateField component ensures accessibility by:
- Using native HTML5 date input type
- Supporting keyboard navigation (Tab, Arrow keys)
- Providing clear label associations
- Including proper ARIA attributes for error states
- Working with screen readers
- Showing visual focus indicators

## Examples

#### Event Registration
```erb
<%= form_with model: @registration, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <h3>Event Details</h3>
    
    <%= f.field :event_date do %>
      <%= f.date_field :event_date,
          min: Date.today,
          max: 1.year.from_now.to_date,
          required: true %>
    <% end %>
    
    <%= f.field :registration_deadline do %>
      <%= f.date_field :registration_deadline,
          max: -> { f.object.event_date - 7.days } %>
    <% end %>
  <% end %>
<% end %>
```

#### Employee Record
```erb
<%= form_with model: @employee, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :birth_date do %>
    <%= f.date_field :birth_date,
        min: 100.years.ago.to_date,
        max: 18.years.ago.to_date %>
  <% end %>
  
  <%= f.field :hire_date do %>
    <%= f.date_field :hire_date,
        min: @company.founded_date,
        max: Date.today %>
  <% end %>
  
  <%= f.field :contract_end_date do %>
    <%= f.date_field :contract_end_date,
        min: f.object.hire_date || Date.today %>
  <% end %>
<% end %>
```

#### Booking System
```erb
<%= form_with model: @booking, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :check_in_date do %>
    <%= f.date_field :check_in_date,
        min: Date.today,
        max: 1.year.from_now.to_date,
        data: {
          controller: "booking-calendar",
          booking_calendar_unavailable_dates_value: @unavailable_dates.to_json
        } %>
  <% end %>
  
  <%= f.field :check_out_date do %>
    <%= f.date_field :check_out_date,
        min: Date.today + 1.day,
        max: 1.year.from_now.to_date %>
  <% end %>
<% end %>
```

#### Project Timeline
```erb
<%= form_with model: @project, builder: OkonomiUiKit::FormBuilder do |f| %>
  <div class="space-y-4">
    <%= f.field :kickoff_date do %>
      <%= f.date_field :kickoff_date,
          value: Date.today,
          min: Date.today %>
      <span class="text-sm text-gray-500">Project start date</span>
    <% end %>
    
    <%= f.field :milestone_date do %>
      <%= f.date_field :milestone_date,
          min: -> { f.object.kickoff_date || Date.today } %>
      <span class="text-sm text-gray-500">First milestone delivery</span>
    <% end %>
    
    <%= f.field :completion_date do %>
      <%= f.date_field :completion_date,
          min: -> { f.object.milestone_date || f.object.kickoff_date || Date.today } %>
      <span class="text-sm text-gray-500">Expected completion</span>
    <% end %>
  </div>
<% end %>
```

#### Subscription Management
```erb
<%= form_with model: @subscription, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :trial_ends_at do %>
    <%= f.date_field :trial_ends_at,
        value: 30.days.from_now.to_date,
        min: Date.today,
        readonly: true %>
    <p class="mt-1 text-sm text-gray-500">
      Your trial period ends on this date
    </p>
  <% end %>
  
  <%= f.field :next_billing_date do %>
    <%= f.date_field :next_billing_date,
        min: f.object.trial_ends_at || Date.today,
        disabled: f.object.trial_active? %>
  <% end %>
<% end %>
```