# Table Builder Component Refactoring Plan

## Current Limitations

1. **Hard-coded CSS classes** - Table styling is embedded directly in the Ruby code, making it difficult to customize without modifying the gem
2. **No theme integration** - Unlike other components (button, typography), the table component doesn't use the theme system
3. **Limited template structure** - Only the outer wrapper has a template, individual cell rendering is done in Ruby
4. **Inflexible empty state** - Hard-coded structure and text for empty states

## Proposed Refactoring

### 1. Move styling to theme configuration

Add a `table` section to the theme with configurable classes for:
- Container wrapper
- Table element
- thead/tbody
- th/td cells (with variants for first/last/middle positions)
- Empty state styling

### 2. Create granular view templates

- `_table.html.erb` - Already exists
- `_thead.html.erb` - For customizable header structure
- `_tbody.html.erb` - For customizable body structure
- `_th.html.erb` - For header cell rendering
- `_td.html.erb` - For data cell rendering
- `_empty_state.html.erb` - For empty state display

### 3. Refactor TableBuilder to use theme and templates

- Replace hard-coded classes with theme lookups
- Use `render` for cell generation instead of direct tag generation
- Pass alignment, position (first/last), and other context to templates

### 4. Add configuration options

- Allow passing custom theme overrides to the table helper
- Support custom empty state templates
- Enable responsive behavior configuration

### 5. Example of refactored usage

```ruby
# With theme customization
table(theme: { td: { base: "custom-cell-class" } }) do |t|
  # table content
end

# With custom empty state
table(empty_state_partial: "admin/empty_records") do |t|
  # table content
end
```

## Benefits

This refactoring will:
- Align the table component with the project's customization philosophy
- Allow client applications to override both structure (via templates) and styling (via theme)
- Maintain backward compatibility
- Follow the same patterns as other components in the system