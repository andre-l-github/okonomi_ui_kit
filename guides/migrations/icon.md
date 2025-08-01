# Icon Helper to Icon Component Migration Guide

This guide helps you migrate from the legacy `IconHelper` methods (`svg_icon` and `icon_tag`) to the new Icon component.

## Overview

The Icon component replaces the `IconHelper` module with a proper component-based implementation that follows OkonomiUiKit's component architecture.

### What Changed

- **Old**: `svg_icon()` and `icon_tag()` helper methods
- **New**: `ui.icon()` component method
- **Benefits**: 
  - Consistent with other UI components
  - Better theme integration
  - Cleaner codebase
  - More testable

## Migration Steps

### 1. Basic Icon Usage

**Before:**
```erb
<%= svg_icon("heroicons/outline/home") %>
```

**After:**
```erb
<%= ui.icon("heroicons/outline/home") %>
```

### 2. Icons with CSS Classes

**Before:**
```erb
<%= svg_icon("heroicons/outline/user", class: "h-6 w-6 text-blue-500") %>
```

**After:**
```erb
<%= ui.icon("heroicons/outline/user", class: "h-6 w-6 text-blue-500") %>
```

### 3. Icons with Dimensions

**Before:**
```erb
<%= svg_icon("heroicons/outline/search", width: "24", height: "24", class: "text-gray-400") %>
```

**After:**
```erb
<%= ui.icon("heroicons/outline/search", width: "24", height: "24", class: "text-gray-400") %>
```

### 4. Icon Tag Usage (Deprecated)

The `icon_tag` method was designed to work with an `Icon` class that was never implemented. If you have any usage of `icon_tag`, replace it with `ui.icon`:

**Before:**
```erb
<%= icon_tag(icon_object, :outlined, class: "h-5 w-5") %>
```

**After:**
```erb
<%= ui.icon("path/to/icon", class: "h-5 w-5") %>
```

## Automated Migration

You can use the following script to help automate the migration in your codebase:

```bash
# Find all files using svg_icon
grep -r "svg_icon(" app/views/ --include="*.erb"

# Replace svg_icon with ui.icon (review changes before committing)
find app/views/ -name "*.erb" -type f -exec sed -i 's/svg_icon(/ui.icon(/g' {} +
```

## Manual Review Required

After automated migration, review the following:

1. **Complex Helper Usage**: If you have custom helpers that call `svg_icon`, update them to use `ui.icon`
2. **JavaScript**: Any JavaScript that might be generating icon HTML needs manual updating
3. **Tests**: Update any tests that were testing the old helper methods

## Backward Compatibility

The Icon component maintains backward compatibility during the transition:

- The component accepts the same parameters as `svg_icon`
- The `variant` parameter from `icon_tag` is accepted but ignored
- Error handling remains the same (returns HTML comment for missing icons)

## Removal Timeline

1. **Current**: Both old helpers and new component work
2. **Next Minor Version**: Deprecation warnings added to old helpers
3. **Next Major Version**: Old helpers removed completely

## Getting Help

If you encounter any issues during migration:

1. Check that the icon path is correct
2. Ensure you're using `ui.icon` within a view context where `ui` is available
3. Verify that your icon files are in the correct location (`app/assets/images/`)

## Example Migration

Here's a complete before/after example from a typical view file:

**Before:**
```erb
<div class="flex items-center space-x-4">
  <%= svg_icon("heroicons/outline/home", class: "h-5 w-5") %>
  <span>Home</span>
</div>

<button class="btn">
  <%= svg_icon("heroicons/outline/plus", class: "h-4 w-4 mr-2") %>
  Add Item
</button>

<% if @document.present? %>
  <%= svg_icon("heroicons/solid/document", class: "h-6 w-6 text-gray-600") %>
<% else %>
  <%= svg_icon("heroicons/outline/document", class: "h-6 w-6 text-gray-400") %>
<% end %>
```

**After:**
```erb
<div class="flex items-center space-x-4">
  <%= ui.icon("heroicons/outline/home", class: "h-5 w-5") %>
  <span>Home</span>
</div>

<button class="btn">
  <%= ui.icon("heroicons/outline/plus", class: "h-4 w-4 mr-2") %>
  Add Item
</button>

<% if @document.present? %>
  <%= ui.icon("heroicons/solid/document", class: "h-6 w-6 text-gray-600") %>
<% else %>
  <%= ui.icon("heroicons/outline/document", class: "h-6 w-6 text-gray-400") %>
<% end %>
```

The migration is straightforward - simply replace `svg_icon` with `ui.icon` throughout your codebase.