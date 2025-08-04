# TelephoneField Component Guide

The TelephoneField component provides a styled telephone input with mobile-optimized numeric keyboard and support for phone number formatting and validation.

## Basic Usage

#### Simple Telephone Field
```erb
<%= form_with model: @user, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :phone do %>
    <%= f.telephone_field :phone %>
  <% end %>
<% end %>
```

#### With Placeholder
```erb
<%= f.telephone_field :phone, placeholder: "(555) 123-4567" %>
```

#### With Pattern Validation
```erb
<%= f.telephone_field :phone, 
    pattern: "\\(\\d{3}\\) \\d{3}-\\d{4}",
    title: "Please enter phone in format: (555) 123-4567" %>
```

## Customization Options

| Option | Type | Purpose |
|--------|------|---------|
| placeholder | String | Placeholder text showing expected format |
| required | Boolean | Mark field as required |
| disabled | Boolean | Disable the input |
| readonly | Boolean | Make field read-only |
| pattern | String | Regular expression for validation |
| maxlength | Integer | Maximum number of characters |
| autocomplete | String | Autocomplete behavior ("tel", "tel-national") |
| class | String | Additional CSS classes |
| data | Hash | Data attributes for JavaScript |

## Advanced Features

#### Formatted Phone Input
```erb
<%= f.telephone_field :phone,
    placeholder: "(555) 123-4567",
    data: {
      controller: "phone-formatter",
      phone_formatter_format: "us"
    } %>
```

#### International Phone Support
```erb
<%= f.telephone_field :phone,
    placeholder: "+1 (555) 123-4567",
    data: {
      controller: "international-phone",
      international_phone_country_selector: "#country_code"
    } %>
```

#### Phone Validation
```erb
<%= f.telephone_field :phone,
    data: {
      controller: "phone-validator",
      phone_validator_country: "US",
      action: "blur->phone-validator#validate"
    } %>

<div data-phone-validator-target="feedback" class="text-sm mt-1"></div>
```

#### Multiple Phone Types
```erb
<div class="grid grid-cols-1 md:grid-cols-2 gap-4">
  <%= f.field :primary_phone do %>
    <%= f.telephone_field :primary_phone,
        placeholder: "Primary phone",
        autocomplete: "tel" %>
  <% end %>
  
  <%= f.field :work_phone do %>
    <%= f.telephone_field :work_phone,
        placeholder: "Work phone",
        autocomplete: "tel" %>
  <% end %>
</div>
```

#### SMS Verification
```erb
<%= f.telephone_field :phone,
    placeholder: "Phone number for SMS verification",
    data: {
      controller: "sms-verification",
      sms_verification_send_url: send_verification_path
    } %>

<button type="button" 
        data-action="sms-verification#sendCode"
        class="mt-2 text-blue-600 hover:text-blue-800">
  Send verification code
</button>
```

## Styling

#### Default Styles

The TelephoneField inherits styles from InputBase:
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
      class TelephoneField
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
<% ui.theme(components: { forms: { telephone_field: { 
  root: "font-mono tracking-wider" 
} } }) do %>
  <%= f.telephone_field :phone %>
<% end %>
```

## Best Practices

1. **Clear Format**: Show expected format in placeholder or help text
2. **Validation**: Provide real-time validation feedback
3. **International Support**: Consider international phone formats
4. **Accessibility**: Ensure proper input types for mobile keyboards
5. **Formatting**: Use consistent formatting across the application
6. **Privacy**: Be clear about how phone numbers will be used

## Accessibility

The TelephoneField component ensures accessibility by:
- Using native HTML5 tel input type
- Triggering numeric/phone keyboards on mobile devices
- Supporting keyboard navigation (Tab, Enter)
- Providing clear label associations
- Including proper ARIA attributes for error states
- Working with screen readers
- Supporting autocomplete for better UX
- Showing visual focus indicators

## Examples

#### Contact Information Form
```erb
<%= form_with model: @contact, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <h3>Contact Information</h3>
    
    <%= f.field :primary_phone do %>
      <%= f.telephone_field :primary_phone,
          placeholder: "(555) 123-4567",
          required: true,
          autocomplete: "tel",
          data: {
            controller: "phone-formatter",
            phone_formatter_format: "us"
          } %>
      <span class="text-sm text-gray-500">Primary contact number</span>
    <% end %>
    
    <%= f.field :work_phone do %>
      <%= f.telephone_field :work_phone,
          placeholder: "(555) 123-4567",
          autocomplete: "tel" %>
      <span class="text-sm text-gray-500">Work number (optional)</span>
    <% end %>
    
    <%= f.field :mobile_phone do %>
      <%= f.telephone_field :mobile_phone,
          placeholder: "(555) 123-4567",
          autocomplete: "tel",
          data: {
            controller: "sms-capable",
            sms_capable_verify_url: verify_sms_path
          } %>
      <span class="text-sm text-gray-500">
        Mobile number for SMS notifications
      </span>
    <% end %>
  <% end %>
