# TimeField Component Guide

The TimeField component provides a styled time input with native browser time picker support and validation for time values.

## Basic Usage

#### Simple Time Field
```erb
<%= form_with model: @appointment, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :appointment_time do %>
    <%= f.time_field :appointment_time %>
  <% end %>
<% end %>
```

#### With Default Value
```erb
<%= f.time_field :start_time, value: "09:00" %>
```

#### With Constraints
```erb
<%= f.time_field :business_hours_start,
    min: "08:00",
    max: "18:00",
    step: 900 %> <!-- 15-minute intervals -->
```

## Customization Options

| Option | Type | Purpose |
|--------|------|---------|
| value | String | Time value in HH:MM format |
| min | String | Minimum allowed time |
| max | String | Maximum allowed time |
| step | Integer | Step interval in seconds (e.g., 900 for 15 minutes) |
| required | Boolean | Mark field as required |
| disabled | Boolean | Disable the input |
| readonly | Boolean | Make field read-only |
| class | String | Additional CSS classes |
| data | Hash | Data attributes for JavaScript |

## Advanced Features

#### Business Hours Time Selection
```erb
<%= f.time_field :opening_time,
    min: "06:00",
    max: "12:00",
    step: 1800, # 30-minute intervals
    value: "09:00" %>
```

#### Appointment Scheduling
```erb
<div class="grid grid-cols-2 gap-4">
  <%= f.field :start_time do %>
    <%= f.time_field :start_time,
        min: "08:00",
        max: "17:00",
        step: 900, # 15-minute intervals
        data: {
          controller: "time-range",
          time_range_target: "start",
          action: "change->time-range#updateEndTime"
        } %>
  <% end %>
  
  <%= f.field :end_time do %>
    <%= f.time_field :end_time,
        min: "08:15",
        max: "17:30",
        step: 900,
        data: {
          time_range_target: "end"
        } %>
  <% end %>
</div>
```

#### Time with Duration Calculation
```erb
<%= f.time_field :meeting_start,
    data: {
      controller: "duration-calculator",
      duration_calculator_target: "start",
      duration_calculator_end_field: "#meeting_end_time"
    } %>

<div data-duration-calculator-target="duration" class="text-sm text-gray-600 mt-1">
  Duration: <span data-duration-calculator-target="display">--</span>
</div>
```

#### Recurring Schedule
```erb
<% %w[monday tuesday wednesday thursday friday].each do |day| %>
  <div class="grid grid-cols-2 gap-2">
    <%= f.field "#{day}_start".to_sym do %>
      <%= f.time_field "#{day}_start".to_sym,
          min: "06:00",
          max: "23:00",
          step: 900,
          data: {
            controller: "schedule-validator",
            schedule_validator_day: day
          } %>
    <% end %>
    
    <%= f.field "#{day}_end".to_sym do %>
      <%= f.time_field "#{day}_end".to_sym,
          min: "06:15",
          max: "23:59",
          step: 900 %>
    <% end %>
  </div>
<% end %>
```

#### Time Zone Aware Input
```erb
<%= f.time_field :event_time,
    data: {
      controller: "timezone-aware-time",
      timezone_aware_time_zone: @user.timezone,
      timezone_aware_time_display_zone: "America/New_York"
    } %>

<div class="text-sm text-gray-500 mt-1">
  <span data-timezone-aware-time-target="localTime"></span>
  (<%= @user.timezone %>)
</div>
```

## Styling

#### Default Styles

