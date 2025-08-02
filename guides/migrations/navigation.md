# Navigation Component Migration Guide

This guide helps you migrate from the legacy `NavigationHelper` to the new component-based Navigation system.

## Overview of Changes

The Navigation component has been refactored from a helper module to a proper component following OkonomiUiKit's component architecture. This provides better theme integration, style customization, and consistency with other components.

### Key Changes

1. **Access Method**: Changed from `navigation_menu` to `ui.navigation`
2. **Theme Integration**: Styles are now managed through the component's style registry
3. **Builder Pattern**: The builder classes are now nested within the component
4. **Template Structure**: Templates moved from `app/views/okonomi/navigation/` to `app/views/okonomi/components/navigation/`

## Migration Steps

### Step 1: Update Method Calls

Replace all calls to `navigation_menu` with `ui.navigation`:

**Before:**
```erb
<%= navigation_menu do |nav| %>
  <!-- navigation content -->
<% end %>
```

**After:**
```erb
<%= ui.navigation do |nav| %>
  <!-- navigation content -->
<% end %>
```

### Step 2: Update Custom Styles

If you were overriding navigation styles through CSS or inline classes, migrate them to the theme system:

**Before (CSS override):**
```css
.navigation-menu .group-title {
  color: #custom-color;
  font-size: 14px;
}
```

**After (Theme configuration):**
```ruby
# config/initializers/okonomi_ui_kit.rb
Rails.application.config.after_initialize do
  OkonomiUiKit::Theme::DEFAULT_THEME.deep_merge!({
    components: {
      navigation: {
        group: {
          title: "text-sm text-[#custom-color]"
        }
      }
    }
  })
end
```

### Step 3: Update Template Overrides

If you have custom navigation templates, move them to the new location:

**Before:**
```
app/views/okonomi/navigation/_menu.html.erb
app/views/okonomi/navigation/_link.html.erb
```

**After:**
```
app/views/okonomi/components/navigation/_navigation.html.erb
app/views/okonomi/components/navigation/_link.html.erb
```

### Step 4: Update Builder References

If you're extending or customizing the navigation builders:

**Before:**
```ruby
class CustomNavigationBuilder < OkonomiUiKit::NavigationHelper::NavigationBuilder
  # custom methods
end
```

**After:**
```ruby
class CustomNavigationBuilder < OkonomiUiKit::Components::Navigation::NavigationBuilder
  # custom methods
end
```

## API Compatibility

The navigation API remains largely unchanged:

- `nav.group(title, &block)` - Works the same
- `group.nav_link(title, path, options)` - Works the same
- `nav.profile_section(&block)` - Works the same

## Style Customization

The new component uses a structured style system:

```ruby
OkonomiUiKit::Components::Navigation.register_styles :custom do
  {
    menu: {
      base: "custom-menu-classes"
    },
    group: {
      title: "custom-group-title-classes",
      list: "custom-group-list-classes"
    },
    link: {
      base: "custom-link-classes",
      active: "custom-active-link-classes",
      icon: "custom-icon-classes",
      initials: {
        base: "custom-initials-classes"
      }
    },
    profile_section: {
      base: "custom-profile-section-classes"
    }
  }
end
```

## Troubleshooting

### Navigation Not Rendering

If your navigation isn't rendering after migration:

1. Ensure you're using `ui.navigation` instead of `navigation_menu`
2. Check that the Navigation component is being loaded properly
3. Verify template paths if you have custom overrides

### Styling Issues

If styles aren't applying correctly:

1. Check the theme configuration syntax
2. Ensure theme changes are in an `after_initialize` block
3. Use the browser inspector to verify classes are being applied

### Active Link Issues

The Navigation component uses `active_link_to` helper. Ensure it's available in your application or add the gem:

```ruby
gem 'active_link_to'
```

## Benefits of Migration

1. **Consistent API**: Navigation now follows the same pattern as other UI components
2. **Better Theme Integration**: Styles can be customized through the central theme system
3. **Improved Maintainability**: Component-based architecture is easier to test and extend
4. **Type Safety**: Better IDE support and autocomplete with the component pattern

## Need Help?

If you encounter issues during migration:

1. Check the [Navigation Component Guide](../components/navigation.md) for detailed usage
2. Review the component source at `app/helpers/okonomi_ui_kit/components/navigation.rb`
3. File an issue in the OkonomiUiKit repository with migration problems