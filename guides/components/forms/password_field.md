# PasswordField Component Guide

The PasswordField component provides a secure password input with masked characters, built-in validation support, and accessibility features for password entry.

## Basic Usage

#### Simple Password Field
```erb
<%= form_with model: @user, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :password do %>
    <%= f.password_field :password %>
  <% end %>
<% end %>
```

#### With Requirements
```erb
<%= f.password_field :password, 
    required: true, 
    minlength: 8 %>
```

#### Password Confirmation
```erb
<%= f.field :password do %>
  <%= f.password_field :password, required: true %>
<% end %>

<%= f.field :password_confirmation do %>
  <%= f.password_field :password_confirmation, required: true %>
<% end %>
```

## Customization Options

| Option | Type | Purpose |
|--------|------|---------|
| placeholder | String | Placeholder text when field is empty |
| required | Boolean | Mark field as required |
| disabled | Boolean | Disable the input |
| readonly | Boolean | Make field read-only |
| minlength | Integer | Minimum password length |
| maxlength | Integer | Maximum password length |
| pattern | String | Regular expression pattern for validation |
| autocomplete | String | Autocomplete behavior ("new-password", "current-password") |
| class | String | Additional CSS classes |
| data | Hash | Data attributes for JavaScript |

## Advanced Features

#### Password Strength Validation
```erb
<%= f.password_field :password,
    minlength: 8,
    pattern: "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]",
    data: {
      controller: "password-strength",
      password_strength_target: "input"
    } %>

<div data-password-strength-target="indicator" class="mt-2"></div>
```

#### Show/Hide Password Toggle
```erb
<div class="relative">
  <%= f.password_field :password,
      data: {
        controller: "password-toggle",
        password_toggle_target: "input"
      } %>
  
  <button type="button" 
          class="absolute right-2 top-1/2 -translate-y-1/2"
          data-action="password-toggle#toggle"
          data-password-toggle-target="button">
    Show
  </button>
</div>
```

#### Password Confirmation Matching
```erb
<%= f.password_field :password,
    data: {
      controller: "password-confirmation",
      password_confirmation_target: "original"
    } %>

<%= f.password_field :password_confirmation,
    data: {
      controller: "password-confirmation",
      password_confirmation_target: "confirmation",
      action: "input->password-confirmation#validate"
    } %>
```

#### New vs Current Password
```erb
<!-- For registration/new password -->
<%= f.password_field :password, autocomplete: "new-password" %>

<!-- For login/current password -->
<%= f.password_field :password, autocomplete: "current-password" %>

<!-- For password change -->
<%= f.password_field :current_password, autocomplete: "current-password" %>
<%= f.password_field :password, autocomplete: "new-password" %>
```

#### Generated Password Suggestion
```erb
<%= f.password_field :password,
    data: {
      controller: "password-generator",
      password_generator_length: 16
    } %>

<button type="button" 
        data-action="password-generator#generate"
        class="mt-2 text-sm text-blue-600 hover:text-blue-800">
  Generate secure password
</button>
```

## Styling

#### Default Styles

The PasswordField inherits styles from InputBase:
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
      class PasswordField
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
<% ui.theme(components: { forms: { password_field: { 
  root: "font-mono tracking-wider" 
} } }) do %>
  <%= f.password_field :password %>
