# ShowIf Component Guide

The ShowIf component provides conditional field visibility based on form field values, with built-in Stimulus controller integration for dynamic form behavior.

## Basic Usage

#### Simple Conditional Field
```erb
<%= form_with model: @user, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :account_type do %>
    <%= f.select :account_type, [
      ['Personal', 'personal'],
      ['Business', 'business']
    ] %>
  <% end %>

  <%= f.show_if field: :account_type, equals: 'business' do %>
    <%= f.field :company_name do %>
      <%= f.text_field :company_name %>
    <% end %>
  <% end %>
<% end %>
```

#### Multiple Conditional Fields
```erb
<%= f.show_if field: :has_pets, equals: 'yes' do %>
  <%= f.field :pet_type do %>
    <%= f.select :pet_type, [['Dog', 'dog'], ['Cat', 'cat'], ['Other', 'other']] %>
  <% end %>
  
  <%= f.field :pet_name do %>
    <%= f.text_field :pet_name %>
  <% end %>
<% end %>
```

## Customization Options

| Option | Type | Purpose |
|--------|------|---------|
| field | Symbol | The field name to watch for changes |
| equals | String/Symbol | The value that triggers visibility |

## Advanced Features

#### Nested Conditions
```erb
<%= f.show_if field: :contact_method, equals: 'email' do %>
  <%= f.field :email do %>
    <%= f.email_field :email %>
  <% end %>
  
  <%= f.field :email_frequency do %>
    <%= f.select :email_frequency, [
      ['Daily', 'daily'],
      ['Weekly', 'weekly']
    ] %>
  <% end %>
<% end %>

<%= f.show_if field: :contact_method, equals: 'phone' do %>
  <%= f.field :phone do %>
    <%= f.telephone_field :phone %>
  <% end %>
  
  <%= f.field :best_time do %>
    <%= f.select :best_time, [
      ['Morning', 'morning'],
      ['Afternoon', 'afternoon'],
      ['Evening', 'evening']
    ] %>
  <% end %>
<% end %>
```

#### Multiple Show/Hide Sections
```erb
<%= f.field :subscription_type do %>
  <%= f.select :subscription_type, [
    ['Free', 'free'],
    ['Premium', 'premium'],
    ['Enterprise', 'enterprise']
  ] %>
<% end %>

<%= f.show_if field: :subscription_type, equals: 'premium' do %>
  <%= f.field :billing_cycle do %>
    <%= f.select :billing_cycle, [
      ['Monthly', 'monthly'],
      ['Annual', 'annual']
    ] %>
  <% end %>
<% end %>

<%= f.show_if field: :subscription_type, equals: 'enterprise' do %>
  <%= f.field :company_size do %>
    <%= f.select :company_size, [
      ['1-10', 'small'],
      ['11-50', 'medium'],
      ['51+', 'large']
    ] %>
  <% end %>
  
  <%= f.field :custom_requirements do %>
    <%= f.text_area :custom_requirements, rows: 3 %>
  <% end %>
<% end %>
```

#### Complex Form Flow
```erb
<%= f.field :user_type do %>
  <%= f.select :user_type, [
    ['Individual', 'individual'],
    ['Organization', 'organization'],
    ['Student', 'student']
  ], { prompt: 'Select user type' } %>
<% end %>

<%= f.show_if field: :user_type, equals: 'individual' do %>
  <%= f.field_set do %>
    <h3>Personal Information</h3>
    <%= f.field :first_name do %>
      <%= f.text_field :first_name %>
    <% end %>
    <%= f.field :last_name do %>
      <%= f.text_field :last_name %>
    <% end %>
  <% end %>
<% end %>

<%= f.show_if field: :user_type, equals: 'organization' do %>
  <%= f.field_set do %>
    <h3>Organization Details</h3>
    <%= f.field :organization_name do %>
      <%= f.text_field :organization_name %>
    <% end %>
    <%= f.field :tax_id do %>
      <%= f.text_field :tax_id %>
    <% end %>
  <% end %>
<% end %>

<%= f.show_if field: :user_type, equals: 'student' do %>
  <%= f.field_set do %>
    <h3>Student Information</h3>
    <%= f.field :school_name do %>
      <%= f.text_field :school_name %>
    <% end %>
    <%= f.field :graduation_year do %>
      <%= f.number_field :graduation_year, min: Date.current.year %>
    <% end %>
  <% end %>
<% end %>
```

