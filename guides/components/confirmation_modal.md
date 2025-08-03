# Confirmation Modal Component

The `confirmation_modal` component provides accessible, customizable dialogs for critical user actions. It includes proper ARIA attributes, keyboard navigation, and full theme integration through the OkonomiUiKit component system.

## Basic Usage

```erb
<%= ui.confirmation_modal(
  title: "Delete Item",
  message: "Are you sure you want to delete this item?"
) %>
```

## Options

### Required Options

- `title` (String) - The modal title displayed prominently
- `message` (String) - The message or question to display to the user

### Optional Options

- `confirm_text` (String) - Text for the primary action button (default: "Confirm")
- `cancel_text` (String) - Text for the cancel button (default: "Cancel")
- `variant` (Symbol) - Visual variant: `:warning` (default), `:info`, or `:success`
- `size` (Symbol) - Modal size: `:sm`, `:md` (default), `:lg`, or `:xl`
- `auto_open` (Boolean) - Whether to open the modal automatically on render (default: false)
- `data` (Hash) - Custom data attributes to add to the modal container

## Variants

### Warning (Default)
Used for destructive actions like deletions:

```erb
<%= ui.confirmation_modal(
  title: "Delete Account",
  message: "This action cannot be undone.",
  variant: :warning
) %>
```

### Info
Used for informational confirmations:

```erb
<%= ui.confirmation_modal(
  title: "Send Notification",
  message: "This will notify all users.",
  variant: :info
) %>
```

### Success
Used for positive confirmations:

```erb
<%= ui.confirmation_modal(
  title: "Complete Setup",
  message: "Ready to activate your account?",
  variant: :success
) %>
```

## Sizes

Control the modal width with the size option:

```erb
# Small modal
<%= ui.confirmation_modal(title: "Confirm", message: "Are you sure?", size: :sm) %>

# Large modal for more content
<%= ui.confirmation_modal(title: "Terms", message: "Please review...", size: :lg) %>
```

## Custom Actions

Replace the default buttons with custom content using a block:

```erb
<%= ui.confirmation_modal(
  title: "Transfer Ownership",
  message: "Enter the new owner's email:"
) do %>
  <form class="mt-4">
    <input type="email" name="email" class="...">
    <div class="mt-4 flex gap-3 justify-end">
      <%= ui.button_to "Cancel", "#", 
          data: { action: "click->modal#close" } %>
      <%= ui.button_to "Transfer", "#", 
          data: { action: "click->modal#confirm" } %>
    </div>
  </form>
<% end %>
```

## Stimulus Integration

The modal component includes a Stimulus controller that handles:

- Opening and closing animations
- ESC key to close
- Click outside to close
- Focus management
- Body scroll locking

### Available Actions

- `modal#open` - Opens the modal
- `modal#close` - Closes the modal
- `modal#confirm` - Triggers confirm action and closes modal
- `modal#cancel` - Triggers cancel action and closes modal

### Events

The modal dispatches custom events:

- `modal:confirm` - When the confirm action is triggered
- `modal:cancel` - When the cancel action is triggered

Example of listening to events:

```javascript
document.addEventListener('modal:confirm', (event) => {
  console.log('Modal confirmed', event.detail);
});
```

## Programmatic Usage

### Auto-open on Page Load

```erb
<%= ui.confirmation_modal(
  title: "Welcome",
  message: "Thanks for signing up!",
  auto_open: true
) %>
```

### With Turbo Streams

```erb
<%= turbo_stream.append "modals" do %>
  <%= ui.confirmation_modal(
    title: "Action Complete",
    message: "Your changes have been saved.",
    auto_open: true
  ) %>
<% end %>
```

### Triggering from JavaScript

```javascript
// Find the modal element
const modal = document.querySelector('[data-controller="modal"]');

// Get the Stimulus controller instance
const controller = modal._stimulusController;

// Open the modal
controller.open();
```

## Form Integration

Use with Rails forms for confirmation before submission:

```erb
<%= ui.confirmation_modal(
  title: "Delete User",
  message: "This will permanently delete the user.",
  variant: :warning
) do %>
  <%= form_with url: user_path(@user), method: :delete do |f| %>
    <div class="flex gap-3 justify-end">
      <%= ui.button_to "Cancel", "#", 
          type: :button,
          data: { action: "click->modal#close" } %>
      <%= f.submit "Delete User", 
          class: ui.button_class(variant: :contained, color: :danger) %>
    </div>
  <% end %>
<% end %>
```

## Accessibility

The component includes comprehensive accessibility features:

- Proper ARIA attributes (`role="dialog"`, `aria-modal="true"`)
- Focus management (focus trap and restore)
- Keyboard navigation (ESC to close)
- Screen reader announcements
- Semantic HTML structure

## Styling Customization

The component uses the OkonomiUiKit style registration system. You can customize the appearance by overriding the default theme:

```ruby
# In an initializer
Rails.application.config.after_initialize do
  OkonomiUiKit::Components::ConfirmationModal.register_styles :custom do
    {
      backdrop: "fixed inset-0 bg-black/50",
      panel: {
        base: "rounded-xl shadow-2xl",
        sizes: {
          md: "max-w-md"
        }
      }
    }
  end
end
```

## Complete Example

Here's a full example showing a delete confirmation with custom styling:

```erb
<%= link_to "Delete", "#", 
    id: "delete-trigger",
    class: "text-red-600 hover:text-red-700" %>

<%= ui.confirmation_modal(
  title: "Delete Project",
  message: "Are you sure you want to delete '#{@project.name}'? This action cannot be undone.",
  confirm_text: "Yes, Delete Project",
  cancel_text: "No, Keep It",
  variant: :warning,
  size: :lg,
  data: { 
    project_id: @project.id,
    turbo_confirm: "Are you absolutely sure?"
  }
) do %>
  <%= form_with url: project_path(@project), method: :delete,
                data: { turbo: false } do |f| %>
    <div class="mt-4 text-sm text-gray-500">
      <p>This will also delete:</p>
      <ul class="mt-2 list-disc list-inside">
        <li><%= @project.tasks.count %> tasks</li>
        <li><%= @project.files.count %> files</li>
        <li><%= @project.comments.count %> comments</li>
      </ul>
    </div>
    
    <div class="mt-6 flex gap-3 justify-end">
      <%= ui.button_to "Cancel", "#", 
          type: :button,
          variant: :outlined,
          data: { action: "click->modal#close" } %>
      <%= f.submit "Delete Everything", 
          class: ui.button_class(variant: :contained, color: :danger),
          data: { disable_with: "Deleting..." } %>
    </div>
  <% end %>
<% end %>

<script>
document.getElementById('delete-trigger').addEventListener('click', (e) => {
  e.preventDefault();
  const modal = document.querySelector('[data-project-id="<%= @project.id %>"]');
  const controller = modal._stimulusController;
  controller.open();
});
</script>
```