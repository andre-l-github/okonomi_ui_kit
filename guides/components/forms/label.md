# Label Component Guide

The Label component provides consistent, accessible form labels with automatic text retrieval from I18n translations and customizable styling.

## Basic Usage

#### Simple Label
```erb
<%= form_with model: @user, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.label :name %>
  <%= f.text_field :name %>
<% end %>
```

#### Custom Label Text
```erb
<%= f.label :email, "Email Address" %>
<%= f.email_field :email %>
```

#### Label with Block Content
```erb
<%= f.label :terms do %>
  I agree to the <a href="/terms">Terms of Service</a>
<% end %>
<%= f.check_box :terms %>
```

## Customization Options

| Option | Type | Purpose |
|--------|------|---------|
| text | String | Custom label text (overrides I18n) |
| class | String | Additional CSS classes |
| for | String | Explicit association with input ID |

## Advanced Features

#### I18n Integration
```erb
<!-- Automatically looks for: activerecord.attributes.user.first_name -->
<%= f.label :first_name %>

<!-- You can also use custom translation keys -->
<%= f.label :email, t('forms.email_address') %>
```

#### Required Field Indicators
```erb
<%= f.label :email, class: "required" do %>
  Email Address <span class="text-red-500">*</span>
<% end %>
```

#### Accessible Labels with Help Text
```erb
<%= f.label :password do %>
  Password
  <span class="text-sm text-gray-500">(minimum 8 characters)</span>
<% end %>
<%= f.password_field :password %>
```

#### Complex Label Content
```erb
<%= f.label :marketing_emails, class: "flex items-center space-x-2" do %>
  <%= f.check_box :marketing_emails %>
  <span>
    Send me marketing emails about new features and promotions
    <span class="text-xs text-gray-500 block">You can unsubscribe at any time</span>
  </span>
<% end %>
```

#### Conditional Labels
```erb
<%= f.label :business_name if @user.account_type == 'business' %>
<%= f.text_field :business_name if @user.account_type == 'business' %>
```

## Styling

#### Default Styles

The Label component includes these style classes:
- Root: `block text-sm/6 font-medium text-gray-900`

#### Customizing Styles

Override the default styles in your configuration:

```ruby
# In your initializer
module OkonomiUiKit
  module Components
    module Forms
      class Label
        register_styles :custom do
          {
            root: "block text-base font-semibold text-gray-800 mb-2"
          }
        end
      end
    end
  end
end
```

Or use runtime theme switching:

```erb
<% ui.theme(components: { forms: { label: { 
  root: "text-lg font-bold text-blue-900" 
} } }) do %>
  <%= f.label :name %>
<% end %>
```

#### Contextual Styling
```erb
<%= f.label :priority, class: "text-red-600 font-semibold" %>
<%= f.label :notes, class: "text-gray-600 text-sm" %>
<%= f.label :featured, class: "text-green-600 font-medium" %>
```

## Best Practices

1. **Clear Text**: Use descriptive, clear label text
2. **Consistent Styling**: Maintain consistent typography across labels
3. **Required Indicators**: Clearly mark required fields
4. **I18n Support**: Use translation keys for internationalization
5. **Accessibility**: Ensure proper association with form controls
6. **Help Text**: Include helpful context when needed

## Accessibility

The Label component ensures accessibility by:
- Using semantic HTML label elements
- Automatic association with form controls
- Supporting screen readers
- Providing clear text hierarchy
- Working with keyboard navigation
- Following WCAG guidelines for label requirements

## Examples

#### Registration Form Labels
```erb
<%= form_with model: @user, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <h2>Create Account</h2>
    
    <%= f.field :email do %>
      <%= f.label :email, class: "required" do %>
        Email Address <span class="text-red-500">*</span>
      <% end %>
      <%= f.email_field :email, required: true %>
    <% end %>
    
    <%= f.field :password do %>
      <%= f.label :password do %>
        Password
        <span class="text-sm text-gray-500">(minimum 8 characters)</span>
      <% end %>
      <%= f.password_field :password, required: true %>
    <% end %>
    
    <%= f.field :terms do %>
      <%= f.label :terms, class: "flex items-center space-x-2 cursor-pointer" do %>
        <%= f.check_box :terms, required: true %>
        <span>
          I agree to the 
          <%= link_to "Terms of Service", terms_path, class: "text-blue-600 underline" %>
          and 
          <%= link_to "Privacy Policy", privacy_path, class: "text-blue-600 underline" %>
        </span>
      <% end %>
    <% end %>
  <% end %>
<% end %>
```

#### Contact Form with Contextual Labels
```erb
<%= form_with model: @contact, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :name do %>
    <%= f.label :name, "Full Name" %>
    <%= f.text_field :name, required: true %>
  <% end %>
  
  <%= f.field :email do %>
    <%= f.label :email do %>
      Email Address
      <span class="text-sm text-gray-500">(for our response)</span>
    <% end %>
    <%= f.email_field :email, required: true %>
  <% end %>
  
  <%= f.field :phone do %>
    <%= f.label :phone do %>
      Phone Number
      <span class="text-sm text-gray-500">(optional)</span>
    <% end %>
    <%= f.telephone_field :phone %>
  <% end %>
  
  <%= f.field :urgency do %>
    <%= f.label :urgency, "How urgent is your request?" %>
    <%= f.select :urgency, [
      ['Low - General inquiry', 'low'],
      ['Medium - Need response within a week', 'medium'],
      ['High - Need response within 24 hours', 'high'],
      ['Critical - Emergency', 'critical']
    ], { prompt: 'Select urgency level' } %>
  <% end %>
<% end %>
```