<% end %>
```

## Best Practices

1. **Security First**: Use appropriate autocomplete attributes
2. **Clear Requirements**: Communicate password requirements upfront
3. **Strength Indicators**: Provide real-time feedback on password strength
4. **Confirmation Fields**: Use for critical password changes
5. **Accessibility**: Ensure screen reader compatibility
6. **No Auto-fill**: Be careful with autocomplete settings for sensitive forms

## Accessibility

The PasswordField component ensures accessibility by:
- Using native HTML5 password input type
- Supporting password managers and autofill
- Providing clear label associations
- Including proper ARIA attributes for error states
- Working with screen readers (though content is masked)
- Supporting keyboard navigation
- Showing visual focus indicators
- Proper autocomplete attributes for password managers

## Examples

#### User Registration
```erb
<%= form_with model: @user, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <h2>Create Your Account</h2>
    
    <%= f.field :email do %>
      <%= f.email_field :email, required: true, autocomplete: "email" %>
    <% end %>
    
    <%= f.field :password, hint: "Must be at least 8 characters with uppercase, lowercase, number, and special character" do %>
      <div class="relative">
        <%= f.password_field :password,
            required: true,
            minlength: 8,
            autocomplete: "new-password",
            data: {
              controller: "password-strength password-toggle",
              password_strength_target: "input",
              password_toggle_target: "input"
            } %>
        
        <button type="button" 
                class="absolute right-2 top-1/2 -translate-y-1/2 text-gray-500 hover:text-gray-700"
                data-action="password-toggle#toggle"
                data-password-toggle-target="button">
          <span data-password-toggle-target="icon">👁️</span>
        </button>
      </div>
      
      <div data-password-strength-target="indicator" class="mt-2 space-y-1">
        <div class="text-xs text-gray-600">Password strength:</div>
        <div class="w-full bg-gray-200 rounded-full h-2">
          <div data-password-strength-target="bar" class="h-2 rounded-full transition-all duration-300"></div>
        </div>
      </div>
    <% end %>
    
    <%= f.field :password_confirmation do %>
      <%= f.password_field :password_confirmation,
          required: true,
          autocomplete: "new-password",
          data: {
            controller: "password-confirmation",
            password_confirmation_target: "confirmation",
            password_confirmation_original_selector: "#user_password",
            action: "input->password-confirmation#validate"
          } %>
      <div data-password-confirmation-target="message" class="text-sm mt-1"></div>
    <% end %>
  <% end %>
<% end %>
```

#### Login Form
```erb
<%= form_with model: @user, url: login_path, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <h2>Sign In</h2>
    
    <%= f.field :email do %>
      <%= f.email_field :email, 
          required: true, 
          autocomplete: "email",
          placeholder: "Enter your email" %>
    <% end %>
    
    <%= f.field :password do %>
      <%= f.password_field :password,
          required: true,
          autocomplete: "current-password",
          placeholder: "Enter your password" %>
    <% end %>
    
    <%= f.field :remember_me do %>
      <%= f.check_box_with_label :remember_me, label: "Keep me signed in" %>
    <% end %>
    
    <div class="text-right">
      <%= link_to "Forgot password?", forgot_password_path, class: "text-sm text-blue-600 hover:text-blue-800" %>
    </div>
  <% end %>
<% end %>
```

#### Password Change Form
```erb
<%= form_with model: @user, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <h3>Change Password</h3>
    <p class="text-gray-600 mb-4">Enter your current password and choose a new one</p>
    
    <%= f.field :current_password do %>
      <%= f.password_field :current_password,
          required: true,
          autocomplete: "current-password",
          placeholder: "Current password" %>
    <% end %>
    
    <%= f.field :password, hint: "New password requirements: 8+ characters, mixed case, numbers, symbols" do %>
      <div class="relative">
        <%= f.password_field :password,
            required: true,
            minlength: 8,
            autocomplete: "new-password",
            placeholder: "New password",
            data: {
              controller: "password-strength password-toggle",
              password_strength_target: "input",
              password_toggle_target: "input"
            } %>
        
        <button type="button" 
                class="absolute right-2 top-1/2 -translate-y-1/2"
                data-action="password-toggle#toggle"
                data-password-toggle-target="button">
          Show
        </button>
      </div>
      
      <div data-password-strength-target="feedback" class="mt-2 text-sm space-y-1"></div>
    <% end %>
    
    <%= f.field :password_confirmation do %>
      <%= f.password_field :password_confirmation,
          required: true,
          autocomplete: "new-password",
          placeholder: "Confirm new password",
          data: {
            controller: "password-confirmation",
            password_confirmation_target: "confirmation",
            action: "input->password-confirmation#validate"
          } %>
      <div data-password-confirmation-target="status" class="mt-1 text-sm"></div>
    <% end %>
  <% end %>
