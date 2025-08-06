# Progress Bar Component

The Progress Bar component provides a visual representation of progress completion, commonly used for file uploads, form submissions, loading states, or any process that has measurable progress.

## Basic Usage

The simplest way to use the progress bar is to pass a value between 0 and 1:

```erb
<%= ui.progress_bar(0.5) %>
```

This creates a progress bar that is 50% complete.

## Options

### Value (Required)

The `value` parameter is required and should be a number between 0 and 1:
- `0` represents 0% complete (empty progress bar)
- `1` represents 100% complete (full progress bar)
- Values outside this range are automatically clamped

```erb
<%= ui.progress_bar(0) %>      <!-- Empty (0%) -->
<%= ui.progress_bar(0.25) %>   <!-- 25% complete -->
<%= ui.progress_bar(0.75) %>   <!-- 75% complete -->
<%= ui.progress_bar(1) %>      <!-- Full (100%) -->
```

### Color Options

The progress bar supports multiple color variants via the `color:` option:

```erb
<%= ui.progress_bar(0.5, color: :primary) %>   <!-- Blue (default) -->
<%= ui.progress_bar(0.5, color: :secondary) %> <!-- Secondary theme color -->
<%= ui.progress_bar(0.5, color: :success) %>   <!-- Green -->
<%= ui.progress_bar(0.5, color: :danger) %>    <!-- Red -->
<%= ui.progress_bar(0.5, color: :warning) %>   <!-- Yellow -->
<%= ui.progress_bar(0.5, color: :info) %>      <!-- Light blue -->
<%= ui.progress_bar(0.5, color: :default) %>   <!-- Gray -->
```

### Size Options

Three sizes are available via the `size:` option:

```erb
<%= ui.progress_bar(0.5, size: :sm) %>  <!-- Small (2px height) -->
<%= ui.progress_bar(0.5, size: :md) %>  <!-- Medium (4px height, default) -->
<%= ui.progress_bar(0.5, size: :lg) %>  <!-- Large (6px height) -->
```

### Text Labels

You can add centered text to the progress bar using the `text:` option:

```erb
<%= ui.progress_bar(0.75, text: "75%") %>
<%= ui.progress_bar(0.33, text: "Processing...") %>
<%= ui.progress_bar(0.9, text: "Almost done!") %>
```

The text uses `mix-blend-difference` to ensure visibility against any background color.

### HTML Attributes

The progress bar accepts standard HTML attributes:

```erb
<%= ui.progress_bar(0.5, 
  id: "upload-progress",
  class: "my-custom-class",
  data: { 
    controller: "progress",
    target: "progressBar"
  }
) %>
```

## Features

### Automatic Animation

Progress bars automatically pulse when not at 100% completion, providing visual feedback that a process is ongoing. The animation stops when the progress reaches 100%.

### Accessibility

The component includes proper ARIA attributes for screen reader support:
- `role="progressbar"`
- `aria-valuenow` (current percentage)
- `aria-valuemin="0"`
- `aria-valuemax="100"`

### Value Handling

The component automatically handles edge cases:
- Negative values are clamped to 0
- Values greater than 1 are clamped to 1
- Decimal values are converted to percentages and rounded

## Real-World Examples

### File Upload Progress

```erb
<div class="space-y-2">
  <div class="flex justify-between text-sm">
    <span>Uploading document.pdf</span>
    <span>42%</span>
  </div>
  <%= ui.progress_bar(0.42, text: "42%", color: :info) %>
</div>
```

### Multi-Step Form Progress

```erb
<div class="mb-8">
  <h3 class="text-sm font-medium mb-2">Step 3 of 5: Payment Information</h3>
  <%= ui.progress_bar(0.6, color: :primary, size: :lg) %>
</div>
```

### Task Completion Tracker

```erb
<div class="bg-white p-4 rounded-lg shadow">
  <h4 class="font-medium mb-2">Daily Tasks</h4>
  <p class="text-sm text-gray-600 mb-3">7 of 10 tasks completed</p>
  <%= ui.progress_bar(0.7, text: "70%", color: :success) %>
</div>
```

### System Resource Monitor

