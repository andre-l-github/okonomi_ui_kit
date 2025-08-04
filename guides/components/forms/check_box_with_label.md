# CheckBoxWithLabel Component Guide

The CheckBoxWithLabel component provides a styled checkbox input with an integrated label, making it easy to create accessible checkbox controls with consistent styling.

## Basic Usage

#### Simple Checkbox
```erb
<%= form_with model: @user, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.check_box_with_label :terms_accepted %>
<% end %>
```

#### Checkbox with Custom Label
```erb
<%= f.check_box_with_label :terms_accepted, 
    label: "I agree to the Terms of Service" %>
```

#### Checkbox with Hint Text
```erb
<%= f.check_box_with_label :newsletter_subscription, 
    hint: "We'll send you weekly updates about new features" %>
```

## Customization Options

| Option | Type | Purpose |
|--------|------|---------|
| label | String | Custom label text (defaults to humanized method name) |
| hint | String/Boolean | Additional hint text below the label |
| checked_value | Any | Value when checkbox is checked (default: true) |
| unchecked_value | Any | Value when checkbox is unchecked (default: false) |
| id | String | Custom HTML id attribute |
| class | String | Additional CSS classes for the checkbox input |
| disabled | Boolean | Disable the checkbox |
| required | Boolean | Mark as required field |

## Advanced Features

#### Custom Checked/Unchecked Values
```erb
<%= f.check_box_with_label :status, 
    label: "Active",
    checked_value: "active", 
    unchecked_value: "inactive" %>
```

#### Multiple Checkboxes in a Group
```erb
<div class="space-y-2">
  <h3 class="text-sm font-medium">Notification Preferences</h3>
  <%= f.check_box_with_label :email_notifications,
      label: "Email notifications",
      hint: "Receive updates via email" %>
  
  <%= f.check_box_with_label :sms_notifications,
      label: "SMS notifications",
      hint: "Receive updates via text message" %>
  
  <%= f.check_box_with_label :push_notifications,
      label: "Push notifications",
      hint: "Receive in-app notifications" %>
</div>
```

#### Conditional Display
```erb
<%= f.check_box_with_label :has_discount,
    label: "Apply discount" %>

<%= f.show_if :has_discount, true do %>
  <%= f.field :discount_percentage do %>
    <%= f.number_field :discount_percentage %>
  <% end %>
<% end %>
```

## Styling

#### Default Styles

The component applies these default Tailwind classes:
- Wrapper: `flex gap-x-3`
- Checkbox: `size-4 rounded border-gray-300 text-primary-600 focus:ring-primary-600`
- Label: `text-sm/6 font-medium text-gray-900`
- Hint: `text-gray-500`

#### Customizing Styles

Override the default styles in your configuration:

```ruby
# In your initializer
module OkonomiUiKit
  module Components
    module Forms
      class CheckBoxWithLabel
        register_styles :custom do
          {
            wrapper: "flex items-start gap-x-4",
            input: {
              root: "size-5 rounded-md border-2 border-gray-400 text-brand-600 focus:ring-brand-500"
            },
            label: {
              root: "text-base font-semibold text-gray-800"
            },
            hint: {
              root: "text-sm text-gray-600 mt-1"
            }
          }
        end
      end
    end
  end
end
```

Or use runtime theme switching:

```erb
<% ui.theme(components: { forms: { check_box_with_label: { 
  input: { root: "size-6 rounded-lg" } 
} } }) do %>
  <%= f.check_box_with_label :featured %>
<% end %>
```

## Best Practices

1. **Clear Labels**: Use descriptive labels that clearly indicate what the checkbox controls
2. **Hint Text**: Add hints for checkboxes that might need additional context
3. **Group Related Options**: Use visual grouping for related checkboxes
4. **Default States**: Consider carefully whether checkboxes should be checked by default
5. **Required Fields**: Avoid required checkboxes unless absolutely necessary (e.g., terms acceptance)

## Accessibility

The CheckBoxWithLabel component ensures accessibility by:
- Properly associating labels with checkbox inputs
- Supporting keyboard navigation (Space to toggle)
- Including focus states for keyboard users
- Maintaining proper color contrast
- Supporting screen reader announcements
- Using semantic HTML structure

## Examples

#### Terms and Conditions
```erb
<%= form_with model: @user, builder: OkonomiUiKit::FormBuilder do |f| %>
  <div class="border-t pt-4">
    <%= f.check_box_with_label :terms_accepted,
        label: "I agree to the Terms of Service and Privacy Policy",
        hint: "You must accept the terms to continue" %>
  </div>
  
  <%= ui.button_tag "Create Account", 
      type: :submit,
      variant: :contained,
      color: :primary,
      disabled: !@user.terms_accepted %>
<% end %>
```

#### Feature Toggles
```erb
<%= form_with model: @settings, builder: OkonomiUiKit::FormBuilder do |f| %>
  <div class="space-y-4">
    <h3 class="font-medium">Feature Settings</h3>
    
    <%= f.check_box_with_label :enable_api,
        label: "Enable API Access",
        hint: "Allow third-party applications to access your data" %>
    
    <%= f.check_box_with_label :enable_webhooks,
        label: "Enable Webhooks",
        hint: "Send real-time notifications to external services" %>
    
    <%= f.check_box_with_label :enable_exports,
        label: "Enable Data Exports",
        hint: "Allow users to export their data" %>
  </div>
<% end %>
```

#### Subscription Preferences
```erb
<%= form_with model: @subscription, builder: OkonomiUiKit::FormBuilder do |f| %>
  <fieldset>
    <legend class="text-lg font-medium mb-4">Email Preferences</legend>
    
    <%= f.check_box_with_label :marketing_emails,
        label: "Marketing emails",
        hint: "New features, tips, and special offers" %>
    
    <%= f.check_box_with_label :product_updates,
        label: "Product updates",
        hint: "Important updates about changes to our service" %>
    
    <%= f.check_box_with_label :weekly_digest,
        label: "Weekly digest",
        hint: "A summary of your activity and recommendations" %>
  </fieldset>
<% end %>
```

#### Permissions Management
```erb
<%= form_with model: @role, builder: OkonomiUiKit::FormBuilder do |f| %>
  <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
    <div>
      <h4 class="font-medium mb-2">User Management</h4>
      <%= f.check_box_with_label :can_view_users, label: "View users" %>
      <%= f.check_box_with_label :can_edit_users, label: "Edit users" %>
      <%= f.check_box_with_label :can_delete_users, label: "Delete users" %>
    </div>
    
    <div>
      <h4 class="font-medium mb-2">Content Management</h4>
      <%= f.check_box_with_label :can_view_content, label: "View content" %>
      <%= f.check_box_with_label :can_edit_content, label: "Edit content" %>
      <%= f.check_box_with_label :can_publish_content, label: "Publish content" %>
    </div>
  </div>
<% end %>
```