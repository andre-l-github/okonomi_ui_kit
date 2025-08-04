# DatetimeLocalField Component Guide

The DatetimeLocalField component provides a styled datetime-local input that allows users to select both date and time in a single field with native browser support.

## Basic Usage

#### Simple Datetime Field
```erb
<%= form_with model: @appointment, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :scheduled_at do %>
    <%= f.datetime_local_field :scheduled_at %>
  <% end %>
<% end %>
```

#### With Default Value
```erb
<%= f.datetime_local_field :meeting_time, 
    value: 2.hours.from_now.strftime("%Y-%m-%dT%H:%M") %>
```

#### With Constraints
```erb
<%= f.datetime_local_field :appointment_time,
    min: Time.current.strftime("%Y-%m-%dT%H:%M"),
    max: 1.month.from_now.strftime("%Y-%m-%dT%H:%M") %>
```

## Customization Options

| Option | Type | Purpose |
|--------|------|---------|
| value | String | ISO datetime string (YYYY-MM-DDTHH:MM) |
| min | String | Minimum allowed datetime |
| max | String | Maximum allowed datetime |
| step | Integer | Step interval in seconds (e.g., 900 for 15 minutes) |
| required | Boolean | Mark field as required |
| disabled | Boolean | Disable the input |
| readonly | Boolean | Make field read-only |
| class | String | Additional CSS classes |
| data | Hash | Data attributes for JavaScript |

## Advanced Features

#### Business Hours Constraint
```erb
<%= f.datetime_local_field :appointment_at,
    min: Time.current.beginning_of_day.strftime("%Y-%m-%dT09:00"),
    max: Time.current.end_of_day.strftime("%Y-%m-%dT17:00"),
    step: 900 %> <!-- 15 minute intervals -->
```

#### Event Scheduling
```erb
<%= f.field_set do %>
  <div class="grid grid-cols-2 gap-4">
    <%= f.field :start_time, class: "col-span-1" do %>
      <%= f.datetime_local_field :start_time,
          min: Time.current.strftime("%Y-%m-%dT%H:%M"),
          data: { 
            controller: "datetime-range",
            datetime_range_target: "start" 
          } %>
    <% end %>
    
    <%= f.field :end_time, class: "col-span-1" do %>
      <%= f.datetime_local_field :end_time,
          min: Time.current.strftime("%Y-%m-%dT%H:%M"),
          data: { 
            controller: "datetime-range",
            datetime_range_target: "end" 
          } %>
    <% end %>
  </div>
<% end %>
```

#### With JavaScript Enhancement
```erb
<%= f.datetime_local_field :deadline,
    min: Time.current.strftime("%Y-%m-%dT%H:%M"),
    data: {
      controller: "datetime-picker",
      datetime_picker_timezone: "America/New_York",
      datetime_picker_format: "medium"
    } %>
```

#### Dynamic Business Logic
```erb
<%= f.datetime_local_field :delivery_datetime,
    min: @order.earliest_delivery_time.strftime("%Y-%m-%dT%H:%M"),
    max: @order.latest_delivery_time.strftime("%Y-%m-%dT%H:%M"),
    value: @order.suggested_delivery_time&.strftime("%Y-%m-%dT%H:%M") %>
```

## Styling

#### Default Styles

The DatetimeLocalField inherits styles from InputBase:
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
      class DatetimeLocalField
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
<% ui.theme(components: { forms: { datetime_local_field: { 
  root: "rounded-xl shadow-sm" 
} } }) do %>
  <%= f.datetime_local_field :event_datetime %>
<% end %>
```

## Best Practices

1. **Clear Time Zones**: Be explicit about timezone handling and display timezone info
2. **Appropriate Constraints**: Set realistic min/max values for your use case
3. **Step Intervals**: Use step attribute for appointment booking (15-30 minute intervals)
4. **Format Documentation**: Help users understand the expected format
5. **Validation Messages**: Provide clear error messages for invalid datetime values
6. **Mobile Testing**: Test datetime picker behavior on mobile devices

## Accessibility

The DatetimeLocalField component ensures accessibility by:
- Using native HTML5 datetime-local input type
- Supporting keyboard navigation (Tab, Arrow keys, Enter)
- Providing clear label associations
- Including proper ARIA attributes for error states
- Working with screen readers
- Showing visual focus indicators
- Maintaining semantic meaning

## Examples

#### Medical Appointment Booking
```erb
<%= form_with model: @appointment, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :appointment_datetime do %>
    <%= f.datetime_local_field :appointment_datetime,
        min: Time.current.strftime("%Y-%m-%dT%H:%M"),
        max: 3.months.from_now.strftime("%Y-%m-%dT%H:%M"),
        step: 900, # 15-minute intervals
        required: true %>
    <span class="text-sm text-gray-500">
      Appointments available Mon-Fri 9:00 AM - 5:00 PM
    </span>
  <% end %>
