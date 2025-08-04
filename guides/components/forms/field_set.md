# FieldSet Component Guide

The FieldSet component provides a semantic grouping container for related form fields with consistent spacing and responsive layout support.

## Basic Usage

#### Simple Field Set
```erb
<%= form_with model: @user, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <%= f.field :first_name do %>
      <%= f.text_field :first_name %>
    <% end %>
    
    <%= f.field :last_name do %>
      <%= f.text_field :last_name %>
    <% end %>
  <% end %>
<% end %>
```

#### Field Set with Title
```erb
<%= f.field_set do %>
  <h3>Personal Information</h3>
  
  <%= f.field :name do %>
    <%= f.text_field :name %>
  <% end %>
  
  <%= f.field :email do %>
    <%= f.email_field :email %>
  <% end %>
<% end %>
```

#### Multiple Field Sets
```erb
<%= form_with model: @order, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <h3>Order Details</h3>
    <%= f.field :item_count do %>
      <%= f.number_field :item_count %>
    <% end %>
  <% end %>
  
  <%= f.field_set do %>
    <h3>Shipping Information</h3>
    <%= f.field :address do %>
      <%= f.text_field :address %>
    <% end %>
  <% end %>
<% end %>
```

## Customization Options

| Option | Type | Purpose |
|--------|------|---------|
| class | String | Additional CSS classes for the fieldset |

## Advanced Features

#### Responsive Layout Groups
```erb
<%= f.field_set class: "grid md:grid-cols-2 gap-6" do %>
  <div>
    <h4>Primary Contact</h4>
    <%= f.field :primary_email do %>
      <%= f.email_field :primary_email %>
    <% end %>
    <%= f.field :primary_phone do %>
      <%= f.telephone_field :primary_phone %>
    <% end %>
  </div>
  
  <div>
    <h4>Secondary Contact</h4>
    <%= f.field :secondary_email do %>
      <%= f.email_field :secondary_email %>
    <% end %>
    <%= f.field :secondary_phone do %>
      <%= f.telephone_field :secondary_phone %>
    <% end %>
  </div>
<% end %>
```

#### Conditional Field Sets
```erb
<%= f.field_set do %>
  <h3>Account Type</h3>
  <%= f.field :account_type do %>
    <%= f.select :account_type, [['Personal', 'personal'], ['Business', 'business']] %>
  <% end %>
<% end %>

<%= f.show_if field: :account_type, equals: 'business' do %>
  <%= f.field_set do %>
    <h3>Business Information</h3>
    <%= f.field :company_name do %>
      <%= f.text_field :company_name %>
    <% end %>
    <%= f.field :tax_id do %>
      <%= f.text_field :tax_id %>
    <% end %>
  <% end %>
<% end %>
```

#### Nested Field Organization
```erb
<%= f.field_set class: "space-y-8" do %>
  <div>
    <h2>User Profile</h2>
    
    <%= f.field_set class: "border-l-4 border-blue-200 pl-4" do %>
      <h3>Basic Information</h3>
      <%= f.field :name do %>
        <%= f.text_field :name %>
      <% end %>
      <%= f.field :email do %>
        <%= f.email_field :email %>
      <% end %>
    <% end %>
    
    <%= f.field_set class: "border-l-4 border-green-200 pl-4" do %>
      <h3>Preferences</h3>
      <%= f.field :theme do %>
        <%= f.select :theme, [['Light', 'light'], ['Dark', 'dark']] %>
      <% end %>
      <%= f.field :language do %>
        <%= f.select :language, [['English', 'en'], ['Spanish', 'es']] %>
      <% end %>
    <% end %>
  </div>
<% end %>
```

#### Form Sections with Headers
```erb
<%= form_with model: @application, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set class: "bg-gray-50 p-6 rounded-lg" do %>
    <div class="border-b border-gray-200 pb-4 mb-6">
      <h2 class="text-xl font-semibold">Personal Details</h2>
      <p class="text-gray-600">Basic information about yourself</p>
    </div>
    
    <%= f.field :full_name do %>
      <%= f.text_field :full_name %>
    <% end %>
    
    <%= f.field :date_of_birth do %>
      <%= f.date_field :date_of_birth %>
    <% end %>
  <% end %>
<% end %>
```

## Styling

#### Default Styles

The FieldSet component includes these style classes:
- Root: `w-full flex flex-col gap-4 col-span-1 sm:col-span-3 md:col-span-5`