#### E-commerce Product Form
```erb
<%= form_with model: @product, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :name do %>
    <%= f.label :name, class: "text-lg font-semibold" %>
    <%= f.text_field :name, required: true %>
  <% end %>
  
  <%= f.field :description do %>
    <%= f.label :description do %>
      Product Description
      <span class="text-sm text-gray-500">
        Detailed description to help customers understand your product
      </span>
    <% end %>
    <%= f.text_area :description, rows: 4 %>
  <% end %>
  
  <%= f.field :price do %>
    <%= f.label :price, class: "font-semibold text-green-700" %>
    <%= f.number_field :price, step: 0.01, min: 0 %>
  <% end %>
  
  <%= f.field :featured do %>
    <%= f.label :featured, class: "flex items-center space-x-2 cursor-pointer" do %>
      <%= f.check_box :featured %>
      <span class="font-medium">
        Featured Product
        <span class="text-sm text-gray-500 block">
          Show this product prominently on the homepage
        </span>
      </span>
    <% end %>
  <% end %>
<% end %>
```

#### Settings Form with Grouped Labels
```erb
<%= form_with model: @settings, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <h3 class="text-lg font-semibold mb-4">Profile Settings</h3>
    
    <%= f.field :display_name do %>
      <%= f.label :display_name, "Display Name" %>
      <%= f.text_field :display_name %>
    <% end %>
    
    <%= f.field :bio do %>
      <%= f.label :bio do %>
        Bio
        <span class="text-sm text-gray-500">(appears on your public profile)</span>
      <% end %>
      <%= f.text_area :bio, rows: 3 %>
    <% end %>
  <% end %>
  
  <%= f.field_set do %>
    <h3 class="text-lg font-semibold mb-4">Privacy Settings</h3>
    
    <%= f.field :profile_visible do %>
      <%= f.label :profile_visible, class: "flex items-center space-x-2 cursor-pointer" do %>
        <%= f.check_box :profile_visible %>
        <span>Make my profile visible to other users</span>
      <% end %>
    <% end %>
    
    <%= f.field :email_notifications do %>
      <%= f.label :email_notifications, class: "flex items-center space-x-2 cursor-pointer" do %>
        <%= f.check_box :email_notifications %>
        <span>
          Send me email notifications
          <span class="text-sm text-gray-500 block">
            For important updates and messages
          </span>
        </span>
      <% end %>
    <% end %>
  <% end %>
<% end %>
```

#### Survey Form with Descriptive Labels
```erb
<%= form_with model: @survey_response, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :satisfaction do %>
    <%= f.label :satisfaction, class: "text-base font-medium" do %>
      Overall Satisfaction
      <span class="text-sm text-gray-600 block font-normal">
        How satisfied are you with our service overall?
      </span>
    <% end %>
    <%= f.select :satisfaction, [
      ['Very Satisfied', 5],
      ['Satisfied', 4],
      ['Neutral', 3],
      ['Dissatisfied', 2],
      ['Very Dissatisfied', 1]
    ], { prompt: 'Please select...' } %>
  <% end %>
  
  <%= f.field :recommendation do %>
    <%= f.label :recommendation, class: "text-base font-medium" do %>
      Likelihood to Recommend
      <span class="text-sm text-gray-600 block font-normal">
        How likely are you to recommend us to a friend or colleague?
      </span>
    <% end %>
    <%= f.select :recommendation, (0..10).map { |i| [i, i] }, { prompt: 'Select 0-10' } %>
  <% end %>
  
  <%= f.field :comments do %>
    <%= f.label :comments do %>
      Additional Comments
      <span class="text-sm text-gray-500">
        (optional) Tell us what we're doing well or how we can improve
      </span>
    <% end %>
    <%= f.text_area :comments, rows: 4 %>
  <% end %>
<% end %>
```

#### Multi-language Form Labels
```erb
<!-- In your locale files: -->
<!-- en.yml:
activerecord:
  attributes:
    user:
      first_name: "First Name"
      last_name: "Last Name"
      email: "Email Address"
      
es.yml:
activerecord:
  attributes:
    user:
      first_name: "Nombre"
      last_name: "Apellido"
      email: "Correo Electrónico"
-->

<%= form_with model: @user, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :first_name do %>
    <%= f.label :first_name %> <!-- Automatically uses I18n -->
    <%= f.text_field :first_name %>
  <% end %>
  
  <%= f.field :last_name do %>
    <%= f.label :last_name %> <!-- Automatically uses I18n -->
    <%= f.text_field :last_name %>
  <% end %>
  
  <%= f.field :email do %>
    <%= f.label :email %> <!-- Automatically uses I18n -->
    <%= f.email_field :email %>
  <% end %>
<% end %>
```