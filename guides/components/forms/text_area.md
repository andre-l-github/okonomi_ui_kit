# TextArea Component Guide

The TextArea component provides a styled multi-line text input with automatic resizing, character counting, and enhanced editing features.

## Basic Usage

#### Simple Text Area
```erb
<%= form_with model: @post, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :content do %>
    <%= f.text_area :content %>
  <% end %>
<% end %>
```

#### With Custom Size
```erb
<%= f.text_area :description, rows: 5, cols: 50 %>
```

#### With Placeholder
```erb
<%= f.text_area :comments, 
    placeholder: "Enter your comments here...",
    rows: 4 %>
```

## Customization Options

| Option | Type | Purpose |
|--------|------|---------|
| rows | Integer | Number of visible text lines |
| cols | Integer | Visible width in characters |
| placeholder | String | Placeholder text when field is empty |
| required | Boolean | Mark field as required |
| disabled | Boolean | Disable the input |
| readonly | Boolean | Make field read-only |
| maxlength | Integer | Maximum number of characters |
| minlength | Integer | Minimum number of characters |
| wrap | String | Text wrapping behavior ("soft", "hard", "off") |
| autocomplete | String | Autocomplete behavior |
| class | String | Additional CSS classes |
| data | Hash | Data attributes for JavaScript |

## Advanced Features

#### Auto-Resizing Text Area
```erb
<%= f.text_area :content,
    rows: 3,
    data: {
      controller: "auto-resize",
      auto_resize_min_height: 80,
      auto_resize_max_height: 400
    } %>
```

#### Character Counter
```erb
<%= f.text_area :bio,
    maxlength: 500,
    rows: 4,
    data: {
      controller: "character-counter",
      character_counter_target: "input"
    } %>

<div class="flex justify-between text-sm text-gray-500 mt-1">
  <span>Tell us about yourself</span>
  <span data-character-counter-target="count">0/500</span>
</div>
```

#### Rich Text Features
```erb
<%= f.text_area :content,
    rows: 6,
    data: {
      controller: "rich-text-editor",
      rich_text_editor_toolbar: true,
      rich_text_editor_preview: true
    } %>

<div class="flex space-x-2 mt-2">
  <button type="button" data-action="rich-text-editor#bold">Bold</button>
  <button type="button" data-action="rich-text-editor#italic">Italic</button>
  <button type="button" data-action="rich-text-editor#preview">Preview</button>
</div>
```

#### Word Count and Writing Goals
```erb
<%= f.text_area :article_content,
    rows: 10,
    data: {
      controller: "writing-assistant",
      writing_assistant_target_words: 500,
      writing_assistant_show_stats: true
    } %>

<div data-writing-assistant-target="stats" class="text-sm text-gray-600 mt-2">
  <div class="flex justify-between">
    <span>Words: <span data-writing-assistant-target="wordCount">0</span></span>
    <span>Characters: <span data-writing-assistant-target="charCount">0</span></span>
    <span>Reading time: <span data-writing-assistant-target="readTime">0 min</span></span>
  </div>
</div>
```

#### Template Insertion
```erb
<%= f.text_area :message,
    rows: 6,
    data: {
      controller: "template-inserter",
      template_inserter_templates: [
        "Thank you for your inquiry...",
        "We appreciate your feedback...",
        "Your request has been received..."
      ].to_json
    } %>

<div class="mt-2">
  <select data-template-inserter-target="selector" 
          data-action="template-inserter#insertTemplate"
          class="text-sm border border-gray-300 rounded">
    <option value="">Insert template...</option>
    <option value="0">Thank you message</option>
    <option value="1">Feedback response</option>
    <option value="2">Request confirmation</option>
  </select>
</div>
```

## Styling

#### Default Styles

The TextArea inherits styles from InputBase:
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
      class TextArea
        register_styles :custom do
          {
            root: "w-full px-4 py-3 border-2 border-gray-200 rounded-lg resize-y",
            valid: "border-gray-200 focus:border-blue-500",
            error: "border-red-500 bg-red-50 text-red-900",
            disabled: "bg-gray-100 text-gray-500 cursor-not-allowed resize-none"
          }
        end
      end
    end
  end
end
```

Or use runtime theme switching:

```erb
<% ui.theme(components: { forms: { text_area: { 
  root: "rounded-xl min-h-32 resize-none" 
} } }) do %>
  <%= f.text_area :content %>
