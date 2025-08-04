# TextField Component Guide

The TextField component provides a styled single-line text input with validation support, autocomplete features, and accessibility enhancements.

## Basic Usage

#### Simple Text Field
```erb
<%= form_with model: @user, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :name do %>
    <%= f.text_field :name %>
  <% end %>
<% end %>
```

#### With Placeholder
```erb
<%= f.text_field :name, placeholder: "Enter your full name" %>
```

#### With Validation
```erb
<%= f.text_field :username, 
    required: true, 
    minlength: 3,
    maxlength: 20 %>
```

## Customization Options

| Option | Type | Purpose |
|--------|------|---------|
| placeholder | String | Placeholder text when field is empty |
| required | Boolean | Mark field as required |
| disabled | Boolean | Disable the input |
| readonly | Boolean | Make field read-only |
| minlength | Integer | Minimum number of characters |
| maxlength | Integer | Maximum number of characters |
| pattern | String | Regular expression for validation |
| autocomplete | String | Autocomplete behavior ("name", "username", etc.) |
| class | String | Additional CSS classes |
| data | Hash | Data attributes for JavaScript |

## Advanced Features

#### Input Formatting
```erb
<%= f.text_field :phone_number,
    placeholder: "(555) 123-4567",
    data: {
      controller: "input-formatter",
      input_formatter_mask: "(999) 999-9999"
    } %>
```

#### Live Validation
```erb
<%= f.text_field :username,
    minlength: 3,
    maxlength: 20,
    data: {
      controller: "live-validator",
      live_validator_url: check_username_path,
      action: "input->live-validator#validate"
    } %>

<div data-live-validator-target="feedback" class="text-sm mt-1"></div>
```

#### Auto-completion
```erb
<%= f.text_field :city,
    placeholder: "Start typing city name...",
    autocomplete: "address-level2",
    data: {
      controller: "autocomplete",
      autocomplete_url: cities_path,
      autocomplete_min_length: 2
    } %>

<div data-autocomplete-target="suggestions" class="relative">
  <div class="absolute top-full left-0 right-0 bg-white border border-gray-300 rounded-md shadow-lg z-10 hidden">
    <div data-autocomplete-target="list"></div>
  </div>
</div>
```

#### Character Counter
```erb
<%= f.text_field :title,
    maxlength: 100,
    data: {
      controller: "character-counter",
      character_counter_target: "input"
    } %>

<div class="text-sm text-gray-500 mt-1 text-right">
  <span data-character-counter-target="count">0/100</span>
</div>
```

#### Input Suggestions
```erb
<%= f.text_field :tags,
    placeholder: "Add tags...",
    data: {
      controller: "tag-input",
      tag_input_suggestions: ["javascript", "ruby", "python", "react"].to_json
    } %>

<div data-tag-input-target="selected" class="mt-2 flex flex-wrap gap-2"></div>
```

## Styling

#### Default Styles

The TextField inherits styles from InputBase:
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
      class TextField
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
<% ui.theme(components: { forms: { text_field: { 
  root: "rounded-xl shadow-sm" 
} } }) do %>
  <%= f.text_field :name %>
<% end %>
```

## Best Practices

1. **Clear Labels**: Use descriptive field labels
2. **Helpful Placeholders**: Show format examples in placeholders
3. **Appropriate Validation**: Use client-side and server-side validation
4. **Autocomplete**: Enable autocomplete for better UX
5. **Character Limits**: Show character counts for limited fields
6. **Error Handling**: Provide clear, actionable error messages

## Accessibility

The TextField component ensures accessibility by:
- Using semantic HTML input elements
- Supporting keyboard navigation (Tab, Enter, arrow keys)
- Providing clear label associations
- Including proper ARIA attributes for error states
- Working with screen readers and assistive technologies
- Supporting autocomplete attributes for better UX
- Showing visual focus indicators
- Maintaining proper tab order

## Examples

#### User Registration Form
```erb
<%= form_with model: @user, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <h2>Create Your Account</h2>
    
    <%= f.field :username, hint: "3-20 characters, letters and numbers only" do %>
      <%= f.text_field :username,
          required: true,
          minlength: 3,
          maxlength: 20,
          pattern: "[a-zA-Z0-9]+",
          placeholder: "Choose a username",
          autocomplete: "username",
          data: {
            controller: "username-validator",
            username_validator_check_url: check_username_path,
            action: "blur->username-validator#checkAvailability"
          } %>
      <div data-username-validator-target="feedback" class="text-sm mt-1"></div>
    <% end %>
    
    <%= f.field :first_name do %>
      <%= f.text_field :first_name,
          required: true,
          placeholder: "First name",
          autocomplete: "given-name" %>
    <% end %>
    
    <%= f.field :last_name do %>
      <%= f.text_field :last_name,
          required: true,
          placeholder: "Last name",
          autocomplete: "family-name" %>
    <% end %>
    
    <%= f.field :display_name, hint: "How your name appears to other users" do %>
      <%= f.text_field :display_name,
          placeholder: "Display name (optional)",
          maxlength: 50,
          data: {
            controller: "character-counter",
            character_counter_target: "input"
          } %>
      <div class="text-sm text-gray-500 mt-1 text-right">
        <span data-character-counter-target="count">0/50</span>
      </div>
    <% end %>
  <% end %>
