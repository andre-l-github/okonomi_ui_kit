# Table Builder Component Refactoring Tasks (v2)

## Phase 1: Theme Configuration

### Task 1.1: Add table component to theme structure
**File**: `app/helpers/okonomi_ui_kit/theme.rb`
- Add `table:` section under `components:` in both `LIGHT_THEME` and `DEFAULT_THEME`
- Define the following structure:
  ```ruby
  table: {
    # Wrapper elements
    wrapper: {
      root: "flow-root",
      container: "overflow-x-auto",
      alignment: "inline-block min-w-full py-2 align-middle"
    },
    # Table element
    root: "min-w-full divide-y divide-gray-300",
    # Table sections
    thead: {
      root: "",
      tr: ""
    },
    tbody: {
      root: "divide-y divide-gray-200 bg-white",
      tr: {
        root: "",
        # Row variants for different states
        variants: {
          default: "",
          hover: "hover:bg-gray-50",
          selected: "bg-gray-50",
          clickable: "cursor-pointer hover:bg-gray-50"
        },
        # Color variants
        colors: {
          default: "",
          primary: "bg-primary-50",
          success: "bg-success-50",
          danger: "bg-danger-50",
          warning: "bg-warning-50"
        }
      }
    },
    # Header cells
    th: {
      base: "text-sm font-semibold text-gray-900",
      alignment: {
        left: "text-left",
        center: "text-center",
        right: "text-right"
      },
      position: {
        first: "py-3.5 pr-3",
        middle: "px-3 py-3.5",
        last: "relative pl-3 py-3.5"
      },
      # Size variants
      sizes: {
        compact: "py-2 text-xs",
        normal: "py-3.5 text-sm",
        spacious: "py-5 text-base"
      }
    },
    # Data cells
    td: {
      base: "text-sm",
      alignment: {
        left: "text-left",
        center: "text-center",
        right: "text-right"
      },
      position: {
        first: "py-4 pr-3 font-medium text-gray-900",
        middle: "px-3 py-4 text-gray-500",
        last: "relative pl-3 py-4"
      },
      # Size variants (matching th sizes)
      sizes: {
        compact: "py-2 text-xs",
        normal: "py-4 text-sm",
        spacious: "py-5 text-base"
      },
      # Nowrap option
      nowrap: "whitespace-nowrap"
    },
    # Empty state
    empty_state: {
      cell: "text-center py-8 text-gray-500",
      container: "text-center py-8",
      icon: "mx-auto h-12 w-12 text-gray-400",
      title: "mt-2 text-sm font-medium text-gray-900",
      description: "mt-1 text-sm text-gray-500"
    }
  }
  ```

## Phase 2: Create View Templates

### Task 2.1: Create thead template
**File**: `app/views/okonomi/tables/_thead.html.erb`
```erb
<thead class="<%= classes %>">
  <%= yield %>
</thead>
```

### Task 2.2: Create tbody template
**File**: `app/views/okonomi/tables/_tbody.html.erb`
```erb
<tbody class="<%= classes %>">
  <%= yield %>
</tbody>
```

### Task 2.3: Create tr template
**File**: `app/views/okonomi/tables/_tr.html.erb`
```erb
<tr class="<%= classes %>" <%= tag.attributes(options) %>>
  <%= yield %>
</tr>
```

### Task 2.4: Create th template
**File**: `app/views/okonomi/tables/_th.html.erb`
```erb
<th scope="<%= scope %>" class="<%= classes %>" <%= tag.attributes(options) %>>
  <%= content %>
</th>
```

### Task 2.5: Create td template
**File**: `app/views/okonomi/tables/_td.html.erb`
```erb
<td class="<%= classes %>" colspan="<%= colspan if colspan %>" <%= tag.attributes(options) %>>
  <%= content %>
</td>
```

### Task 2.6: Create empty_state template
**File**: `app/views/okonomi/tables/_empty_state.html.erb`
```erb
<%= render 'okonomi/tables/tr', classes: "", options: {} do %>
  <%= render 'okonomi/tables/td', 
    classes: cell_classes,
    colspan: colspan,
    content: capture do %>
    <div class="<%= container_classes %>">
      <% if icon %>
        <%= svg_icon(icon, class: icon_classes) %>
      <% end %>
      <% if title %>
        <p class="<%= title_classes %>"><%= title %></p>
      <% end %>
      <% if description %>
        <p class="<%= description_classes %>"><%= description %></p>
      <% end %>
      <%= yield if block_given? %>
    </div>
  <% end %>,
  options: {} %>
<% end %>
```

