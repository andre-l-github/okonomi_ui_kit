# Field Component Guide

The Field component provides a wrapper for form inputs with consistent styling, automatic label generation, error handling, help text, and accessibility features.

## Basic Usage

#### Simple Field Wrapper
```erb
<%= form_with model: @user, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :name do %>
    <%= f.text_field :name %>
  <% end %>
<% end %>
```

#### Field with Help Text
```erb
<%= f.field :email, hint: "We'll never share your email address" do %>
  <%= f.email_field :email %>
<% end %>
```

#### Custom Column Layout
```erb
<%= f.field :address, columns: 2 do %>
  <%= f.text_field :street_address %>
  <%= f.text_field :city %>
<% end %>
```

## Customization Options

| Option | Type | Purpose |
|--------|------|---------|
| hint | String/Boolean | Help text or tooltip content |
| columns | Integer | Number of columns for grid layout (default: 1) |
| class | String | Additional CSS classes for the wrapper |

## Advanced Features

#### Multiple Inputs in One Field
```erb
<%= f.field :address, columns: 3 do %>
  <%= f.text_field :street_address, placeholder: "Street Address" %>
  <%= f.text_field :city, placeholder: "City" %>
  <%= f.text_field :zip_code, placeholder: "ZIP Code" %>
<% end %>
```

#### Field with Custom Help Text
```erb
<%= f.field :password, hint: "Must be at least 8 characters with mixed case and numbers" do %>
  <%= f.password_field :password %>
<% end %>
```

#### Field with Localized Help
```erb
<%= f.field :tax_id, hint: true do %>
  <%= f.text_field :tax_id %>
<% end %>
<!-- Looks for I18n key: activerecord.hints.user.tax_id -->
```

#### Conditional Field Display
```erb
<%= f.field :business_name do %>
  <%= f.text_field :business_name %>
<% end if @user.account_type == 'business' %>
```

#### Complex Field Layout
```erb
<%= f.field :contact_info, columns: 2, class: "border-t pt-4" do %>
  <%= f.email_field :email, placeholder: "Email Address" %>
  <%= f.telephone_field :phone, placeholder: "Phone Number" %>
<% end %>
```

## Styling

#### Default Styles

The Field component includes these style classes:
- Wrapper: `w-full flex flex-col gap-2`
- Header: `flex justify-between items-center`
- Hint trigger: `text-primary-600 text-sm hover:cursor-help`
- Hint content: `text-xs absolute border rounded-md bg-gray-100 border-gray-600 text-gray-600 p-1 z-10`
- Content: `block`
- Error: `mt-1 text-danger-600 text-sm`

#### Customizing Styles

Override the default styles in your configuration:

```ruby
# In your initializer
module OkonomiUiKit
  module Components
    module Forms
      class Field
        register_styles :custom do
          {
            wrapper: "w-full flex flex-col gap-3 p-4 bg-gray-50 rounded-lg",
            header: "flex justify-between items-start",
            hint: {
              trigger: "text-blue-600 text-sm underline cursor-help",
              content: "text-sm absolute bg-white border border-gray-300 rounded-lg shadow-lg p-3 z-20"
            },
            content: "block mt-2",
            error: "mt-2 text-red-600 text-sm font-medium"
          }
        end
      end
    end
  end
end
```

Or use runtime theme switching:

```ruby
<% ui.theme(components: { forms: { field: { 
  wrapper: "space-y-3",
  error: "text-red-500 text-xs"
} } }) do %>
  <%= f.field :email do %>
    <%= f.email_field :email %>
  <% end %>
<% end %>
```

## Best Practices

1. **Consistent Labeling**: Use clear, descriptive field labels
2. **Helpful Hints**: Provide help text for complex or unfamiliar fields
3. **Error Context**: Ensure error messages are clear and actionable
4. **Logical Grouping**: Group related fields together
5. **Responsive Layout**: Use columns appropriately for different screen sizes
6. **Required Fields**: Clearly indicate which fields are required

## Accessibility

The Field component ensures accessibility by:
- Automatic label association with form inputs
- Proper ARIA attributes for help text and errors
- Semantic HTML structure with fieldset grouping
- Keyboard navigation support
- Screen reader compatibility
- Focus management and visual indicators
- Error announcement for screen readers

## Examples

#### User Profile Form
```erb
<%= form_with model: @user, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <h2>Personal Information</h2>
    
    <%= f.field :first_name do %>
      <%= f.text_field :first_name, required: true %>
    <% end %>
    
    <%= f.field :last_name do %>
      <%= f.text_field :last_name, required: true %>
    <% end %>
    
    <%= f.field :email, hint: "Used for account notifications and password recovery" do %>
      <%= f.email_field :email, required: true %>
    <% end %>
    
    <%= f.field :phone, hint: "Optional - for account security verification" do %>
      <%= f.telephone_field :phone %>
    <% end %>
  <% end %>
<% end %>
```