<% end %>
```

#### Contact Information Form
```erb
<%= form_with model: @contact, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <h3>Contact Details</h3>
    
    <%= f.field :company_name do %>
      <%= f.text_field :company_name,
          placeholder: "Company name (optional)",
          autocomplete: "organization" %>
    <% end %>
    
    <%= f.field :job_title do %>
      <%= f.text_field :job_title,
          placeholder: "Job title (optional)",
          autocomplete: "organization-title" %>
    <% end %>
    
    <%= f.field :website do %>
      <%= f.url_field :website,
          placeholder: "https://www.example.com",
          pattern: "https?://.+",
          data: {
            controller: "url-validator",
            action: "blur->url-validator#validate"
          } %>
    <% end %>
    
    <%= f.field :linkedin_profile do %>
      <%= f.text_field :linkedin_profile,
          placeholder: "LinkedIn profile URL (optional)",
          pattern: "https://.*linkedin.com/.*" %>
    <% end %>
  <% end %>
<% end %>
```

#### Product Information Form
```erb
<%= form_with model: @product, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :name do %>
    <%= f.text_field :name,
        required: true,
        placeholder: "Product name",
        maxlength: 100,
        data: {
          controller: "character-counter slug-generator",
          character_counter_target: "input",
          slug_generator_target: "source",
          slug_generator_output: "#product_slug"
        } %>
    <div class="text-sm text-gray-500 mt-1 text-right">
      <span data-character-counter-target="count">0/100</span>
    </div>
  <% end %>
  
  <%= f.field :slug, hint: "URL-friendly version of the name" do %>
    <%= f.text_field :slug,
        required: true,
        pattern: "[a-z0-9-]+",
        data: {
          slug_generator_target: "output"
        } %>
  <% end %>
  
  <%= f.field :sku, hint: "Stock Keeping Unit" do %>
    <%= f.text_field :sku,
        required: true,
        placeholder: "SKU-001",
        pattern: "[A-Z0-9-]+",
        maxlength: 20,
        data: {
          controller: "sku-validator",
          sku_validator_check_url: check_sku_path
        } %>
  <% end %>
  
  <%= f.field :tags, hint: "Comma-separated tags for categorization" do %>
    <%= f.text_field :tags,
        placeholder: "electronics, gadgets, wireless",
        data: {
          controller: "tag-input",
          tag_input_separator: ",",
          tag_input_suggestions: ProductTag.popular.pluck(:name).to_json
        } %>
    <div data-tag-input-target="preview" class="mt-2 flex flex-wrap gap-2"></div>
  <% end %>
<% end %>
```

#### Address Form
```erb
<%= form_with model: @address, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <h3>Shipping Address</h3>
    
    <%= f.field :street_address do %>
      <%= f.text_field :street_address,
          required: true,
          placeholder: "123 Main Street",
          autocomplete: "address-line1" %>
    <% end %>
    
    <%= f.field :address_line_2 do %>
      <%= f.text_field :address_line_2,
          placeholder: "Apartment, suite, etc. (optional)",
          autocomplete: "address-line2" %>
    <% end %>
    
    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
      <%= f.field :city, class: "md:col-span-1" do %>
        <%= f.text_field :city,
            required: true,
            placeholder: "City",
            autocomplete: "address-level2",
            data: {
              controller: "city-autocomplete",
              city_autocomplete_country: "#address_country",
              city_autocomplete_state: "#address_state"
            } %>
      <% end %>
      
      <%= f.field :state, class: "md:col-span-1" do %>
        <%= f.text_field :state,
            required: true,
            placeholder: "State",
            autocomplete: "address-level1",
            maxlength: 2,
            data: {
              controller: "state-formatter",
              action: "input->state-formatter#format"
            } %>
      <% end %>
      
      <%= f.field :postal_code, class: "md:col-span-1" do %>
        <%= f.text_field :postal_code,
            required: true,
            placeholder: "ZIP Code",
            autocomplete: "postal-code",
            pattern: "\\d{5}(-\\d{4})?",
            data: {
              controller: "postal-code-formatter",
              action: "input->postal-code-formatter#format"
            } %>
      <% end %>
    </div>
    
    <%= f.field :country do %>
      <%= f.select :country,
          options_from_collection_for_select(Country.all, :code, :name, "US"),
          {},
          { autocomplete: "country" } %>
    <% end %>
  <% end %>