### Task 2.7: Update main table template
**File**: `app/views/okonomi/tables/_table.html.erb`
```erb
<div class="<%= wrapper_classes %>">
  <div class="<%= container_classes %>">
    <div class="<%= alignment_classes %>">
      <%= content_tag(:table, class: table_classes, **options.except(:class)) do %>
        <%= yield(builder) %>
      <% end %>
    </div>
  </div>
</div>
```

## Phase 3: Refactor TableBuilder

### Task 3.1: Update TableHelper module
**File**: `app/helpers/okonomi_ui_kit/table_helper.rb`
```ruby
module OkonomiUiKit
  module TableHelper
    def table(**options, &block)
      builder = TableBuilder.new(self, options)
      
      # Extract computed classes for the wrapper template
      wrapper_classes = builder.theme_dig(:table, :wrapper, :root)
      container_classes = builder.theme_dig(:table, :wrapper, :container)
      alignment_classes = builder.theme_dig(:table, :wrapper, :alignment)
      table_classes = [builder.theme_dig(:table, :root), options[:class]].compact.join(' ')
      
      render 'okonomi/tables/table', 
        builder: builder, 
        options: options,
        wrapper_classes: wrapper_classes,
        container_classes: container_classes,
        alignment_classes: alignment_classes,
        table_classes: table_classes,
        &block
    end
  end
end
```

### Task 3.2: Refactor TableBuilder class initialization
**File**: `app/helpers/okonomi_ui_kit/table_helper.rb`
```ruby
class TableBuilder
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::CaptureHelper

  def initialize(template, options = {})
    @template = template
    @options = options
    @current_row_cells = []
    @in_header = false
    @in_body = false
    @table_size = options[:size] || :normal
  end

  def ui
    @template.ui
  end

  def theme_dig(*keys)
    ui.get_theme.dig(:components, *keys)
  end
```

### Task 3.3: Update head method
```ruby
  def head(&block)
    @in_header = true
    @in_body = false
    
    classes = theme_dig(:table, :thead, :root) || ""
    
    result = @template.render('okonomi/tables/thead', classes: classes, &block)
    @in_header = false
    result
  end
```

### Task 3.4: Update body method
```ruby
  def body(&block)
    @in_header = false
    @in_body = true
    
    classes = theme_dig(:table, :tbody, :root) || ""
    
    result = @template.render('okonomi/tables/tbody', classes: classes, &block)
    @in_body = false
    result
  end
```

### Task 3.5: Update tr method
```ruby
  def tr(variant: :default, color: :default, **options, &block)
    @current_row_cells = []
    
    # Collect all cells first
    yield if block_given?
    
    # Build row classes
    base_classes = @in_body ? theme_dig(:table, :tbody, :tr, :root) : theme_dig(:table, :thead, :tr)
    variant_classes = @in_body ? theme_dig(:table, :tbody, :tr, :variants, variant) : ""
    color_classes = @in_body ? theme_dig(:table, :tbody, :tr, :colors, color) : ""
    custom_classes = options.delete(:class) || ""
    
    all_classes = [base_classes, variant_classes, color_classes, custom_classes].compact.join(' ')
    
    # Render cells
    rendered_cells = @current_row_cells.map.with_index do |cell, index|
      position = determine_position(index, @current_row_cells.length)
      
      if cell[:type] == :th
        render_th_cell(cell, position)
      else
        render_td_cell(cell, position)
      end
    end
    
    @template.render('okonomi/tables/tr', classes: all_classes, options: options) do
      @template.safe_join(rendered_cells)
    end
  end
```

### Task 3.6: Add cell rendering methods
```ruby
  private

  def determine_position(index, total)
    if index == 0
      :first
    elsif index == total - 1
      :last
    else
      :middle
    end
  end

  def render_th_cell(cell, position)
    base_classes = theme_dig(:table, :th, :base) || ""
    alignment_classes = theme_dig(:table, :th, :alignment, cell[:align]) || ""
    position_classes = theme_dig(:table, :th, :position, position) || ""
    size_classes = theme_dig(:table, :th, :sizes, @table_size) || ""
    custom_classes = cell[:options][:class] || ""
    
    all_classes = [base_classes, alignment_classes, position_classes, size_classes, custom_classes].compact.join(' ')
    
    @template.render('okonomi/tables/th',
      content: cell[:content],
      scope: cell[:scope],
      classes: all_classes,
      options: cell[:options].except(:class)
    )
  end

  def render_td_cell(cell, position)
    base_classes = theme_dig(:table, :td, :base) || ""
    alignment_classes = theme_dig(:table, :td, :alignment, cell[:align]) || ""
    position_classes = theme_dig(:table, :td, :position, position) || ""
    size_classes = theme_dig(:table, :td, :sizes, @table_size) || ""
    nowrap_classes = cell[:nowrap] ? theme_dig(:table, :td, :nowrap) : ""
    custom_classes = cell[:options][:class] || ""
    
    all_classes = [base_classes, alignment_classes, position_classes, size_classes, nowrap_classes, custom_classes].compact.join(' ')
    
    @template.render('okonomi/tables/td',
      content: cell[:content],
      classes: all_classes,
      colspan: cell[:colspan],
      options: cell[:options].except(:class)
    )
  end
```