<% end %>
```

## Best Practices

1. **Appropriate Size**: Set reasonable initial rows and columns
2. **Character Limits**: Use maxlength with visual feedback
3. **Clear Placeholders**: Provide helpful placeholder text
4. **Accessibility**: Ensure proper label associations
5. **Auto-resize**: Consider auto-resizing for better UX
6. **Validation**: Provide clear error messages

## Accessibility

The TextArea component ensures accessibility by:
- Using semantic HTML textarea elements
- Supporting keyboard navigation (Tab, Enter, Ctrl+A)
- Providing clear label associations
- Including proper ARIA attributes for error states
- Working with screen readers
- Supporting text selection and editing shortcuts
- Showing visual focus indicators
- Maintaining resize functionality where appropriate

## Examples

#### Blog Post Editor
```erb
<%= form_with model: @post, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :title do %>
    <%= f.text_field :title, required: true %>
  <% end %>
  
  <%= f.field :excerpt, hint: "Brief summary of the post (optional)" do %>
    <%= f.text_area :excerpt,
        rows: 2,
        maxlength: 160,
        placeholder: "Write a compelling excerpt...",
        data: {
          controller: "character-counter",
          character_counter_target: "input"
        } %>
    <div class="text-sm text-gray-500 mt-1 text-right">
      <span data-character-counter-target="count">0/160</span>
    </div>
  <% end %>
  
  <%= f.field :content do %>
    <%= f.text_area :content,
        rows: 15,
        placeholder: "Write your post content here...",
        required: true,
        data: {
          controller: "auto-resize writing-assistant",
          auto_resize_min_height: 300,
          writing_assistant_target_words: 800
        } %>
    
    <div data-writing-assistant-target="stats" class="text-sm text-gray-600 mt-2 flex justify-between">
      <span>Words: <span data-writing-assistant-target="wordCount">0</span></span>
      <span>Est. reading time: <span data-writing-assistant-target="readTime">0 min</span></span>
    </div>
  <% end %>
<% end %>
```

#### Contact Form
```erb
<%= form_with model: @contact_form, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <h2>Get in Touch</h2>
    
    <%= f.field :name do %>
      <%= f.text_field :name, required: true %>
    <% end %>
    
    <%= f.field :email do %>
      <%= f.email_field :email, required: true %>
    <% end %>
    
    <%= f.field :subject do %>
      <%= f.select :subject, [
        ['General Inquiry', 'general'],
        ['Support Request', 'support'],
        ['Sales Question', 'sales'],
        ['Partnership', 'partnership'],
        ['Other', 'other']
      ], { prompt: 'What is this regarding?' } %>
    <% end %>
    
    <%= f.field :message do %>
      <%= f.text_area :message,
          rows: 6,
          placeholder: "Please describe your inquiry in detail...",
          required: true,
          maxlength: 2000,
          data: {
            controller: "character-counter auto-resize",
            character_counter_target: "input",
            auto_resize_min_height: 120
          } %>
      <div class="flex justify-between text-sm text-gray-500 mt-1">
        <span>Please be as detailed as possible</span>
        <span data-character-counter-target="count">0/2000</span>
      </div>
    <% end %>
  <% end %>
<% end %>
```

#### Product Review Form
```erb
<%= form_with model: @review, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :rating do %>
    <%= f.select :rating, (1..5).map { |i| [i, i] }, 
        { prompt: 'Rate this product (1-5 stars)' } %>
  <% end %>
  
  <%= f.field :title, hint: "Give your review a helpful title" do %>
    <%= f.text_field :title,
        placeholder: "Summarize your experience",
        maxlength: 60 %>
  <% end %>
  
  <%= f.field :content do %>
    <%= f.text_area :content,
        rows: 5,
        placeholder: "Share your thoughts about this product...",
        minlength: 50,
        maxlength: 1000,
        data: {
          controller: "character-counter review-helper",
          character_counter_target: "input"
        } %>
    
    <div class="mt-2 space-y-2">
      <div class="flex justify-between text-sm text-gray-500">
        <span>Minimum 50 characters for a helpful review</span>
        <span data-character-counter-target="count">0/1000</span>
      </div>
      
      <div data-review-helper-target="suggestions" class="text-sm text-blue-600">
        <div class="font-medium">Consider mentioning:</div>
        <ul class="list-disc list-inside text-xs">
          <li>What you liked most about the product</li>
          <li>How you use the product</li>
          <li>Any issues or improvements</li>
          <li>Would you recommend it to others?</li>
        </ul>
      </div>
    </div>
  <% end %>
<% end %>
```

#### Support Ticket Form
```erb
<%= form_with model: @support_ticket, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :priority do %>
    <%= f.select :priority, [
      ['Low - General question', 'low'],
      ['Medium - Need help', 'medium'],
      ['High - Blocking my work', 'high'],
      ['Critical - System down', 'critical']
    ], { prompt: 'How urgent is this issue?' } %>
  <% end %>
  
  <%= f.field :category do %>
    <%= f.select :category, [
      ['Account Issues', 'account'],
      ['Technical Problems', 'technical'],
      ['Billing Questions', 'billing'],
      ['Feature Requests', 'feature'],
      ['Other', 'other']
    ], { prompt: 'What type of issue is this?' } %>
  <% end %>
  
  <%= f.field :description do %>
    <%= f.text_area :description,
        rows: 8,
        placeholder: "Please describe the issue in detail...",
        required: true,
        data: {
          controller: "support-assistant auto-resize",
          support_assistant_category_field: "#support_ticket_category"
        } %>
    
    <div data-support-assistant-target="template" class="mt-2 text-sm">
      <div class="font-medium text-gray-700">Please include:</div>
      <ul data-support-assistant-target="checklist" class="text-xs text-gray-600 list-disc list-inside">
        <li>What you were trying to do</li>
        <li>What actually happened</li>
        <li>Any error messages you saw</li>
        <li>Steps to reproduce the issue</li>
      </ul>
    </div>
  <% end %>
  
  <%= f.field :additional_info do %>
    <%= f.text_area :additional_info,
        rows: 3,
        placeholder: "Any additional context, screenshots, or information..." %>
  <% end %>