The TimeField inherits styles from InputBase:
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
      class TimeField
        register_styles :custom do
          {
            root: "w-full px-4 py-3 border-2 border-gray-200 rounded-lg font-mono",
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
<% ui.theme(components: { forms: { time_field: { 
  root: "font-mono text-center" 
} } }) do %>
  <%= f.time_field :time %>
<% end %>
```

## Best Practices

1. **Clear Constraints**: Set appropriate min/max times for business logic
2. **Step Intervals**: Use logical step values (15, 30, or 60 minutes)
3. **Default Values**: Provide sensible default times
4. **Time Zone Clarity**: Be clear about time zone handling
5. **Validation**: Validate time ranges on both client and server
6. **Mobile Testing**: Test time picker on mobile devices

## Accessibility

The TimeField component ensures accessibility by:
- Using native HTML5 time input type
- Supporting keyboard navigation (Tab, Arrow keys)
- Providing clear label associations
- Including proper ARIA attributes for error states
- Working with screen readers
- Supporting step navigation via keyboard
- Showing visual focus indicators
- Maintaining semantic time input meaning

## Examples

#### Business Hours Configuration
```erb
<%= form_with model: @business, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <h3>Business Hours</h3>
    <p class="text-gray-600 mb-4">Set your operating hours for each day</p>
    
    <% %w[monday tuesday wednesday thursday friday saturday sunday].each do |day| %>
      <div class="grid grid-cols-3 gap-4 items-center py-2 border-b border-gray-200">
        <div class="font-medium capitalize"><%= day %></div>
        
        <%= f.field "#{day}_open".to_sym, class: "col-span-1" do %>
          <%= f.time_field "#{day}_open".to_sym,
              min: "00:00",
              max: "23:30",
              step: 1800, # 30-minute intervals
              value: day.in?(%w[saturday sunday]) ? nil : "09:00",
              data: {
                controller: "business-hours",
                business_hours_day: day,
                business_hours_target: "open"
              } %>
        <% end %>
        
        <%= f.field "#{day}_close".to_sym, class: "col-span-1" do %>
          <%= f.time_field "#{day}_close".to_sym,
              min: "00:30",
              max: "23:59",
              step: 1800,
              value: day.in?(%w[saturday sunday]) ? nil : "17:00",
              data: {
                business_hours_target: "close"
              } %>
        <% end %>
      </div>
    <% end %>
  <% end %>
<% end %>
```

#### Event Scheduling
```erb
<%= form_with model: @event, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <h3>Event Schedule</h3>
    
    <%= f.field :event_date do %>
      <%= f.date_field :event_date, required: true %>
    <% end %>
    
    <%= f.field :start_time do %>
      <%= f.time_field :start_time,
          min: "06:00",
          max: "23:00",
          step: 900, # 15-minute intervals
          value: "10:00",
          required: true,
          data: {
            controller: "event-scheduler",
            event_scheduler_target: "start",
            action: "change->event-scheduler#updateEndTime"
          } %>
    <% end %>
    
    <%= f.field :end_time do %>
      <%= f.time_field :end_time,
          min: "06:15",
          max: "23:59",
          step: 900,
          value: "11:00",
          required: true,
          data: {
            event_scheduler_target: "end",
            action: "change->event-scheduler#calculateDuration"
          } %>
    <% end %>
    
    <div class="p-3 bg-blue-50 rounded-md">
      <div class="text-sm">
        <strong>Duration:</strong> 
        <span data-event-scheduler-target="duration">1 hour</span>
      </div>
      <div class="text-sm text-gray-600">
        <strong>Time Zone:</strong> <%= @event.timezone || 'Local time' %>
      </div>
    </div>
  <% end %>
<% end %>
```

#### Appointment Booking
```erb
<%= form_with model: @appointment, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :appointment_date do %>
    <%= f.date_field :appointment_date,
        min: Date.current,
        max: 3.months.from_now.to_date,
        required: true,
        data: {
          controller: "appointment-scheduler",
          appointment_scheduler_target: "date",
          appointment_scheduler_availability_url: availability_path,
          action: "change->appointment-scheduler#loadAvailability"
        } %>
  <% end %>
  
  <%= f.field :appointment_time do %>
    <%= f.time_field :appointment_time,
        min: "09:00",
        max: "17:00",
        step: 900, # 15-minute intervals
        required: true,
        data: {
          appointment_scheduler_target: "time",
          action: "change->appointment-scheduler#checkAvailability"
        } %>
    
    <div data-appointment-scheduler-target="availability" class="mt-2 text-sm">
      Available times will appear here
    </div>
  <% end %>
  
  <%= f.field :duration do %>
    <%= f.select :duration, [
      ['30 minutes', 30],
      ['45 minutes', 45],
      ['60 minutes', 60],
      ['90 minutes', 90]
    ], { selected: 60 } %>
  <% end %>
<% end %>
```

#### Shift Scheduling
```erb
<%= form_with model: @shift, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :employee do %>
    <%= f.select :employee_id,
        options_from_collection_for_select(Employee.active, :id, :full_name),
        { prompt: 'Select employee' } %>
  <% end %>
  
  <%= f.field :shift_date do %>
    <%= f.date_field :shift_date, required: true %>
  <% end %>
  
  <%= f.field_set do %>
    <h4>Shift Times</h4>
    
    <div class="grid grid-cols-2 gap-4">
      <%= f.field :clock_in_time do %>
        <%= f.time_field :clock_in_time,
            min: "00:00",
            max: "23:59",
            step: 900,
            value: "08:00",
            required: true,
            data: {
              controller: "shift-calculator",
              shift_calculator_target: "start"
            } %>
      <% end %>
      
      <%= f.field :clock_out_time do %>
        <%= f.time_field :clock_out_time,
            min: "00:00",
            max: "23:59",
            step: 900,
            value: "17:00",
            required: true,
            data: {
              shift_calculator_target: "end",
              action: "change->shift-calculator#calculateHours"
            } %>
      <% end %>
    </div>
    
    <%= f.field :break_duration do %>
      <%= f.select :break_duration, [
        ['No break', 0],
        ['15 minutes', 15],
        ['30 minutes', 30],
        ['45 minutes', 45],
        ['60 minutes', 60]
      ], { selected: 30 } %>
    <% end %>
    
    <div class="p-3 bg-gray-50 rounded-md">
      <div class="text-sm">
        <strong>Total Hours:</strong> 
        <span data-shift-calculator-target="totalHours">8.0</span>
      </div>
      <div class="text-sm">
        <strong>Break Time:</strong> 
        <span data-shift-calculator-target="breakTime">0.5</span>
      </div>
      <div class="text-sm font-medium">
        <strong>Billable Hours:</strong> 
        <span data-shift-calculator-target="billableHours">7.5</span>
      </div>
    </div>
  <% end %>
<% end %>
```

#### Meeting Room Booking
```erb
<%= form_with model: @booking, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :room do %>
    <%= f.select :room_id,
        options_from_collection_for_select(Room.bookable, :id, :name),
        { prompt: 'Select meeting room' } %>
  <% end %>
  
  <%= f.field :booking_date do %>
    <%= f.date_field :booking_date,
        min: Date.current,
        max: 2.weeks.from_now.to_date,
        required: true,
        data: {
          controller: "room-availability",
          room_availability_target: "date",
          action: "change->room-availability#loadSchedule"
        } %>
  <% end %>
  
  <%= f.field_set do %>
    <h4>Time Slot</h4>
    
    <div class="grid grid-cols-2 gap-4">
      <%= f.field :start_time do %>
        <%= f.time_field :start_time,
            min: "07:00",
            max: "19:00",
            step: 900, # 15-minute intervals
            required: true,
            data: {
              room_availability_target: "startTime",
              action: "change->room-availability#checkConflicts"
            } %>
      <% end %>
      
      <%= f.field :end_time do %>
        <%= f.time_field :end_time,
            min: "07:15",
            max: "20:00",
            step: 900,
            required: true,
            data: {
              room_availability_target: "endTime",
              action: "change->room-availability#checkConflicts"
            } %>
      <% end %>
    </div>
    
    <div data-room-availability-target="conflicts" class="mt-2 text-sm">
      <!-- Conflict warnings will appear here -->
    </div>
    
    <div data-room-availability-target="schedule" class="mt-4">
      <!-- Room schedule will appear here -->
    </div>
  <% end %>
  
  <%= f.field :recurring do %>
    <%= f.check_box_with_label :recurring, 
        label: "Make this a recurring booking" %>
  <% end %>
  
  <%= f.show_if field: :recurring, equals: 'true' do %>
    <%= f.field :recurrence_pattern do %>
      <%= f.select :recurrence_pattern, [
        ['Daily', 'daily'],
        ['Weekly', 'weekly'],
        ['Bi-weekly', 'biweekly'],
        ['Monthly', 'monthly']
      ], { prompt: 'How often?' } %>
    <% end %>
    
    <%= f.field :recurrence_end_date do %>
      <%= f.date_field :recurrence_end_date,
          min: Date.current + 1.day,
          max: 6.months.from_now.to_date %>
    <% end %>
  <% end %>
<% end %>
```

#### Class Schedule Form
```erb
<%= form_with model: @class_schedule, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :course do %>
    <%= f.select :course_id,
        options_from_collection_for_select(Course.active, :id, :title),
        { prompt: 'Select course' } %>
  <% end %>
  
  <%= f.field :instructor do %>
    <%= f.select :instructor_id,
        options_from_collection_for_select(Instructor.active, :id, :full_name),
        { prompt: 'Select instructor' } %>
  <% end %>
  
  <%= f.field_set do %>
    <h4>Class Times</h4>
    
    <% %w[monday tuesday wednesday thursday friday].each do |day| %>
      <div class="flex items-center space-x-4 py-2">
        <%= f.check_box "#{day}_enabled".to_sym,
            data: {
              controller: "schedule-toggle",
              schedule_toggle_target: "#{day}Checkbox",
              schedule_toggle_controls: ".#{day}-times",
              action: "change->schedule-toggle#toggleTimes"
            } %>
        
        <label class="w-20 font-medium capitalize"><%= day %></label>
        
        <div class="#{day}-times grid grid-cols-2 gap-2 opacity-50 pointer-events-none">
          <%= f.time_field "#{day}_start_time".to_sym,
              min: "08:00",
              max: "20:00",
              step: 900,
              placeholder: "Start time",
              class: "w-32" %>
          
          <%= f.time_field "#{day}_end_time".to_sym,
              min: "08:15",
              max: "21:00",
              step: 900,
              placeholder: "End time",
              class: "w-32" %>
        </div>
      </div>
    <% end %>
  <% end %>
  
  <%= f.field :semester_start do %>
    <%= f.date_field :semester_start,
        min: Date.current,
        max: 1.year.from_now.to_date %>
  <% end %>
  
  <%= f.field :semester_end do %>
    <%= f.date_field :semester_end,
        min: Date.current + 1.month,
        max: 1.year.from_now.to_date %>
  <% end %>
<% end %>
```