### Task 3.7: Update th and td methods
```ruby
  def th(scope: "col", align: :left, **options, &block)
    content = capture(&block) if block_given?
    
    # Store cell data for later processing in tr
    cell = { 
      type: :th, 
      scope: scope, 
      align: align, 
      options: options, 
      content: content 
    }
    @current_row_cells << cell
    
    # Return empty string for now, actual rendering happens in tr
    ""
  end

  def td(align: :left, nowrap: true, colspan: nil, **options, &block)
    content = capture(&block) if block_given?
    
    # Store cell data for later processing in tr
    cell = { 
      type: :td, 
      align: align, 
      nowrap: nowrap,
      colspan: colspan,
      options: options, 
      content: content 
    }
    @current_row_cells << cell
    
    # Return empty string for now, actual rendering happens in tr
    ""
  end
```

### Task 3.8: Update empty_state method
```ruby
  def empty_state(title: nil, description: nil, icon: nil, colspan: nil, partial: nil, &block)
    if partial
      @template.render(partial, colspan: colspan)
    else
      # Compute classes from theme
      cell_classes = theme_dig(:table, :empty_state, :cell)
      container_classes = theme_dig(:table, :empty_state, :container)
      icon_classes = theme_dig(:table, :empty_state, :icon)
      title_classes = theme_dig(:table, :empty_state, :title)
      description_classes = theme_dig(:table, :empty_state, :description)
      
      @template.render('okonomi/tables/empty_state',
        title: title,
        description: description,
        icon: icon,
        colspan: colspan,
        cell_classes: cell_classes,
        container_classes: container_classes,
        icon_classes: icon_classes,
        title_classes: title_classes,
        description_classes: description_classes,
        &block
      )
    end
  end
```

## Phase 4: Usage Examples and Documentation

### Task 4.1: Document usage with ui.theme blocks
**File**: Component documentation or README
```ruby
# Using runtime theme customization
<% ui.theme(components: { table: { td: { base: "text-xs" } } }) do %>
  <%= table do |t| %>
    <!-- table content -->
  <% end %>
<% end %>

# Using size variants
<%= table(size: :compact) do |t| %>
  <!-- compact table -->
<% end %>

# Using row variants
<%= table do |t| %>
  <%= t.body do %>
    <%= t.tr(variant: :hover) do %>
      <!-- hoverable row -->
    <% end %>
    <%= t.tr(color: :success) do %>
      <!-- success colored row -->
    <% end %>
  <% end %>
<% end %>

# Custom empty state
<%= table do |t| %>
  <%= t.empty_state(
    title: "No products found",
    description: "Start by adding your first product",
    icon: "heroicons/outline/shopping-cart"
  ) %>
<% end %>
```

### Task 4.2: Create test file
**File**: `test/helpers/okonomi_ui_kit/table_helper_test.rb`
- Test theme integration via ui.theme blocks
- Test size variants
- Test row color variants
- Test template rendering
- Test backward compatibility

### Task 4.3: Add example to dummy app
**File**: `test/dummy/app/views/examples/tables.html.erb`
- Create comprehensive examples showing all customization options
- Show template override examples
- Demonstrate theme customization

## Phase 5: Migration and Compatibility

### Task 5.1: Ensure backward compatibility
- Maintain existing CSS class output by default
- Support all existing options
- No breaking API changes

### Task 5.2: Update CLAUDE.md
- Add table component customization examples
- Document theme structure for tables
- Show how to override table templates

## Key Differences from v1:

1. **No theme parameter** - Uses established `ui.theme` block pattern
2. **Theme lookups in builder** - Templates receive computed classes only
3. **Follows FormBuilder pattern** - Access theme via `ui.get_theme`
4. **Added variants** - Size variants, row colors, hover states
5. **Simplified templates** - Focus on structure, not theme logic
6. **Consistent with other components** - Matches patterns from form, typography, etc.