# Forms Component Guide

The Forms component namespace provides a comprehensive set of form-related components in OkonomiUiKit, designed to work seamlessly with Rails' form helpers while adding consistent styling and enhanced functionality.

## Basic Usage

Forms components are accessed through the OkonomiUiKit FormBuilder:

#### Simple Form
```erb
<%= form_with model: @user, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <%= f.field :email do %>
      <%= f.email_field :email %>
    <% end %>
    
    <%= f.field :password do %>
      <%= f.password_field :password %>
    <% end %>
  <% end %>
<% end %>
```

#### Form with Multiple Field Sets
```erb
<%= form_with model: @product, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <h3>Basic Information</h3>
    <%= f.field :name do %>
      <%= f.text_field :name %>
    <% end %>
    
    <%= f.field :description do %>
      <%= f.text_area :description %>
    <% end %>
  <% end %>
  
  <%= f.field_set do %>
    <h3>Pricing</h3>
    <%= f.field :price do %>
      <%= f.number_field :price %>
    <% end %>
  <% end %>
<% end %>
```

## Available Form Components

The Forms namespace includes these components:

| Component | Purpose | Usage |
|-----------|---------|-------|
| field_set | Groups related form fields | `f.field_set { ... }` |
| field | Wraps individual form inputs with labels and errors | `f.field :attribute { ... }` |
| text_field | Single-line text input | `f.text_field :name` |
| email_field | Email input with validation | `f.email_field :email` |
| password_field | Password input with masking | `f.password_field :password` |
| text_area | Multi-line text input | `f.text_area :description` |
| number_field | Numeric input | `f.number_field :quantity` |
| select | Dropdown selection | `f.select :category, options` |
| collection_select | Select from ActiveRecord collection | `f.collection_select :user_id, @users, :id, :name` |
| multi_select | Multiple selection dropdown | `f.multi_select :tags, options` |
| check_box_with_label | Checkbox with integrated label | `f.check_box_with_label :active` |
| date_field | Date picker | `f.date_field :start_date` |
| datetime_local_field | Date and time picker | `f.datetime_local_field :published_at` |
| time_field | Time picker | `f.time_field :opens_at` |
| search_field | Search input | `f.search_field :query` |
| telephone_field | Phone number input | `f.telephone_field :phone` |
| url_field | URL input | `f.url_field :website` |
| upload_field | File upload with preview | `f.upload_field :avatar` |
| show_if | Conditional field visibility | `f.show_if :has_discount { ... }` |
| label | Standalone label | `f.label :name` |

## Advanced Features

#### Nested Fields with Custom Layout
```erb
<%= f.field_set class: "grid grid-cols-2 gap-4" do %>
  <%= f.field :first_name, class: "col-span-1" do %>
    <%= f.text_field :first_name %>
  <% end %>
  
  <%= f.field :last_name, class: "col-span-1" do %>
    <%= f.text_field :last_name %>
  <% end %>
<% end %>
```

#### Conditional Field Visibility
```erb
<%= f.field :subscription_type do %>
  <%= f.select :subscription_type, ["free", "premium", "enterprise"] %>
<% end %>

<%= f.show_if :subscription_type, "premium" do %>
  <%= f.field :billing_address do %>
    <%= f.text_field :billing_address %>
  <% end %>
<% end %>
```

#### File Upload with Preview
```erb
<%= f.field :profile_image do %>
  <%= f.upload_field :profile_image, 
      accept: "image/*",
      preview: true,
      direct_upload: true %>
<% end %>
```

#### Multi-Select with Search
```erb
<%= f.field :tags do %>
  <%= f.multi_select :tag_ids, 
      Tag.all.pluck(:name, :id),
      placeholder: "Select tags...",
      searchable: true %>
<% end %>
```

## Styling

#### Default Form Styling

Forms components include these default styles:
- **field_set**: `w-full flex flex-col gap-4`
- **field**: Includes label styling and error message formatting
- **inputs**: Consistent border, padding, and focus states

#### Customizing Form Styles