<% end %>
```

#### Password Reset Form
```erb
<%= form_with model: @user, url: reset_password_path, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.hidden_field :reset_token %>
  
  <%= f.field_set do %>
    <h2>Reset Your Password</h2>
    <p class="text-gray-600 mb-4">Choose a new password for your account</p>
    
    <%= f.field :password, hint: "Choose a strong password with at least 8 characters" do %>
      <div class="space-y-4">
        <div class="relative">
          <%= f.password_field :password,
              required: true,
              minlength: 8,
              autocomplete: "new-password",
              data: {
                controller: "password-strength password-toggle",
                password_strength_target: "input",
                password_toggle_target: "input"
              } %>
          
          <button type="button" 
                  class="absolute right-2 top-1/2 -translate-y-1/2"
                  data-action="password-toggle#toggle"
                  data-password-toggle-target="button">
            Show
          </button>
        </div>
        
        <div data-password-strength-target="requirements" class="text-sm space-y-1">
          <div class="font-medium text-gray-700">Password must contain:</div>
          <div data-password-strength-target="requirement" data-type="length" class="text-gray-500">
            ✗ At least 8 characters
          </div>
          <div data-password-strength-target="requirement" data-type="lowercase" class="text-gray-500">
            ✗ One lowercase letter
          </div>
          <div data-password-strength-target="requirement" data-type="uppercase" class="text-gray-500">
            ✗ One uppercase letter
          </div>
          <div data-password-strength-target="requirement" data-type="number" class="text-gray-500">
            ✗ One number
          </div>
          <div data-password-strength-target="requirement" data-type="special" class="text-gray-500">
            ✗ One special character
          </div>
        </div>
      </div>
    <% end %>
    
    <%= f.field :password_confirmation do %>
      <%= f.password_field :password_confirmation,
          required: true,
          autocomplete: "new-password",
          data: {
            controller: "password-confirmation",
            password_confirmation_target: "confirmation",
            action: "input->password-confirmation#validate"
          } %>
    <% end %>
  <% end %>
<% end %>
```

#### Admin User Creation
```erb
<%= form_with model: @admin_user, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <h3>Create Admin User</h3>
    
    <%= f.field :email do %>
      <%= f.email_field :email, required: true %>
    <% end %>
    
    <%= f.field :temporary_password, hint: "Temporary password - user will be required to change on first login" do %>
      <div class="space-y-3">
        <%= f.password_field :password,
            required: true,
            minlength: 12,
            autocomplete: "new-password",
            data: {
              controller: "password-generator",
              password_generator_target: "input"
            } %>
        
        <div class="flex space-x-2">
          <button type="button" 
                  class="px-3 py-1 text-sm bg-blue-100 text-blue-700 rounded"
                  data-action="password-generator#generate">
            Generate Secure Password
          </button>
          
          <button type="button" 
                  class="px-3 py-1 text-sm bg-gray-100 text-gray-700 rounded"
                  data-action="password-generator#copy">
            Copy to Clipboard
          </button>
        </div>
      </div>
    <% end %>
    
    <%= f.field :force_password_change do %>
      <%= f.check_box_with_label :force_password_change, 
          label: "Require password change on first login",
          checked: true %>
    <% end %>
  <% end %>
<% end %>
```

#### Two-Factor Authentication Setup
```erb
<%= form_with model: @user, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <h3>Enable Two-Factor Authentication</h3>
    <p class="text-gray-600 mb-4">Confirm your password to enable 2FA</p>
    
    <%= f.field :current_password do %>
      <%= f.password_field :current_password,
          required: true,
          autocomplete: "current-password",
          placeholder: "Enter your current password" %>
    <% end %>
    
    <%= f.field :backup_password, hint: "Optional: Set a backup password for 2FA recovery" do %>
      <%= f.password_field :backup_password,
          minlength: 8,
          autocomplete: "new-password",
          placeholder: "Backup password (optional)" %>
    <% end %>
  <% end %>
<% end %>
```