#### Address Information
```erb
<%= f.field_set do %>
  <h3>Shipping Address</h3>
  
  <%= f.field :address_line_1 do %>
    <%= f.text_field :address_line_1, placeholder: "Street address" %>
  <% end %>
  
  <%= f.field :address_line_2 do %>
    <%= f.text_field :address_line_2, placeholder: "Apartment, suite, etc. (optional)" %>
  <% end %>
  
  <%= f.field :city_state_zip, columns: 3 do %>
    <%= f.text_field :city, placeholder: "City" %>
    <%= f.select :state, options_for_select(us_states), { prompt: "State" } %>
    <%= f.text_field :zip_code, placeholder: "ZIP Code" %>
  <% end %>
<% end %>
```

#### Business Registration
```erb
<%= form_with model: @business, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :business_name do %>
    <%= f.text_field :business_name, required: true %>
  <% end %>
  
  <%= f.field :tax_id, hint: "Your Federal Tax ID (EIN) - format: XX-XXXXXXX" do %>
    <%= f.text_field :tax_id, pattern: "\\d{2}-\\d{7}" %>
  <% end %>
  
  <%= f.field :business_type do %>
    <%= f.select :business_type, [
      ['Corporation', 'corporation'],
      ['LLC', 'llc'],
      ['Partnership', 'partnership'],
      ['Sole Proprietorship', 'sole_proprietorship']
    ], { prompt: 'Select business type' } %>
  <% end %>
  
  <%= f.field :contact_info, columns: 2 do %>
    <%= f.email_field :email, placeholder: "Business email" %>
    <%= f.telephone_field :phone, placeholder: "Business phone" %>
  <% end %>
<% end %>
```

#### Product Configuration
```erb
<%= form_with model: @product, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :name do %>
    <%= f.text_field :name, required: true %>
  <% end %>
  
  <%= f.field :description, hint: "Provide a detailed description to help customers understand your product" do %>
    <%= f.text_area :description, rows: 4 %>
  <% end %>
  
  <%= f.field :pricing, columns: 2 do %>
    <%= f.number_field :price, step: 0.01, min: 0, placeholder: "Price ($)" %>
    <%= f.select :currency, currency_options, { selected: 'USD' } %>
  <% end %>
  
  <%= f.field :dimensions, columns: 3, hint: "Product dimensions for shipping calculations" do %>
    <%= f.number_field :length, step: 0.1, placeholder: "Length (in)" %>
    <%= f.number_field :width, step: 0.1, placeholder: "Width (in)" %>
    <%= f.number_field :height, step: 0.1, placeholder: "Height (in)" %>
  <% end %>
<% end %>
```

#### Event Management
```erb
<%= form_with model: @event, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :title do %>
    <%= f.text_field :title, required: true %>
  <% end %>
  
  <%= f.field :description, hint: "What attendees can expect from this event" do %>
    <%= f.text_area :description, rows: 3 %>
  <% end %>
  
  <%= f.field :schedule, columns: 2 do %>
    <%= f.datetime_local_field :starts_at %>
    <%= f.datetime_local_field :ends_at %>
  <% end %>
  
  <%= f.field :location_details, columns: 2, hint: "Venue information and capacity" do %>
    <%= f.text_field :venue_name, placeholder: "Venue name" %>
    <%= f.number_field :max_attendees, placeholder: "Max attendees" %>
  <% end %>
  
  <%= f.field :contact_info, columns: 2 do %>
    <%= f.email_field :organizer_email, placeholder: "Organizer email" %>
    <%= f.telephone_field :contact_phone, placeholder: "Contact phone" %>
  <% end %>
<% end %>
```

#### Survey Form
```erb
<%= form_with model: @response, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :satisfaction_rating, hint: "Rate your overall experience" do %>
    <%= f.select :satisfaction_rating, [
      ['Excellent', 5],
      ['Good', 4],
      ['Average', 3],
      ['Poor', 2],
      ['Very Poor', 1]
    ], { prompt: 'Select rating' } %>
  <% end %>
  
  <%= f.field :feedback, hint: "Tell us what we did well and what we could improve" do %>
    <%= f.text_area :feedback, rows: 4, placeholder: "Your feedback..." %>
  <% end %>
  
  <%= f.field :contact_info, columns: 2, hint: "Optional - if you'd like us to follow up" do %>
    <%= f.text_field :name, placeholder: "Your name (optional)" %>
    <%= f.email_field :email, placeholder: "Your email (optional)" %>
  <% end %>
  
  <%= f.field :recommend, hint: "Would you recommend us to others?" do %>
    <%= f.select :recommend, [
      ['Definitely', 'yes'],
      ['Probably', 'maybe'],
      ['Probably not', 'no']
    ], { prompt: 'Select option' } %>
  <% end %>
<% end %>
```