<% end %>
```

#### Event Management
```erb
<%= form_with model: @event, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <h3>Event Schedule</h3>
    
    <%= f.field :starts_at do %>
      <%= f.datetime_local_field :starts_at,
          min: Time.current.strftime("%Y-%m-%dT%H:%M"),
          data: {
            controller: "event-schedule",
            event_schedule_target: "start"
          } %>
    <% end %>
    
    <%= f.field :ends_at do %>
      <%= f.datetime_local_field :ends_at,
          min: Time.current.strftime("%Y-%m-%dT%H:%M"),
          data: {
            controller: "event-schedule",
            event_schedule_target: "end"
          } %>
    <% end %>
    
    <%= f.field :registration_deadline do %>
      <%= f.datetime_local_field :registration_deadline,
          max: -> { f.object.starts_at&.strftime("%Y-%m-%dT%H:%M") } %>
      <span class="text-sm text-gray-500">
        Must be before event start time
      </span>
    <% end %>
  <% end %>
<% end %>
```

#### Task Deadline Management
```erb
<%= form_with model: @task, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :due_at do %>
    <%= f.datetime_local_field :due_at,
        min: Time.current.strftime("%Y-%m-%dT%H:%M"),
        max: 1.year.from_now.strftime("%Y-%m-%dT%H:%M"),
        value: 1.week.from_now.strftime("%Y-%m-%dT17:00") %>
    <p class="mt-1 text-sm text-gray-500">
      Set when this task should be completed
    </p>
  <% end %>
  
  <%= f.field :reminder_at do %>
    <%= f.datetime_local_field :reminder_at,
        min: Time.current.strftime("%Y-%m-%dT%H:%M"),
        max: -> { f.object.due_at&.strftime("%Y-%m-%dT%H:%M") } %>
    <p class="mt-1 text-sm text-gray-500">
      Optional reminder before due date
    </p>
  <% end %>
<% end %>
```

#### Restaurant Reservation System
```erb
<%= form_with model: @reservation, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :reserved_at do %>
    <%= f.datetime_local_field :reserved_at,
        min: Time.current.strftime("%Y-%m-%dT%H:%M"),
        max: 2.months.from_now.strftime("%Y-%m-%dT%H:%M"),
        step: 1800, # 30-minute intervals
        data: {
          controller: "reservation-calendar",
          reservation_calendar_restaurant_id: @restaurant.id,
          reservation_calendar_party_size: f.object.party_size
        } %>
    <span class="text-sm text-gray-500">
      Reservations available daily 11:00 AM - 10:00 PM
    </span>
  <% end %>
<% end %>
```

#### Project Milestone Planning
```erb
<%= form_with model: @milestone, builder: OkonomiUiKit::FormBuilder do |f| %>
  <div class="space-y-4">
    <%= f.field :kickoff_datetime do %>
      <%= f.datetime_local_field :kickoff_datetime,
          value: 1.week.from_now.beginning_of_day.strftime("%Y-%m-%dT09:00"),
          min: Time.current.strftime("%Y-%m-%dT%H:%M") %>
      <span class="text-sm text-gray-500">Project kickoff meeting</span>
    <% end %>
    
    <%= f.field :first_review_at do %>
      <%= f.datetime_local_field :first_review_at,
          min: -> { f.object.kickoff_datetime || Time.current.strftime("%Y-%m-%dT%H:%M") } %>
      <span class="text-sm text-gray-500">First milestone review</span>
    <% end %>
    
    <%= f.field :final_delivery_at do %>
      <%= f.datetime_local_field :final_delivery_at,
          min: -> { f.object.first_review_at || f.object.kickoff_datetime || Time.current.strftime("%Y-%m-%dT%H:%M") } %>
      <span class="text-sm text-gray-500">Final project delivery</span>
    <% end %>
  </div>
<% end %>
```

#### Conference Session Scheduling
```erb
<%= form_with model: @session, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :session_start do %>
    <%= f.datetime_local_field :session_start,
        min: @conference.start_date.strftime("%Y-%m-%dT08:00"),
        max: @conference.end_date.strftime("%Y-%m-%dT18:00"),
        step: 900, # 15-minute intervals
        data: {
          controller: "session-scheduler",
          session_scheduler_room_id: f.object.room_id
        } %>
  <% end %>
  
  <%= f.field :session_end do %>
    <%= f.datetime_local_field :session_end,
        min: -> { f.object.session_start || @conference.start_date.strftime("%Y-%m-%dT08:00") },
        max: @conference.end_date.strftime("%Y-%m-%dT18:00"),
        step: 900 %>
  <% end %>
<% end %>
```