## Styling

#### Default Styles

The ShowIf component includes these style classes:
- Root: `hidden`

The component starts hidden and becomes visible when conditions are met.

#### Customizing Styles

Override the default styles in your configuration:

```ruby
# In your initializer
module OkonomiUiKit
  module Components
    module Forms
      class ShowIf
        register_styles :custom do
          {
            root: "hidden transition-all duration-300 ease-in-out"
          }
        end
      end
    end
  end
end
```

Or use runtime theme switching:

```erb
<% ui.theme(components: { forms: { show_if: { 
  root: "hidden opacity-0 transition-opacity duration-200" 
} } }) do %>
  <%= f.show_if field: :option, equals: 'yes' do %>
    <!-- conditional content -->
  <% end %>
<% end %>
```

## JavaScript Integration

The ShowIf component uses the `form-field-visibility` Stimulus controller:

```javascript
// The controller automatically:
// 1. Watches for changes on the specified field
// 2. Shows/hides the conditional section based on the equals value
// 3. Handles form field naming conventions (e.g., model_name[field_name])
```

## Best Practices

1. **Clear Dependencies**: Make field dependencies obvious to users
2. **Progressive Disclosure**: Use to reduce cognitive load
3. **Validation**: Ensure conditional fields are properly validated
4. **Accessibility**: Maintain proper focus management
5. **Performance**: Avoid too many nested conditions
6. **User Experience**: Provide smooth transitions

## Accessibility

The ShowIf component ensures accessibility by:
- Maintaining proper tab order when fields are shown/hidden
- Preserving screen reader navigation
- Using semantic HTML structure
- Supporting keyboard navigation
- Announcing changes to screen readers
- Managing focus appropriately

## Examples

#### Registration Form with Account Types
```erb
<%= form_with model: @user, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <h2>Account Information</h2>
    
    <%= f.field :account_type do %>
      <%= f.select :account_type, [
        ['Personal Account', 'personal'],
        ['Business Account', 'business'],
        ['Non-profit Organization', 'nonprofit']
      ], { prompt: 'Choose account type' } %>
    <% end %>
    
    <%= f.show_if field: :account_type, equals: 'personal' do %>
      <%= f.field :first_name do %>
        <%= f.text_field :first_name, required: true %>
      <% end %>
      <%= f.field :last_name do %>
        <%= f.text_field :last_name, required: true %>
      <% end %>
      <%= f.field :date_of_birth do %>
        <%= f.date_field :date_of_birth %>
      <% end %>
    <% end %>
    
    <%= f.show_if field: :account_type, equals: 'business' do %>
      <%= f.field :company_name do %>
        <%= f.text_field :company_name, required: true %>
      <% end %>
      <%= f.field :tax_id do %>
        <%= f.text_field :tax_id, placeholder: "EIN or Tax ID" %>
      <% end %>
      <%= f.field :business_type do %>
        <%= f.select :business_type, [
          ['Corporation', 'corporation'],
          ['LLC', 'llc'],
          ['Partnership', 'partnership'],
          ['Sole Proprietorship', 'sole_proprietorship']
        ], { prompt: 'Select business type' } %>
      <% end %>
    <% end %>
    
    <%= f.show_if field: :account_type, equals: 'nonprofit' do %>
      <%= f.field :organization_name do %>
        <%= f.text_field :organization_name, required: true %>
      <% end %>
      <%= f.field :tax_exempt_id do %>
        <%= f.text_field :tax_exempt_id, placeholder: "501(c)(3) Number" %>
      <% end %>
      <%= f.field :mission_statement do %>
        <%= f.text_area :mission_statement, rows: 3 %>
      <% end %>
    <% end %>
  <% end %>
<% end %>
```