<% end %>
```

#### User Registration with Phone Verification
```erb
<%= form_with model: @user, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :phone, hint: "We'll send a verification code to this number" do %>
    <div class="space-y-3">
      <%= f.telephone_field :phone,
          placeholder: "(555) 123-4567",
          required: true,
          data: {
            controller: "phone-verification",
            phone_verification_target: "input",
            phone_verification_send_url: send_verification_code_path
          } %>
      
      <div class="flex space-x-2">
        <button type="button" 
                class="px-4 py-2 bg-blue-100 text-blue-700 rounded hover:bg-blue-200"
                data-action="phone-verification#sendCode"
                data-phone-verification-target="sendButton">
          Send Code
        </button>
        
        <input type="text" 
               placeholder="Enter 6-digit code"
               maxlength="6"
               class="px-3 py-2 border border-gray-300 rounded"
               data-phone-verification-target="codeInput"
               data-action="input->phone-verification#validateCode">
      </div>
      
      <div data-phone-verification-target="status" class="text-sm"></div>
    </div>
  <% end %>
<% end %>
```

#### Emergency Contact Form
```erb
<%= form_with model: @emergency_contact, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <h3>Emergency Contact Information</h3>
    <p class="text-gray-600 mb-4">Person to contact in case of emergency</p>
    
    <%= f.field :name do %>
      <%= f.text_field :name, required: true %>
    <% end %>
    
    <%= f.field :relationship do %>
      <%= f.select :relationship, [
        ['Spouse', 'spouse'],
        ['Parent', 'parent'],
        ['Sibling', 'sibling'],
        ['Child', 'child'],
        ['Friend', 'friend'],
        ['Other', 'other']
      ], { prompt: 'Select relationship' } %>
    <% end %>
    
    <%= f.field :primary_phone do %>
      <%= f.telephone_field :primary_phone,
          placeholder: "(555) 123-4567",
          required: true,
          data: {
            controller: "phone-formatter emergency-contact-validator",
            phone_formatter_format: "us"
          } %>
    <% end %>
    
    <%= f.field :alternate_phone do %>
      <%= f.telephone_field :alternate_phone,
          placeholder: "(555) 123-4567 (optional)" %>
      <span class="text-sm text-gray-500">Alternate number if primary is unavailable</span>
    <% end %>
  <% end %>
<% end %>
```

#### Business Contact Form
```erb
<%= form_with model: @business, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <h3>Business Contact Details</h3>
    
    <%= f.field :main_phone do %>
      <%= f.telephone_field :main_phone,
          placeholder: "(555) 123-4567",
          required: true,
          autocomplete: "tel" %>
      <span class="text-sm text-gray-500">Main business line</span>
    <% end %>
    
    <%= f.field :toll_free_phone do %>
      <%= f.telephone_field :toll_free_phone,
          placeholder: "1-800-555-0123",
          pattern: "1-\\d{3}-\\d{3}-\\d{4}" %>
      <span class="text-sm text-gray-500">Toll-free number (optional)</span>
    <% end %>
    
    <%= f.field :fax_number do %>
      <%= f.telephone_field :fax_number,
          placeholder: "(555) 123-4567" %>
      <span class="text-sm text-gray-500">Fax number (optional)</span>
    <% end %>
    
    <%= f.field :after_hours_phone do %>
      <%= f.telephone_field :after_hours_phone,
          placeholder: "(555) 123-4567" %>
      <span class="text-sm text-gray-500">After-hours emergency line</span>
    <% end %>
  <% end %>
