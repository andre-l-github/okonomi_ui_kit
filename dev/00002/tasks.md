# Page Builder Refactoring Tasks

## Phase 1: Theme Integration Foundation

### Task 1.1: Add Page Builder Components to Theme Structure
- [ ] Add `page_builder` section to `OkonomiUiKit::Theme::DEFAULT_THEME` in `app/helpers/okonomi_ui_kit/theme.rb`
- [ ] Define theme structure for:
  - `page` component with base classes and variants (compact, spacious, full-width)
  - `page_header` component with layout variants
  - `page_header_row` component with title and actions styling
  - `section` component with color schemes and spacing variants
  - `section_attribute` component with label/value styling options

### Task 1.2: Create Theme Helper Methods
- [ ] Add `theme_classes_for(:page_builder, :component_name, options)` method to UiHelper
- [ ] Implement theme merging support for page builder components
- [ ] Add helper methods: `page_theme`, `header_theme`, `section_theme`

## Phase 2: Extract Hardcoded Classes

### Task 2.1: Replace Hardcoded Classes in PageBuilder
- [ ] Replace `"flex flex-col gap-8 p-8"` in `_page.html.erb` with theme lookup
- [ ] Add support for `:variant` option (`:compact`, `:spacious`, `:full_width`)
- [ ] Allow custom classes via `:class` option

### Task 2.2: Replace Hardcoded Classes in PageHeaderBuilder
- [ ] Replace `"flex flex-col gap-2"` in `PageHeaderBuilder#render` (line 65)
- [ ] Replace `"text-2xl font-bold..."` in `PageHeaderRowBuilder#title` (line 92)
- [ ] Replace `"mt-4 flex md:ml-4..."` in `PageHeaderRowBuilder#actions` (line 96)
- [ ] Replace `"flex w-full justify-between..."` in `PageHeaderRowBuilder#render` (line 102)

### Task 2.3: Replace Hardcoded Classes in SectionBuilder
- [ ] Replace `"text-base/7 font-semibold text-gray-900"` in `title` (line 134)
- [ ] Replace `"mt-1 max-w-2xl text-sm/6 text-gray-500"` in `subtitle` (line 138)
- [ ] Replace `"divide-y divide-gray-100"` in `body` (line 149)
- [ ] Replace attribute classes in `attribute` method (lines 164-168)
- [ ] Replace `"overflow-hidden bg-white"` in `render` (line 173)
- [ ] Replace `"py-6"` and related classes in `build_header` (line 187)

## Phase 3: Template Separation

### Task 3.1: Create Individual Template Files
- [ ] Create `app/views/okonomi/page_builder/_page_header.html.erb`
- [ ] Create `app/views/okonomi/page_builder/_page_header_row.html.erb`
- [ ] Create `app/views/okonomi/page_builder/_section.html.erb`
- [ ] Create `app/views/okonomi/page_builder/_section_header.html.erb`
- [ ] Create `app/views/okonomi/page_builder/_section_attribute.html.erb`

### Task 3.2: Update Builders to Use Templates
- [ ] Modify `PageHeaderBuilder#render` to use `_page_header.html.erb`
- [ ] Modify `PageHeaderRowBuilder#render` to use `_page_header_row.html.erb`
- [ ] Modify `SectionBuilder#render` to use `_section.html.erb`
- [ ] Modify `SectionBuilder#build_header` to use `_section_header.html.erb`
- [ ] Modify `SectionBuilder#attribute` to use `_section_attribute.html.erb`

## Phase 4: Builder Options Enhancement

### Task 4.1: Add Options to Builder Methods
- [ ] Update `page` method to accept full options hash (variant, class, etc.)
- [ ] Update `page_header` to accept options (variant, spacing, etc.)
- [ ] Update `section` to accept options (variant, color_scheme, bordered, etc.)
- [ ] Update `title` methods to accept typography options
- [ ] Update `actions` methods to accept layout options

### Task 4.2: Implement Options Processing
- [ ] Create `process_page_options` method to handle theme lookups
- [ ] Create `merge_classes` utility to combine theme and custom classes
- [ ] Add validation for supported variants and options

## Phase 5: Flexible Component Structure

### Task 5.1: Add Configuration Support
- [ ] Create `OkonomiUiKit.configuration.page_builder` configuration object
- [ ] Add option to specify custom builder classes
- [ ] Add option to configure default variants and behaviors

### Task 5.2: Implement Slot System
- [ ] Add `slot` method to builders for custom content injection
- [ ] Define named slots: `:before_header`, `:after_header`, `:before_body`, `:after_body`
- [ ] Update templates to render slot content

### Task 5.3: Builder Extension Support
- [ ] Make builder classes configurable via options
- [ ] Add `register_builder` method for custom builders
- [ ] Document builder interface for extensions

## Phase 6: Breadcrumb Integration

### Task 6.1: Move Breadcrumbs to Theme System
- [ ] Add `breadcrumbs` component to theme structure
- [ ] Extract hardcoded classes from `BreadcrumbsHelper`
- [ ] Add variants: `:simple`, `:chevron`, `:slash`, `:arrow`

### Task 6.2: Enhance Breadcrumb Customization
- [ ] Make separator icon configurable
- [ ] Add color scheme support
- [ ] Support different sizes (small, medium, large)
- [ ] Allow custom separator content

### Task 6.3: Integrate with Page Builder
- [ ] Update `PageHeaderBuilder#breadcrumbs` to use theme
- [ ] Pass breadcrumb options through page builder
- [ ] Ensure consistent styling with page theme

## Phase 7: Testing and Documentation

### Task 7.1: Add Tests
- [ ] Test theme integration for all components
- [ ] Test option handling and validation
- [ ] Test template overrides
- [ ] Test backward compatibility

### Task 7.2: Update Documentation
- [ ] Document theme structure for page builder
- [ ] Add examples of customization approaches
- [ ] Document slot system usage
- [ ] Create migration guide for existing users

## Implementation Order
1. Phase 1 & 2 (Theme foundation and class extraction) - Critical for customization
2. Phase 4 (Options enhancement) - Enables immediate customization
3. Phase 3 (Template separation) - Allows template overrides
4. Phase 5 (Flexible structure) - Advanced customization
5. Phase 6 (Breadcrumb integration) - Complete the integration
6. Phase 7 (Testing & docs) - Ensure quality and usability

## Backward Compatibility Notes
- All existing method signatures must continue to work
- Default behavior should remain unchanged
- New features should be opt-in via options
- Deprecation warnings for any breaking changes (none planned)