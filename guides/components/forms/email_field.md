# EmailField Component Guide

The EmailField component provides a styled email input with built-in validation and mobile-optimized keyboard support for entering email addresses.

## Basic Usage

#### Simple Email Field
```erb
<%= form_with model: @user, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :email do %>
    <%= f.email_field :email %>
  <% end %>
<% end %>
```

#### With Placeholder
```erb
<%= f.email_field :email, placeholder: "Enter your email address" %>
```

#### With Required Validation
```erb
<%= f.email_field :email, required: true %>
```

## Customization Options

| Option | Type | Purpose |
|--------|------|---------|
| placeholder | String | Placeholder text when field is empty |
| required | Boolean | Mark field as required |
| disabled | Boolean | Disable the input |
| readonly | Boolean | Make field read-only |
| pattern | String | Custom regex pattern for validation |
| maxlength | Integer | Maximum number of characters |
| autocomplete | String | Autocomplete behavior ("email", "off") |
| class | String | Additional CSS classes |
| data | Hash | Data attributes for JavaScript |

## Advanced Features

#### Email Validation with Custom Pattern
```erb
<%= f.email_field :work_email,
    pattern: "[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$",
    title: "Please enter a valid work email address" %>
```

#### Multiple Email Addresses
```erb
<%= f.email_field :notification_emails,
    multiple: true,
    placeholder: "Enter multiple emails separated by commas" %>
```

#### Domain-Specific Validation
```erb
<%= f.email_field :company_email,
    data: {
      controller: "email-validator",
      email_validator_domain: "@company.com",
      email_validator_message: "Please use your company email address"
    } %>
```

#### With JavaScript Enhancement
```erb
<%= f.email_field :email,
    data: {
      controller: "email-suggestions",
      email_suggestions_domains: ["gmail.com", "yahoo.com", "hotmail.com"].to_json
    } %>
```

#### Auto-completion Setup
```erb
<%= f.email_field :billing_email,
    autocomplete: "billing email",
    data: {
      controller: "email-autocomplete",
      email_autocomplete_source_url: contacts_emails_path
    } %>
```

## Styling

#### Default Styles

The EmailField inherits styles from InputBase:
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
      class EmailField
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
<% ui.theme(components: { forms: { email_field: { 
  root: "rounded-xl shadow-sm" 
} } }) do %>
  <%= f.email_field :email %>
<% end %>
```

## Best Practices

1. **Clear Labels**: Use descriptive labels like "Email Address" or "Work Email"
2. **Proper Validation**: Combine client-side and server-side email validation
3. **Helpful Placeholders**: Show format examples in placeholder text
4. **Autocomplete**: Enable autocomplete for better user experience
5. **Error Messages**: Provide specific error messages for different validation failures
6. **Privacy Considerations**: Be clear about how email addresses will be used

## Accessibility

The EmailField component ensures accessibility by:
- Using native HTML5 email input type
- Triggering appropriate mobile keyboards
- Supporting keyboard navigation (Tab, Enter)
- Providing clear label associations
- Including proper ARIA attributes for error states
- Working with screen readers and password managers
- Showing visual focus indicators
- Supporting autocomplete attributes

## Examples

#### User Registration Form
```erb
<%= form_with model: @user, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <h2>Create Your Account</h2>
    
    <%= f.field :email do %>
      <%= f.email_field :email,
          placeholder: "your.email@example.com",
          required: true,
          autocomplete: "email",
          data: {
            controller: "email-validator",
            email_validator_check_availability: true
          } %>
    <% end %>
    
    <%= f.field :confirm_email do %>
      <%= f.email_field :confirm_email,
          placeholder: "Confirm your email address",
          required: true,
          data: {
            controller: "email-confirmation",
            email_confirmation_match_field: "user_email"
          } %>
    <% end %>
  <% end %>