#### E-commerce Shipping Options
```erb
<%= form_with model: @order, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :shipping_method do %>
    <%= f.select :shipping_method, [
      ['Standard Shipping', 'standard'],
      ['Express Shipping', 'express'],
      ['Store Pickup', 'pickup']
    ], { prompt: 'Choose shipping method' } %>
  <% end %>
  
  <%= f.show_if field: :shipping_method, equals: 'standard' do %>
    <%= f.field_set do %>
      <h3>Shipping Address</h3>
      <%= f.field :shipping_address do %>
        <%= f.text_field :shipping_address, required: true %>
      <% end %>
      <%= f.field :shipping_city do %>
        <%= f.text_field :shipping_city, required: true %>
      <% end %>
      <p class="text-sm text-gray-600">Delivery in 5-7 business days</p>
    <% end %>
  <% end %>
  
  <%= f.show_if field: :shipping_method, equals: 'express' do %>
    <%= f.field_set do %>
      <h3>Express Shipping Address</h3>
      <%= f.field :shipping_address do %>
        <%= f.text_field :shipping_address, required: true %>
      <% end %>
      <%= f.field :shipping_city do %>
        <%= f.text_field :shipping_city, required: true %>
      <% end %>
      <%= f.field :delivery_instructions do %>
        <%= f.text_area :delivery_instructions, rows: 2 %>
      <% end %>
      <p class="text-sm text-gray-600">Delivery in 1-2 business days (+$15.00)</p>
    <% end %>
  <% end %>
  
  <%= f.show_if field: :shipping_method, equals: 'pickup' do %>
    <%= f.field_set do %>
      <h3>Store Pickup Information</h3>
      <%= f.field :pickup_location do %>
        <%= f.select :pickup_location, [
          ['Downtown Store', 'downtown'],
          ['Mall Location', 'mall'],
          ['Warehouse', 'warehouse']
        ], { prompt: 'Choose pickup location' } %>
      <% end %>
      <%= f.field :pickup_contact do %>
        <%= f.text_field :pickup_contact, placeholder: "Contact person name" %>
      <% end %>
      <p class="text-sm text-gray-600">Ready for pickup within 2 hours</p>
    <% end %>
  <% end %>
<% end %>
```

#### Survey with Branching Logic
```erb
<%= form_with model: @survey_response, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :uses_product do %>
    <%= f.select :uses_product, [
      ['Yes, regularly', 'yes_regularly'],
      ['Yes, occasionally', 'yes_occasionally'],
      ['No, but interested', 'no_interested'],
      ['No, not interested', 'no_not_interested']
    ], { prompt: 'Do you use our product?' } %>
  <% end %>
  
  <%= f.show_if field: :uses_product, equals: 'yes_regularly' do %>
    <%= f.field_set do %>
      <h3>Regular User Feedback</h3>
      <%= f.field :satisfaction_rating do %>
        <%= f.select :satisfaction_rating, (1..5).map { |i| [i, i] }, 
            { prompt: 'Rate your satisfaction (1-5)' } %>
      <% end %>
      <%= f.field :favorite_features do %>
        <%= f.multi_select :favorite_features,
            collection: ProductFeature.all %>
      <% end %>
      <%= f.field :improvement_suggestions do %>
        <%= f.text_area :improvement_suggestions, rows: 3 %>
      <% end %>
    <% end %>
  <% end %>
  
  <%= f.show_if field: :uses_product, equals: 'yes_occasionally' do %>
    <%= f.field_set do %>
      <h3>Occasional User Feedback</h3>
      <%= f.field :usage_frequency do %>
        <%= f.select :usage_frequency, [
          ['Weekly', 'weekly'],
          ['Monthly', 'monthly'],
          ['A few times a year', 'yearly']
        ] %>
      <% end %>
      <%= f.field :barriers_to_regular_use do %>
        <%= f.text_area :barriers_to_regular_use, rows: 3 %>
      <% end %>
    <% end %>
  <% end %>
  
  <%= f.show_if field: :uses_product, equals: 'no_interested' do %>
    <%= f.field_set do %>
      <h3>Interest in Our Product</h3>
      <%= f.field :interest_level do %>
        <%= f.select :interest_level, [
          ['Very interested', 'very'],
          ['Somewhat interested', 'somewhat'],
          ['Slightly interested', 'slightly']
        ] %>
      <% end %>
      <%= f.field :what_would_convince do %>
        <%= f.text_area :what_would_convince, rows: 3,
            placeholder: "What would convince you to try our product?" %>
      <% end %>
    <% end %>
  <% end %>
<% end %>
```