Override default styles by creating custom configurations:

```ruby
# In your initializer
module OkonomiUiKit
  module Components
    module Forms
      class TextField < InputBase
        register_styles :custom do
          {
            root: "block w-full rounded-lg border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
          }
        end
      end
    end
  end
end
```

Or use runtime theming:

```erb
<% ui.theme(components: { forms: { text_field: { root: "custom-input-class" } } }) do %>
  <%= form_with model: @user, builder: OkonomiUiKit::FormBuilder do |f| %>
    <%= f.text_field :name %>
  <% end %>
<% end %>
```

## Best Practices

1. **Always Use FormBuilder**: Specify `builder: OkonomiUiKit::FormBuilder` for consistent styling
2. **Group Related Fields**: Use `field_set` to organize form sections logically
3. **Provide Field Context**: Always wrap inputs in `field` blocks for proper labels and error handling
4. **Progressive Enhancement**: Use `show_if` for dynamic forms without page reloads
5. **Accessible Labels**: Let the framework generate labels automatically from field names
6. **Validation Feedback**: Error messages are automatically displayed below fields

## Accessibility

Forms components ensure accessibility through:
- Semantic HTML5 form elements
- Automatic label association with inputs
- ARIA attributes for error states
- Keyboard navigation support
- Screen reader-friendly error messages
- Proper focus management

## Examples

#### User Registration Form
```erb
<%= form_with model: @user, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <h2>Create Your Account</h2>
    
    <%= f.field :email do %>
      <%= f.email_field :email, placeholder: "you@example.com" %>
    <% end %>
    
    <%= f.field :password do %>
      <%= f.password_field :password, 
          placeholder: "Minimum 8 characters" %>
    <% end %>
    
    <%= f.field :password_confirmation do %>
      <%= f.password_field :password_confirmation %>
    <% end %>
    
    <%= f.field do %>
      <%= f.check_box_with_label :terms_accepted, 
          "I agree to the Terms of Service" %>
    <% end %>
    
    <%= ui.button_tag "Create Account", 
        type: :submit,
        variant: :contained,
        color: :primary,
        class: "w-full" %>
  <% end %>
<% end %>
```

#### Product Form with Images
```erb
<%= form_with model: @product, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <h3>Product Details</h3>
    
    <%= f.field :name do %>
      <%= f.text_field :name %>
    <% end %>
    
    <%= f.field :category do %>
      <%= f.collection_select :category_id, 
          Category.all, :id, :name,
          prompt: "Select a category" %>
    <% end %>
    
    <%= f.field :description do %>
      <%= f.text_area :description, rows: 5 %>
    <% end %>
  <% end %>
  
  <%= f.field_set do %>
    <h3>Images</h3>
    
    <%= f.field :images do %>
      <%= f.upload_field :images, 
          multiple: true,
          accept: "image/*",
          preview: true %>
    <% end %>
  <% end %>
  
  <div class="flex gap-2 mt-6">
    <%= ui.button_tag "Save Product", 
        type: :submit,
        variant: :contained,
        color: :primary %>
    <%= ui.link_to "Cancel", products_path, 
        variant: :outlined %>
  </div>
<% end %>
```

#### Settings Form with Conditional Fields
```erb
<%= form_with model: @settings, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <h3>Notification Preferences</h3>
    
    <%= f.field do %>
      <%= f.check_box_with_label :email_notifications,
          "Receive email notifications" %>
    <% end %>
    
    <%= f.show_if :email_notifications, true do %>
      <%= f.field :email_frequency do %>
        <%= f.select :email_frequency, 
            ["immediately", "daily", "weekly"] %>
      <% end %>
    <% end %>
    
    <%= f.field do %>
      <%= f.check_box_with_label :sms_notifications,
          "Receive SMS notifications" %>
    <% end %>
    
    <%= f.show_if :sms_notifications, true do %>
      <%= f.field :phone_number do %>
        <%= f.telephone_field :phone_number %>
      <% end %>
    <% end %>
  <% end %>
<% end %>
```