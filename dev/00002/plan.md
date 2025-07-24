# Page Builder Refactoring Plan for Enhanced Customization

Based on my analysis, I've identified several areas where the page_builder component lacks customization options. Here's my proposed refactoring plan:

## 1. Theme Integration
- Add theme support to all page builder components (currently hardcoded classes)
- Create theme definitions for: page, page_header, page_section, breadcrumbs
- Allow runtime theme customization via `ui.theme` blocks

## 2. Extract Hardcoded Classes to Theme
- Move all inline Tailwind classes to the theme system
- Create variants for different page layouts (compact, spacious, etc.)
- Support color schemes beyond the hardcoded gray palette

## 3. Template Customization
- Create separate template files for each component:
  - `_page_header.html.erb`
  - `_page_header_row.html.erb`
  - `_section.html.erb`
  - `_section_attribute.html.erb`
- This allows clients to override individual components

## 4. Builder Options Enhancement
- Add options to all builder methods (currently minimal)
- Support custom CSS classes via options
- Allow disabling/enabling component features

## 5. Flexible Component Structure
- Make component structure configurable (e.g., header layout options)
- Support custom builder classes via configuration
- Add slots/blocks for extensibility

## 6. Breadcrumb Integration
- Currently breadcrumbs are separate - integrate with theme system
- Make chevron icon configurable
- Support different breadcrumb styles/layouts

These changes will align the page_builder with the project's customization philosophy while maintaining backward compatibility.

## Current Issues Identified

### Hardcoded Classes
- `PageHeaderBuilder#render`: `"flex flex-col gap-2"` - app/helpers/okonomi_ui_kit/page_builder_helper.rb:65
- `PageHeaderRowBuilder#title`: `"text-2xl font-bold leading-7 text-gray-900 truncate sm:text-3xl sm:tracking-tight"` - app/helpers/okonomi_ui_kit/page_builder_helper.rb:92
- `PageHeaderRowBuilder#actions`: `"mt-4 flex md:ml-4 md:mt-0 gap-2"` - app/helpers/okonomi_ui_kit/page_builder_helper.rb:96
- `PageHeaderRowBuilder#render`: `"flex w-full justify-between items-center"` - app/helpers/okonomi_ui_kit/page_builder_helper.rb:102
- `SectionBuilder#title`: `"text-base/7 font-semibold text-gray-900"` - app/helpers/okonomi_ui_kit/page_builder_helper.rb:134
- `SectionBuilder#subtitle`: `"mt-1 max-w-2xl text-sm/6 text-gray-500"` - app/helpers/okonomi_ui_kit/page_builder_helper.rb:138
- `SectionBuilder#body`: `"divide-y divide-gray-100"` - app/helpers/okonomi_ui_kit/page_builder_helper.rb:149
- `SectionBuilder#attribute`: Multiple hardcoded classes for layout and styling - app/helpers/okonomi_ui_kit/page_builder_helper.rb:164-168
- `SectionBuilder#render`: `"overflow-hidden bg-white"` - app/helpers/okonomi_ui_kit/page_builder_helper.rb:173
- `_page.html.erb`: `"flex flex-col gap-8 p-8"` - app/views/okonomi/page_builder/_page.html.erb:1

### Limited Customization Options
- Most builder methods accept no options or very limited options
- No way to customize component structure without overriding entire helper
- No theme integration for consistent styling
- Template overrides require copying entire partial

### Tight Coupling
- Breadcrumbs are called directly without going through theme system
- No way to inject custom builders or extend existing ones
- Fixed HTML structure with no slot/block system for extensions