<% end %>
```

#### International Phone Form
```erb
<%= form_with model: @user, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <h3>Phone Number</h3>
    
    <div class="grid grid-cols-1 md:grid-cols-4 gap-2">
      <%= f.field :country_code, class: "md:col-span-1" do %>
        <%= f.select :country_code,
            options_from_collection_for_select(
              Country.all, :phone_code, :name_with_code
            ),
            { selected: '+1' },
            {
              data: {
                controller: "country-phone",
                action: "change->country-phone#updateFormat"
              }
            } %>
      <% end %>
      
      <%= f.field :phone_number, class: "md:col-span-3" do %>
        <%= f.telephone_field :phone_number,
            placeholder: "Phone number",
            data: {
              controller: "international-phone-formatter",
              country_phone_target: "phoneInput",
              international_phone_formatter_target: "input"
            } %>
      <% end %>
    </div>
    
    <div data-international-phone-formatter-target="example" class="text-sm text-gray-500 mt-1">
      Example format will appear here
    </div>
  <% end %>
<% end %>
```

#### Support Ticket Form
```erb
<%= form_with model: @support_ticket, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :contact_preference do %>
    <%= f.select :contact_preference, [
      ['Email', 'email'],
      ['Phone', 'phone'],
      ['Either', 'either']
    ], { prompt: 'Preferred contact method' } %>
  <% end %>
  
  <%= f.show_if field: :contact_preference, equals: 'phone' do %>
    <%= f.field :phone do %>
      <%= f.telephone_field :phone,
          placeholder: "(555) 123-4567",
          required: true,
          data: {
            controller: "phone-formatter",
            phone_formatter_format: "us"
          } %>
      <span class="text-sm text-gray-500">
        We'll call you within 24 hours
      </span>
    <% end %>
    
    <%= f.field :best_time_to_call do %>
      <%= f.select :best_time_to_call, [
        ['Morning (9 AM - 12 PM)', 'morning'],
        ['Afternoon (12 PM - 5 PM)', 'afternoon'],
        ['Evening (5 PM - 8 PM)', 'evening']
      ], { prompt: 'Best time to call' } %>
    <% end %>
  <% end %>
  
  <%= f.show_if field: :contact_preference, equals: 'either' do %>
    <%= f.field :phone do %>
      <%= f.telephone_field :phone,
          placeholder: "(555) 123-4567 (optional)" %>
      <span class="text-sm text-gray-500">
        Phone number for faster resolution
      </span>
    <% end %>
  <% end %>
<% end %>
```

#### Delivery Information
```erb
<%= form_with model: @order, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <h3>Delivery Contact</h3>
    <p class="text-gray-600 mb-4">Contact information for delivery coordination</p>
    
    <%= f.field :delivery_phone do %>
      <%= f.telephone_field :delivery_phone,
          placeholder: "(555) 123-4567",
          required: true,
          data: {
            controller: "phone-formatter delivery-validator",
            phone_formatter_format: "us"
          } %>
      <span class="text-sm text-gray-500">
        Primary number for delivery updates
      </span>
    <% end %>
    
    <%= f.field :alternate_delivery_phone do %>
      <%= f.telephone_field :alternate_delivery_phone,
          placeholder: "(555) 123-4567 (optional)" %>
      <span class="text-sm text-gray-500">
        Backup number if primary is unavailable
      </span>
    <% end %>
    
    <%= f.field :sms_updates do %>
      <%= f.check_box_with_label :sms_updates, 
          label: "Send SMS delivery updates to primary phone" %>
    <% end %>
  <% end %>
<% end %>
```

#### Medical Form
```erb
<%= form_with model: @patient, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <h3>Contact Information</h3>
    
    <%= f.field :home_phone do %>
      <%= f.telephone_field :home_phone,
          placeholder: "(555) 123-4567",
          autocomplete: "tel-national" %>
    <% end %>
    
    <%= f.field :work_phone do %>
      <%= f.telephone_field :work_phone,
          placeholder: "(555) 123-4567" %>
    <% end %>
    
    <%= f.field :mobile_phone do %>
      <%= f.telephone_field :mobile_phone,
          placeholder: "(555) 123-4567",
          required: true %>
      <span class="text-sm text-gray-500">
        Required for appointment reminders
      </span>
    <% end %>
    
    <%= f.field :preferred_contact_time do %>
      <%= f.select :preferred_contact_time, [
        ['Morning (8 AM - 12 PM)', 'morning'],
        ['Afternoon (12 PM - 5 PM)', 'afternoon'],
        ['Evening (5 PM - 8 PM)', 'evening'],
        ['Anytime', 'anytime']
      ], { prompt: 'Best time to call' } %>
    <% end %>
    
    <%= f.field :can_leave_voicemail do %>
      <%= f.check_box_with_label :can_leave_voicemail, 
          label: "OK to leave voicemail messages" %>
    <% end %>
  <% end %>
<% end %>
```