#### Job Application Form
```erb
<%= form_with model: @application, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :employment_status do %>
    <%= f.select :employment_status, [
      ['Currently employed', 'employed'],
      ['Unemployed', 'unemployed'],
      ['Student', 'student'],
      ['Freelancer', 'freelancer']
    ], { prompt: 'Current employment status' } %>
  <% end %>
  
  <%= f.show_if field: :employment_status, equals: 'employed' do %>
    <%= f.field_set do %>
      <h3>Current Employment</h3>
      <%= f.field :current_employer do %>
        <%= f.text_field :current_employer %>
      <% end %>
      <%= f.field :current_position do %>
        <%= f.text_field :current_position %>
      <% end %>
      <%= f.field :notice_period do %>
        <%= f.select :notice_period, [
          ['Immediate', 'immediate'],
          ['2 weeks', '2_weeks'],
          ['1 month', '1_month'],
          ['2 months', '2_months'],
          ['3+ months', '3_months_plus']
        ] %>
      <% end %>
    <% end %>
  <% end %>
  
  <%= f.show_if field: :employment_status, equals: 'student' do %>
    <%= f.field_set do %>
      <h3>Student Information</h3>
      <%= f.field :school_name do %>
        <%= f.text_field :school_name %>
      <% end %>
      <%= f.field :graduation_date do %>
        <%= f.date_field :graduation_date %>
      <% end %>
      <%= f.field :availability do %>
        <%= f.select :availability, [
          ['Part-time during studies', 'part_time'],
          ['Full-time after graduation', 'full_time_after'],
          ['Internship', 'internship']
        ] %>
      <% end %>
    <% end %>
  <% end %>
  
  <%= f.field :remote_work_preference do %>
    <%= f.select :remote_work_preference, [
      ['Office only', 'office'],
      ['Remote only', 'remote'],
      ['Hybrid', 'hybrid']
    ] %>
  <% end %>
  
  <%= f.show_if field: :remote_work_preference, equals: 'hybrid' do %>
    <%= f.field :preferred_hybrid_schedule do %>
      <%= f.select :preferred_hybrid_schedule, [
        ['2 days office, 3 days remote', '2_3'],
        ['3 days office, 2 days remote', '3_2'],
        ['Flexible arrangement', 'flexible']
      ] %>
    <% end %>
  <% end %>
<% end %>
```

#### Settings Form with Feature Toggles
```erb
<%= form_with model: @user_settings, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :enable_notifications do %>
    <%= f.select :enable_notifications, [
      ['Yes', 'true'],
      ['No', 'false']
    ] %>
  <% end %>
  
  <%= f.show_if field: :enable_notifications, equals: 'true' do %>
    <%= f.field_set do %>
      <h3>Notification Preferences</h3>
      
      <%= f.field :email_notifications do %>
        <%= f.select :email_notifications, [
          ['All notifications', 'all'],
          ['Important only', 'important'],
          ['None', 'none']
        ] %>
      <% end %>
      
      <%= f.show_if field: :email_notifications, equals: 'all' do %>
        <%= f.field :email_frequency do %>
          <%= f.select :email_frequency, [
            ['Immediately', 'immediate'],
            ['Daily digest', 'daily'],
            ['Weekly digest', 'weekly']
          ] %>
        <% end %>
      <% end %>
      
      <%= f.field :push_notifications do %>
        <%= f.select :push_notifications, [
          ['Enabled', 'true'],
          ['Disabled', 'false']
        ] %>
      <% end %>
      
      <%= f.show_if field: :push_notifications, equals: 'true' do %>
        <%= f.field :quiet_hours_start do %>
          <%= f.time_field :quiet_hours_start %>
        <% end %>
        <%= f.field :quiet_hours_end do %>
          <%= f.time_field :quiet_hours_end %>
        <% end %>
      <% end %>
    <% end %>
  <% end %>
<% end %>
```