#### Customizing Styles

Override the default styles in your configuration:

```ruby
# In your initializer
module OkonomiUiKit
  module Components
    module Forms
      class FieldSet
        register_styles :custom do
          {
            root: "w-full space-y-6 p-6 bg-white border border-gray-200 rounded-lg shadow-sm"
          }
        end
      end
    end
  end
end
```

Or use runtime theme switching:

```erb
<% ui.theme(components: { forms: { field_set: { 
  root: "space-y-4 p-4 bg-gray-50 rounded-md" 
} } }) do %>
  <%= f.field_set do %>
    <!-- fields here -->
  <% end %>
<% end %>
```

## Best Practices

1. **Logical Grouping**: Group related fields together (e.g., contact info, billing info)
2. **Clear Headings**: Use descriptive headings for each field set
3. **Visual Hierarchy**: Use consistent spacing and typography
4. **Responsive Design**: Consider how field sets stack on mobile devices
5. **Progressive Disclosure**: Use conditional field sets to reduce cognitive load
6. **Semantic HTML**: Leverage the fieldset's semantic meaning for accessibility

## Accessibility

The FieldSet component ensures accessibility by:
- Using semantic HTML fieldset element for grouping
- Supporting screen reader navigation
- Providing logical tab order through grouped fields
- Maintaining focus management within groups
- Supporting ARIA attributes for enhanced semantics
- Ensuring keyboard navigation works properly

## Examples

#### User Registration Form
```erb
<%= form_with model: @user, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <h2>Create Your Account</h2>
    <p class="text-gray-600 mb-4">Basic information to get started</p>
    
    <%= f.field :email do %>
      <%= f.email_field :email, required: true %>
    <% end %>
    
    <%= f.field :password do %>
      <%= f.password_field :password, required: true %>
    <% end %>
    
    <%= f.field :password_confirmation do %>
      <%= f.password_field :password_confirmation, required: true %>
    <% end %>
  <% end %>
  
  <%= f.field_set do %>
    <h2>Profile Information</h2>
    <p class="text-gray-600 mb-4">Help others connect with you</p>
    
    <%= f.field :first_name do %>
      <%= f.text_field :first_name %>
    <% end %>
    
    <%= f.field :last_name do %>
      <%= f.text_field :last_name %>
    <% end %>
    
    <%= f.field :bio do %>
      <%= f.text_area :bio, rows: 3 %>
    <% end %>
  <% end %>
<% end %>
```

#### E-commerce Checkout
```erb
<%= form_with model: @order, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set class: "border border-gray-200 rounded-lg p-6" do %>
    <h3 class="text-lg font-semibold mb-4">Billing Information</h3>
    
    <%= f.field :billing_name do %>
      <%= f.text_field :billing_name, required: true %>
    <% end %>
    
    <%= f.field :billing_email do %>
      <%= f.email_field :billing_email, required: true %>
    <% end %>
    
    <%= f.field :billing_address do %>
      <%= f.text_field :billing_address, required: true %>
    <% end %>
  <% end %>
  
  <%= f.field_set class: "border border-gray-200 rounded-lg p-6" do %>
    <div class="flex items-center justify-between mb-4">
      <h3 class="text-lg font-semibold">Shipping Information</h3>
      <label class="flex items-center">
        <%= f.check_box :same_as_billing %>
        <span class="ml-2 text-sm">Same as billing</span>
      </label>
    </div>
    
    <%= f.field :shipping_name do %>
      <%= f.text_field :shipping_name %>
    <% end %>
    
    <%= f.field :shipping_address do %>
      <%= f.text_field :shipping_address %>
    <% end %>
  <% end %>
<% end %>
```