<% end %>
```

#### Contact Form
```erb
<%= form_with model: @contact, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :email do %>
    <%= f.email_field :email,
        placeholder: "your.email@example.com",
        required: true,
        autocomplete: "email" %>
    <span class="text-sm text-gray-500">
      We'll use this email to respond to your message
    </span>
  <% end %>
  
  <%= f.field :cc_email do %>
    <%= f.email_field :cc_email,
        multiple: true,
        placeholder: "Additional recipients (optional)" %>
    <span class="text-sm text-gray-500">
      Separate multiple emails with commas
    </span>
  <% end %>
<% end %>
```

#### Newsletter Subscription
```erb
<%= form_with model: @subscription, builder: OkonomiUiKit::FormBuilder do |f| %>
  <div class="bg-blue-50 p-6 rounded-lg">
    <h3 class="text-lg font-semibold mb-4">Subscribe to Our Newsletter</h3>
    
    <%= f.field :email do %>
      <%= f.email_field :email,
          placeholder: "Enter your email address",
          required: true,
          class: "text-lg py-3",
          data: {
            controller: "subscription-form",
            subscription_form_validate_on_blur: true
          } %>
    <% end %>
    
    <p class="text-sm text-gray-600 mt-2">
      Get weekly updates and exclusive content delivered to your inbox.
    </p>
  </div>
<% end %>
```

#### Team Member Invitation
```erb
<%= form_with model: @invitation, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :recipient_email do %>
    <%= f.email_field :recipient_email,
        placeholder: "colleague.name@company.com",
        required: true,
        pattern: "[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$",
        data: {
          controller: "team-invitation",
          team_invitation_check_existing: true,
          team_invitation_team_id: @team.id
        } %>
    <span class="text-sm text-gray-500">
      We'll send an invitation to join the team
    </span>
  <% end %>
  
  <%= f.field :cc_manager do %>
    <%= f.email_field :cc_manager,
        placeholder: "manager@company.com (optional)",
        autocomplete: "off" %>
    <span class="text-sm text-gray-500">
      Copy team manager on invitation
    </span>
  <% end %>
<% end %>
```

#### Account Settings
```erb
<%= form_with model: @user, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <h3>Email Preferences</h3>
    
    <%= f.field :primary_email do %>
      <%= f.email_field :primary_email,
          required: true,
          autocomplete: "email",
          readonly: f.object.email_verified? %>
      <% if f.object.email_verified? %>
        <span class="text-sm text-green-600">✓ Verified</span>
      <% else %>
        <span class="text-sm text-yellow-600">⚠ Unverified</span>
      <% end %>
    <% end %>
    
    <%= f.field :backup_email do %>
      <%= f.email_field :backup_email,
          placeholder: "backup.email@example.com",
          autocomplete: "off" %>
      <span class="text-sm text-gray-500">
        Used for account recovery if primary email is unavailable
      </span>
    <% end %>
    
    <%= f.field :notification_email do %>
      <%= f.email_field :notification_email,
          placeholder: "Same as primary email",
          value: f.object.notification_email || f.object.primary_email %>
      <span class="text-sm text-gray-500">
        Where to send account notifications
      </span>
    <% end %>
  <% end %>
<% end %>
```

#### Support Ticket System
```erb
<%= form_with model: @ticket, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :requester_email do %>
    <%= f.email_field :requester_email,
        placeholder: "your.email@company.com",
        required: true,
        pattern: ".*@(company\.com|partner\.org)$",
        title: "Please use your company or partner organization email" %>
    <span class="text-sm text-gray-500">
      Must be a company or partner email address
    </span>
  <% end %>
  
  <%= f.field :technical_contact do %>
    <%= f.email_field :technical_contact,
        placeholder: "tech.lead@company.com (optional)",
        data: {
          controller: "user-lookup",
          user_lookup_role: "technical"
        } %>
    <span class="text-sm text-gray-500">
      Technical contact for this issue
    </span>
  <% end %>
<% end %>
```