<% end %>
```

#### Search and Filter Form
```erb
<%= form_with url: search_path, method: :get, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :query do %>
    <%= f.search_field :query,
        placeholder: "Search products...",
        value: params[:query],
        data: {
          controller: "search-suggestions",
          search_suggestions_url: suggestions_path,
          search_suggestions_min_length: 2
        } %>
    <div data-search-suggestions-target="dropdown" class="relative">
      <div class="absolute top-full left-0 right-0 bg-white border border-gray-300 rounded-md shadow-lg z-10 hidden">
        <div data-search-suggestions-target="list"></div>
      </div>
    </div>
  <% end %>
  
  <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
    <%= f.field :min_price, class: "md:col-span-1" do %>
      <%= f.text_field :min_price,
          placeholder: "Min price",
          pattern: "\\d+(\\.\\d{2})?",
          data: {
            controller: "price-formatter",
            action: "blur->price-formatter#format"
          } %>
    <% end %>
    
    <%= f.field :max_price, class: "md:col-span-1" do %>
      <%= f.text_field :max_price,
          placeholder: "Max price",
          pattern: "\\d+(\\.\\d{2})?",
          data: {
            controller: "price-formatter",
            action: "blur->price-formatter#format"
          } %>
    <% end %>
    
    <%= f.field :brand, class: "md:col-span-1" do %>
      <%= f.text_field :brand,
          placeholder: "Brand name",
          data: {
            controller: "brand-autocomplete",
            brand_autocomplete_url: brands_path
          } %>
    <% end %>
    
    <%= f.field :model, class: "md:col-span-1" do %>
      <%= f.text_field :model,
          placeholder: "Model number" %>
    <% end %>
  </div>
<% end %>
```

#### Settings Form
```erb
<%= form_with model: @user_settings, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <h3>Profile Settings</h3>
    
    <%= f.field :display_name do %>
      <%= f.text_field :display_name,
          maxlength: 50,
          placeholder: "How your name appears to others",
          data: {
            controller: "character-counter",
            character_counter_target: "input"
          } %>
      <div class="text-sm text-gray-500 mt-1 text-right">
        <span data-character-counter-target="count">0/50</span>
      </div>
    <% end %>
    
    <%= f.field :tagline do %>
      <%= f.text_field :tagline,
          maxlength: 100,
          placeholder: "A short tagline or bio",
          data: {
            controller: "character-counter",
            character_counter_target: "input"
          } %>
      <div class="text-sm text-gray-500 mt-1 text-right">
        <span data-character-counter-target="count">0/100</span>
      </div>
    <% end %>
    
    <%= f.field :location do %>
      <%= f.text_field :location,
          placeholder: "City, State",
          autocomplete: "address-level2",
          data: {
            controller: "location-autocomplete",
            location_autocomplete_url: locations_path
          } %>
    <% end %>
    
    <%= f.field :website do %>
      <%= f.url_field :website,
          placeholder: "https://www.yoursite.com",
          pattern: "https?://.+" %>
    <% end %>
  <% end %>
  
  <%= f.field_set do %>
    <h3>Notification Settings</h3>
    
    <%= f.field :notification_keywords, hint: "Get notified when these keywords are mentioned" do %>
      <%= f.text_field :notification_keywords,
          placeholder: "keyword1, keyword2, keyword3",
          data: {
            controller: "keyword-input",
            keyword_input_separator: ",",
            keyword_input_max_keywords: 10
          } %>
      <div data-keyword-input-target="preview" class="mt-2 flex flex-wrap gap-2"></div>
    <% end %>
  <% end %>
<% end %>
```

#### Advanced Form with Validation
```erb
<%= form_with model: @user, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :username, hint: "3-20 characters, letters, numbers, and underscores only" do %>
    <%= f.text_field :username,
        required: true,
        minlength: 3,
        maxlength: 20,
        pattern: "[a-zA-Z0-9_]+",
        placeholder: "username",
        autocomplete: "username",
        data: {
          controller: "advanced-validator character-counter",
          advanced_validator_rules: {
            minLength: 3,
            maxLength: 20,
            pattern: "^[a-zA-Z0-9_]+$",
            checkAvailability: check_username_path
          }.to_json,
          character_counter_target: "input",
          action: "input->advanced-validator#validate blur->advanced-validator#checkAvailability"
        } %>
    
    <div class="mt-2 space-y-1">
      <div class="flex justify-between text-sm">
        <div data-advanced-validator-target="feedback"></div>
        <span data-character-counter-target="count" class="text-gray-500">0/20</span>
      </div>
      
      <div data-advanced-validator-target="requirements" class="text-xs space-y-1">
        <div data-requirement="minLength" class="text-gray-500">✗ At least 3 characters</div>
        <div data-requirement="maxLength" class="text-gray-500">✗ No more than 20 characters</div>
        <div data-requirement="pattern" class="text-gray-500">✗ Letters, numbers, and underscores only</div>
        <div data-requirement="availability" class="text-gray-500">✗ Username available</div>
      </div>
    </div>
  <% end %>
<% end %>
```