# Breadcrumbs Migration Guide

This guide helps you migrate from the legacy `BreadcrumbsHelper` to the new component-based breadcrumbs implementation.

## Overview of Changes

The breadcrumbs functionality has been refactored from a helper module to a proper component following the OkonomiUiKit component architecture. This provides better encapsulation, theme integration, and consistency with other UI components.

### Key Differences

1. **Access Method**: Changed from `breadcrumbs` helper to `ui.breadcrumbs` component
2. **Architecture**: Moved from helper module to component class with template rendering
3. **Styling**: Integrated with the component styling system using `register_styles`
4. **Theme Support**: Full theme integration with style customization

## Migration Steps

### 1. Direct Usage in Views

If you're using breadcrumbs directly in your views:

**Before:**
```erb
<%= breadcrumbs do |crumb| %>
  <% crumb.link("Home", root_path) %>
  <% crumb.link("Products", products_path) %>
<% end %>
```

**After:**
```erb
<%= ui.breadcrumbs do |crumb| %>
  <% crumb.link("Home", root_path) %>
  <% crumb.link("Products", products_path) %>
<% end %>
```

### 2. Usage with Page Headers

If you're using breadcrumbs within page headers, no changes are needed as the page component has been updated internally:

```erb
<%= ui.page do |page| %>
  <% page.page_header do |header| %>
    <% header.breadcrumbs do |crumb| %>
      <% crumb.link("Home", root_path) %>
      <% crumb.link("Dashboard", dashboard_path) %>
    <% end %>
  <% end %>
<% end %>
```

### 3. Custom Helper Methods

If you have custom helper methods that wrap breadcrumbs:

**Before:**
```ruby
def admin_breadcrumbs
  breadcrumbs do |crumb|
    crumb.link("Admin", admin_path)
    yield crumb if block_given?
  end
end
```

**After:**
```ruby
def admin_breadcrumbs(&block)
  ui.breadcrumbs do |crumb|
    crumb.link("Admin", admin_path)
    yield crumb if block_given?
  end
end
```

### 4. Tests

Update your tests to use the new component API:

**Before:**
```ruby
# Mocking the helper
def breadcrumbs(&block)
  "<nav>Breadcrumbs</nav>".html_safe
end
```

**After:**
```ruby
# No mocking needed - use the actual component
html = ui.breadcrumbs do |crumb|
  crumb.link("Home", "/")
  crumb.link("Test", "/test")
end

assert_includes html, "Home"
assert_includes html, "Test"
```

## API Compatibility

The breadcrumbs API remains largely the same:

### Unchanged Features
- Block-based API with `crumb.link` method
- Support for `current: true` parameter
- Icon support for first item
- Path can be `nil` for non-linked items

### New Features
- Full theme integration
- Customizable styles via `register_styles`
- Better component isolation
- Consistent with other UI components

## Removing the Old Helper

Once migration is complete, you can remove the old helper:

1. Delete `app/helpers/okonomi_ui_kit/breadcrumbs_helper.rb`
2. Remove any `include OkonomiUiKit::BreadcrumbsHelper` statements
3. Remove the helper from your engine configuration if explicitly included

## Customization

The new component supports style customization through the component system:

```ruby
# Customize breadcrumbs styles
OkonomiUiKit::Components::Breadcrumbs.register_styles :custom do
  {
    base: "flex",
    nav: "my-custom-nav-class",
    list: "flex items-center space-x-3",
    link: {
      base: "text-blue-600 hover:text-blue-800",
      current: "text-gray-900 font-semibold"
    }
  }
end
```

## Troubleshooting

### Common Issues

1. **`undefined method 'breadcrumbs'`**
   - Solution: Change to `ui.breadcrumbs`

2. **Styling differences**
   - The new component uses registered styles instead of hardcoded classes
   - Check your theme customizations if styles appear different

3. **Test failures**
   - Remove breadcrumbs mocks from tests
   - Use the actual component in tests

### Gradual Migration

If you need to maintain both implementations temporarily:

```ruby
# In an initializer
module BreadcrumbsCompatibility
  def breadcrumbs(&block)
    ui.breadcrumbs(&block)
  end
end

# Include in your ApplicationHelper
ApplicationHelper.include(BreadcrumbsCompatibility)
```

This allows you to migrate gradually while maintaining backward compatibility.

## Benefits of Migration

1. **Consistency**: Aligns with other OkonomiUiKit components
2. **Maintainability**: Component-based architecture is easier to maintain
3. **Customization**: Better theme and style customization options
4. **Testing**: No need for mocking in tests
5. **Future-proof**: Ready for future enhancements to the component system