#### Multi-Step Application
```erb
<%= form_with model: @application, builder: OkonomiUiKit::FormBuilder do |f| %>
  <!-- Step 1: Personal Information -->
  <%= f.field_set class: "step" do %>
    <div class="step-header">
      <h2>Step 1: Personal Information</h2>
      <div class="progress-bar">
        <div class="progress" style="width: 33%"></div>
      </div>
    </div>
    
    <%= f.field :full_name do %>
      <%= f.text_field :full_name, required: true %>
    <% end %>
    
    <%= f.field :date_of_birth do %>
      <%= f.date_field :date_of_birth, required: true %>
    <% end %>
    
    <%= f.field :ssn do %>
      <%= f.text_field :ssn, pattern: "\\d{3}-\\d{2}-\\d{4}" %>
    <% end %>
  <% end %>
  
  <!-- Step 2: Employment Information -->
  <%= f.field_set class: "step hidden" do %>
    <div class="step-header">
      <h2>Step 2: Employment Information</h2>
      <div class="progress-bar">
        <div class="progress" style="width: 66%"></div>
      </div>
    </div>
    
    <%= f.field :employer_name do %>
      <%= f.text_field :employer_name, required: true %>
    <% end %>
    
    <%= f.field :job_title do %>
      <%= f.text_field :job_title %>
    <% end %>
    
    <%= f.field :annual_income do %>
      <%= f.number_field :annual_income, min: 0, step: 1000 %>
    <% end %>
  <% end %>
<% end %>
```

#### Settings Configuration
```erb
<%= form_with model: @settings, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set class: "settings-section" do %>
    <div class="section-header">
      <h3>Account Settings</h3>
      <p class="text-sm text-gray-600">Manage your account preferences</p>
    </div>
    
    <%= f.field :username do %>
      <%= f.text_field :username %>
    <% end %>
    
    <%= f.field :email do %>
      <%= f.email_field :email %>
    <% end %>
    
    <%= f.field :timezone do %>
      <%= f.select :timezone, timezone_options %>
    <% end %>
  <% end %>
  
  <%= f.field_set class: "settings-section" do %>
    <div class="section-header">
      <h3>Privacy Settings</h3>
      <p class="text-sm text-gray-600">Control your privacy and visibility</p>
    </div>
    
    <%= f.field :profile_visibility do %>
      <%= f.select :profile_visibility, [
        ['Public', 'public'],
        ['Friends Only', 'friends'],
        ['Private', 'private']
      ] %>
    <% end %>
    
    <%= f.field :email_notifications do %>
      <%= f.check_box :email_notifications %>
    <% end %>
  <% end %>
  
  <%= f.field_set class: "settings-section" do %>
    <div class="section-header">
      <h3>Security Settings</h3>
      <p class="text-sm text-gray-600">Keep your account secure</p>
    </div>
    
    <%= f.field :two_factor_enabled do %>
      <%= f.check_box :two_factor_enabled %>
    <% end %>
    
    <%= f.field :session_timeout do %>
      <%= f.select :session_timeout, [
        ['15 minutes', 15],
        ['30 minutes', 30],
        ['1 hour', 60],
        ['4 hours', 240]
      ] %>
    <% end %>
  <% end %>
<% end %>
```

#### Survey Form with Sections
```erb
<%= form_with model: @survey_response, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set class: "survey-section" do %>
    <h3>Demographics</h3>
    <p class="text-gray-600 mb-4">Optional information to help us understand our audience</p>
    
    <%= f.field :age_range do %>
      <%= f.select :age_range, [
        ['18-24', '18-24'],
        ['25-34', '25-34'],
        ['35-44', '35-44'],
        ['45-54', '45-54'],
        ['55+', '55+']
      ], { prompt: 'Select age range' } %>
    <% end %>
    
    <%= f.field :location do %>
      <%= f.text_field :location, placeholder: "City, State" %>
    <% end %>
  <% end %>
  
  <%= f.field_set class: "survey-section" do %>
    <h3>Experience Rating</h3>
    <p class="text-gray-600 mb-4">How would you rate different aspects of our service?</p>
    
    <%= f.field :overall_satisfaction do %>
      <%= f.select :overall_satisfaction, (1..5).map { |i| [i, i] }, { prompt: 'Rate 1-5' } %>
    <% end %>
    
    <%= f.field :ease_of_use do %>
      <%= f.select :ease_of_use, (1..5).map { |i| [i, i] }, { prompt: 'Rate 1-5' } %>
    <% end %>
    
    <%= f.field :customer_support do %>
      <%= f.select :customer_support, (1..5).map { |i| [i, i] }, { prompt: 'Rate 1-5' } %>
    <% end %>
  <% end %>
  
  <%= f.field_set class: "survey-section" do %>
    <h3>Additional Feedback</h3>
    
    <%= f.field :comments do %>
      <%= f.text_area :comments, rows: 4, placeholder: "Any additional comments or suggestions?" %>
    <% end %>
    
    <%= f.field :follow_up do %>
      <%= f.check_box :follow_up %>
    <% end %>
  <% end %>
<% end %>
```