<% end %>
```

#### User Feedback Form
```erb
<%= form_with model: @feedback, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :feedback_type do %>
    <%= f.select :feedback_type, [
      ['Bug Report', 'bug'],
      ['Feature Request', 'feature'],
      ['General Feedback', 'general'],
      ['Complaint', 'complaint'],
      ['Compliment', 'compliment']
    ], { prompt: 'What type of feedback is this?' } %>
  <% end %>
  
  <%= f.field :description do %>
    <%= f.text_area :description,
        rows: 6,
        placeholder: "Tell us what's on your mind...",
        required: true,
        maxlength: 1500,
        data: {
          controller: "feedback-helper character-counter",
          feedback_helper_type_field: "#feedback_feedback_type",
          character_counter_target: "input"
        } %>
    
    <div class="mt-2">
      <div data-feedback-helper-target="prompts" class="text-sm text-blue-600 mb-2"></div>
      <div class="text-sm text-gray-500 text-right">
        <span data-character-counter-target="count">0/1500</span>
      </div>
    </div>
  <% end %>
  
  <%= f.field :follow_up do %>
    <%= f.check_box_with_label :follow_up, 
        label: "I would like someone to follow up on this feedback" %>
  <% end %>
<% end %>
```

#### Job Application Cover Letter
```erb
<%= form_with model: @application, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :position do %>
    <%= f.text_field :position, 
        value: @job_posting&.title,
        readonly: @job_posting.present? %>
  <% end %>
  
  <%= f.field :cover_letter do %>
    <%= f.text_area :cover_letter,
        rows: 12,
        placeholder: "Write a compelling cover letter...",
        required: true,
        minlength: 200,
        maxlength: 2000,
        data: {
          controller: "cover-letter-assistant writing-assistant",
          writing_assistant_target_words: 300,
          cover_letter_assistant_job_description: @job_posting&.description
        } %>
    
    <div class="mt-3 grid grid-cols-1 md:grid-cols-2 gap-4 text-sm">
      <div data-writing-assistant-target="stats" class="text-gray-600">
        <div>Words: <span data-writing-assistant-target="wordCount">0</span> / ~300</div>
        <div>Characters: <span data-writing-assistant-target="charCount">0</span> / 2000</div>
      </div>
      
      <div data-cover-letter-assistant-target="tips" class="text-blue-600">
        <div class="font-medium">Cover letter tips:</div>
        <ul class="text-xs list-disc list-inside">
          <li>Address the hiring manager by name if possible</li>
          <li>Mention specific qualifications from the job posting</li>
          <li>Show enthusiasm for the role and company</li>
          <li>Include a clear call to action</li>
        </ul>
      </div>
    </div>
  <% end %>
<% end %>
```

#### Event Description Form
```erb
<%= form_with model: @event, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :title do %>
    <%= f.text_field :title, required: true %>
  <% end %>
  
  <%= f.field :short_description, hint: "Brief description for event listings" do %>
    <%= f.text_area :short_description,
        rows: 2,
        maxlength: 200,
        placeholder: "One or two sentences describing your event...",
        data: {
          controller: "character-counter",
          character_counter_target: "input"
        } %>
    <div class="text-sm text-gray-500 mt-1 text-right">
      <span data-character-counter-target="count">0/200</span>
    </div>
  <% end %>
  
  <%= f.field :full_description do %>
    <%= f.text_area :full_description,
        rows: 8,
        placeholder: "Provide a detailed description of your event...",
        data: {
          controller: "auto-resize markdown-preview",
          auto_resize_min_height: 200
        } %>
    
    <div class="mt-2 flex space-x-2">
      <button type="button" 
              class="text-sm text-blue-600 hover:text-blue-800"
              data-action="markdown-preview#toggle"
              data-markdown-preview-target="toggleButton">
        Preview
      </button>
      <span class="text-sm text-gray-500">Markdown formatting supported</span>
    </div>
    
    <div data-markdown-preview-target="preview" 
         class="mt-2 p-4 border border-gray-300 rounded-lg bg-gray-50 hidden">
      <!-- Markdown preview will appear here -->
    </div>
  <% end %>
<% end %>
```