```erb
<div class="space-y-3">
  <div>
    <div class="flex justify-between text-sm mb-1">
      <span>CPU Usage</span>
      <span>45%</span>
    </div>
    <%= ui.progress_bar(0.45, color: :info, size: :sm) %>
  </div>
  
  <div>
    <div class="flex justify-between text-sm mb-1">
      <span>Memory</span>
      <span>82%</span>
    </div>
    <%= ui.progress_bar(0.82, color: :warning, size: :sm) %>
  </div>
  
  <div>
    <div class="flex justify-between text-sm mb-1">
      <span>Disk Space</span>
      <span>94%</span>
    </div>
    <%= ui.progress_bar(0.94, color: :danger, size: :sm) %>
  </div>
</div>
```

### Loading State

```erb
<div class="text-center py-8">
  <h3 class="text-lg font-medium mb-4">Processing your request...</h3>
  <%= ui.progress_bar(0.65, text: "65%", color: :primary, class: "max-w-md mx-auto") %>
  <p class="text-sm text-gray-600 mt-2">This may take a few moments</p>
</div>
```

## JavaScript Integration

You can easily update progress bars dynamically with Stimulus or other JavaScript:

```erb
<div data-controller="upload">
  <%= ui.progress_bar(0, 
    id: "upload-progress",
    data: { 
      upload_target: "progressBar" 
    }
  ) %>
</div>
```

```javascript
// Stimulus controller example
export default class extends Controller {
  static targets = ["progressBar"]
  
  updateProgress(value) {
    const percentage = Math.round(value * 100)
    const bar = this.progressBarTarget.querySelector('[role="progressbar"] > div')
    
    bar.style.width = `${percentage}%`
    this.progressBarTarget.setAttribute('aria-valuenow', percentage)
    
    // Remove pulse animation at 100%
    if (percentage >= 100) {
      bar.classList.remove('animate-pulse')
    }
  }
}
```

## Styling and Customization

### Custom Classes

You can add custom classes to further style the progress bar:

```erb
<%= ui.progress_bar(0.5, 
  class: "shadow-inner", 
  color: :primary
) %>
```

### Styling Overrides

To customize the component's default styles, create a config class:

```ruby
# app/helpers/okonomi_ui_kit/configs/progress_bar.rb
module OkonomiUiKit
  module Configs
    class ProgressBar < OkonomiUiKit::Config
      register_styles :default do
        {
          container: {
            root: "w-full bg-gray-300 rounded-lg overflow-hidden relative",
            sizes: {
              sm: "h-1",
              md: "h-3",
              lg: "h-5"
            }
          },
          bar: {
            root: "h-full transition-all duration-500 ease-in-out",
            colors: {
              primary: "bg-blue-500",
              success: "bg-green-500"
              # ... other color overrides
            }
          }
        }
      end
    end
  end
end
```

## Best Practices

1. **Provide Context**: Always give users context about what's progressing
2. **Show Percentages**: When possible, show numerical progress (e.g., "75%" or "7 of 10")
3. **Use Appropriate Colors**: 
   - Use `success` for completed items
   - Use `warning` for high usage (70-89%)
   - Use `danger` for critical levels (90%+)
4. **Size Appropriately**: Use smaller sizes for compact UI elements and larger sizes for prominent progress indicators
5. **Combine with Loading States**: For indeterminate progress, consider using a spinner or skeleton loader instead

## Component API Reference

```ruby
ui.progress_bar(value, options = {})
```

### Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `value` | Float | Yes | - | Progress value between 0 and 1 |
| `color` | Symbol | No | `:primary` | Color variant (`:primary`, `:secondary`, `:success`, `:danger`, `:warning`, `:info`, `:default`) |
| `size` | Symbol | No | `:md` | Size variant (`:sm`, `:md`, `:lg`) |
| `text` | String | No | `nil` | Optional text to display in the center |
| `class` | String | No | `nil` | Additional CSS classes |
| `**options` | Hash | No | `{}` | Additional HTML attributes |

### Notes

- The component automatically adds `animate-pulse` class when progress is less than 100%
- Progress values are automatically clamped between 0 and 1
- Decimal values are converted to percentages and rounded for display
- The progress bar uses `rounded-sm` for subtle rounded corners
- Text labels use `mix-blend-difference` for automatic color contrast