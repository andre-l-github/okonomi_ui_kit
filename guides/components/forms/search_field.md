# SearchField Component Guide

The SearchField component provides a styled search input with optimized mobile keyboard, search-specific behavior, and integration with search functionality.

## Basic Usage

#### Simple Search Field
```erb
<%= form_with url: search_path, method: :get, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :query do %>
    <%= f.search_field :query %>
  <% end %>
<% end %>
```

#### With Placeholder
```erb
<%= f.search_field :query, placeholder: "Search products..." %>
```

#### With Auto-submit
```erb
<%= f.search_field :query,
    data: {
      controller: "auto-search",
      action: "input->auto-search#perform"
    } %>
```

## Customization Options

| Option | Type | Purpose |
|--------|------|---------|
| placeholder | String | Placeholder text when field is empty |
| required | Boolean | Mark field as required |
| disabled | Boolean | Disable the input |
| readonly | Boolean | Make field read-only |
| maxlength | Integer | Maximum number of characters |
| autocomplete | String | Autocomplete behavior ("off", "on") |
| class | String | Additional CSS classes |
| data | Hash | Data attributes for JavaScript |

## Advanced Features

#### Live Search with Debounce
```erb
<%= f.search_field :query,
    placeholder: "Search...",
    data: {
      controller: "live-search",
      live_search_url_value: search_path,
      live_search_debounce_value: 300
    } %>

<div data-live-search-target="results" class="mt-4"></div>
```

#### Search with Filters
```erb
<%= form_with url: search_path, method: :get, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.search_field :query,
      placeholder: "Search products...",
      data: {
        controller: "filtered-search",
        filtered_search_target: "input"
      } %>
  
  <%= f.select :category, 
      options_from_collection_for_select(Category.all, :id, :name),
      { prompt: "All Categories" },
      { data: { action: "change->filtered-search#filter" } } %>
<% end %>
```

#### Autocomplete Search
```erb
<%= f.search_field :query,
    placeholder: "Start typing to search...",
    data: {
      controller: "autocomplete-search",
      autocomplete_search_url_value: autocomplete_path,
      autocomplete_search_min_length_value: 2
    } %>

<div data-autocomplete-search-target="dropdown" class="relative">
  <div class="absolute top-full left-0 right-0 bg-white border border-gray-300 rounded-md shadow-lg z-10 hidden">
    <div data-autocomplete-search-target="results"></div>
  </div>
</div>
```

#### Global Site Search
```erb
<%= form_with url: search_path, method: :get, class: "relative", builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.search_field :q,
      placeholder: "Search site...",
      class: "pl-10 pr-4",
      data: {
        controller: "global-search",
        global_search_shortcut: "cmd+k"
      } %>
  
  <div class="absolute left-3 top-1/2 transform -translate-y-1/2">
    <%= ui.icon("heroicons/mini/magnifying-glass", class: "w-4 h-4 text-gray-400") %>
  </div>
<% end %>
```

#### Search History
```erb
<%= f.search_field :query,
    placeholder: "Search...",
    data: {
      controller: "search-history",
      search_history_key: "user_searches"
    } %>

<div data-search-history-target="dropdown" class="hidden">
  <div class="text-xs text-gray-500 px-3 py-2">Recent searches:</div>
  <div data-search-history-target="list"></div>
</div>
```

## Styling

#### Default Styles

The SearchField inherits styles from InputBase:
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
      class SearchField
        register_styles :custom do
          {
            root: "w-full px-4 py-3 border-2 border-gray-200 rounded-full",
            valid: "border-gray-200 focus:border-blue-500",
            error: "border-red-500 bg-red-50 text-red-900",
            disabled: "bg-gray-100 text-gray-500 cursor-not-allowed"
          }
        end
      end
    end
  end
end
```

Or use runtime theme switching:

```erb
<% ui.theme(components: { forms: { search_field: { 
  root: "rounded-full pl-10" 
} } }) do %>
  <%= f.search_field :query %>
<% end %>
```

## Best Practices

1. **Clear Placeholders**: Use descriptive placeholder text
2. **Performance**: Implement debouncing for live search
3. **Accessibility**: Ensure proper ARIA labels for search functionality
4. **Mobile UX**: Leverage search keyboard on mobile devices
5. **Visual Feedback**: Provide loading states during search
6. **History**: Consider implementing search history for better UX

## Accessibility

The SearchField component ensures accessibility by:
- Using native HTML5 search input type
- Triggering search-optimized keyboards on mobile
- Supporting keyboard navigation (Tab, Enter, Escape)
- Providing clear label associations
- Including proper ARIA attributes for search functionality
- Working with screen readers
- Supporting search result announcements
- Showing visual focus indicators

## Examples

#### E-commerce Product Search
```erb
<%= form_with url: products_path, method: :get, class: "mb-6", builder: OkonomiUiKit::FormBuilder do |f| %>
  <div class="relative">
    <%= f.search_field :search,
        placeholder: "Search products...",
        class: "pl-10 pr-4 py-3 w-full border-2 border-gray-300 rounded-lg",
        data: {
          controller: "product-search",
          product_search_url_value: search_products_path,
          product_search_debounce_value: 500
        } %>
    
    <div class="absolute left-3 top-1/2 transform -translate-y-1/2">
      <%= ui.icon("heroicons/mini/magnifying-glass", class: "w-5 h-5 text-gray-400") %>
    </div>
    
    <div class="absolute right-3 top-1/2 transform -translate-y-1/2">
      <button type="submit" class="text-blue-600 hover:text-blue-800">
        Search
      </button>
    </div>
  </div>
  
  <div data-product-search-target="results" class="mt-4 grid grid-cols-1 md:grid-cols-3 gap-4"></div>
<% end %>
```

#### Documentation Search
```erb
<%= form_with url: docs_search_path, method: :get, builder: OkonomiUiKit::FormBuilder do |f| %>
  <div class="relative max-w-lg mx-auto">
    <%= f.search_field :q,
        placeholder: "Search documentation...",
        class: "w-full pl-10 pr-12 py-3 border border-gray-300 rounded-lg",
        data: {
          controller: "docs-search",
          docs_search_url_value: docs_search_path,
          docs_search_target: "input",
          action: "input->docs-search#search keydown->docs-search#handleKeydown"
        } %>
    
    <div class="absolute left-3 top-1/2 transform -translate-y-1/2">
      <%= ui.icon("heroicons/mini/magnifying-glass", class: "w-5 h-5 text-gray-400") %>
    </div>
    
    <div class="absolute right-3 top-1/2 transform -translate-y-1/2 text-xs text-gray-400">
      ⌘K
    </div>
  </div>
  
  <div data-docs-search-target="dropdown" class="relative max-w-lg mx-auto">
    <div class="absolute top-2 left-0 right-0 bg-white border border-gray-300 rounded-lg shadow-lg z-50 hidden">
      <div data-docs-search-target="results" class="max-h-96 overflow-y-auto">
        <!-- Search results will be populated here -->
      </div>
    </div>
  </div>
<% end %>
```

#### User Directory Search
```erb
<%= form_with url: users_path, method: :get, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <h3>Find Users</h3>
    
    <%= f.field :search do %>
      <%= f.search_field :search,
          placeholder: "Search by name, email, or department...",
          data: {
            controller: "user-search",
            user_search_url_value: search_users_path,
            user_search_debounce_value: 300
          } %>
    <% end %>
    
    <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mt-4">
      <%= f.field :department do %>
        <%= f.select :department,
            options_from_collection_for_select(Department.all, :id, :name),
            { prompt: "All Departments" },
            { data: { action: "change->user-search#filter" } } %>
      <% end %>
      
      <%= f.field :role do %>
        <%= f.select :role,
            User.roles.map { |k, v| [k.humanize, k] },
            { prompt: "All Roles" },
            { data: { action: "change->user-search#filter" } } %>
      <% end %>
      
      <%= f.field :status do %>
        <%= f.select :status,
            [["Active", "active"], ["Inactive", "inactive"]],
            { prompt: "All Statuses" },
            { data: { action: "change->user-search#filter" } } %>
      <% end %>
    </div>
  <% end %>
  
  <div data-user-search-target="results" class="mt-6">
    <!-- User results grid -->
  </div>
<% end %>
```

#### Knowledge Base Search
```erb
<%= form_with url: articles_path, method: :get, builder: OkonomiUiKit::FormBuilder do |f| %>
  <div class="bg-blue-50 p-6 rounded-lg">
    <h2 class="text-xl font-semibold mb-4">How can we help?</h2>
    
    <div class="relative">
      <%= f.search_field :query,
          placeholder: "Describe your question or search for keywords...",
          class: "w-full pl-4 pr-12 py-4 text-lg border-2 border-blue-200 rounded-lg focus:border-blue-500",
          data: {
            controller: "knowledge-search",
            knowledge_search_url_value: search_articles_path,
            knowledge_search_suggestions_url_value: article_suggestions_path
          } %>
      
      <button type="submit" class="absolute right-3 top-1/2 transform -translate-y-1/2 bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700">
        Search
      </button>
    </div>
    
    <div data-knowledge-search-target="suggestions" class="mt-4">
      <div class="text-sm text-gray-600 mb-2">Popular searches:</div>
      <div class="flex flex-wrap gap-2">
        <% %w[password reset billing account security].each do |term| %>
          <button type="button" 
                  class="px-3 py-1 text-sm bg-white border border-gray-300 rounded-full hover:bg-gray-50"
                  data-action="knowledge-search#fillSearch"
                  data-term="<%= term %>">
            <%= term %>
          </button>
        <% end %>
      </div>
    </div>
  </div>
<% end %>
```

#### Advanced Search Form
```erb
<%= form_with url: advanced_search_path, method: :get, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <h3>Advanced Search</h3>
    
    <%= f.field :keywords do %>
      <%= f.search_field :keywords,
          placeholder: "Enter keywords...",
          class: "text-lg py-3" %>
    <% end %>
    
    <%= f.field :exact_phrase do %>
      <%= f.search_field :exact_phrase,
          placeholder: 'Exact phrase in "quotes"' %>
    <% end %>
    
    <%= f.field :exclude_words do %>
      <%= f.search_field :exclude_words,
          placeholder: "Words to exclude..." %>
    <% end %>
    
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
      <%= f.field :date_from do %>
        <%= f.date_field :date_from %>
      <% end %>
      
      <%= f.field :date_to do %>
        <%= f.date_field :date_to %>
      <% end %>
    </div>
    
    <%= f.field :content_type do %>
      <%= f.select :content_type,
          [["All Content", ""], ["Articles", "article"], ["Videos", "video"], ["Downloads", "download"]],
          {} %>
    <% end %>
  <% end %>
<% end %>
```

#### Site-wide Search with Shortcuts
```erb
<div class="relative" data-controller="global-search" data-global-search-shortcut-value="cmd+k">
  <%= form_with url: search_path, method: :get, builder: OkonomiUiKit::FormBuilder do |f| %>
    <%= f.search_field :q,
        placeholder: "Search...",
        class: "w-full pl-10 pr-20 py-2 border border-gray-300 rounded-lg",
        data: {
          global_search_target: "input",
          action: "input->global-search#search focus->global-search#showDropdown blur->global-search#hideDropdown"
        } %>
    
    <div class="absolute left-3 top-1/2 transform -translate-y-1/2">
      <%= ui.icon("heroicons/mini/magnifying-glass", class: "w-4 h-4 text-gray-400") %>
    </div>
    
    <div class="absolute right-3 top-1/2 transform -translate-y-1/2 text-xs text-gray-400 bg-gray-100 px-2 py-1 rounded">
      ⌘K
    </div>
  <% end %>
  
  <div data-global-search-target="dropdown" class="absolute top-full left-0 right-0 mt-1 bg-white border border-gray-300 rounded-lg shadow-lg z-50 hidden">
    <div data-global-search-target="results" class="max-h-80 overflow-y-auto">
      <!-- Results populated by Stimulus controller -->
    </div>
    
    <div class="border-t border-gray-200 px-4 py-2 text-xs text-gray-500">
      <span class="font-medium">Tip:</span> Use ↑↓ to navigate, ↵ to select, esc to close
    </div>
  </div>
</div>
```

#### Mobile-Optimized Search
```erb
<%= form_with url: mobile_search_path, method: :get, builder: OkonomiUiKit::FormBuilder do |f| %>
  <div class="relative">
    <%= f.search_field :q,
        placeholder: "Search...",
        class: "w-full pl-12 pr-4 py-4 text-lg border-2 border-gray-300 rounded-full",
        data: {
          controller: "mobile-search",
          mobile_search_voice_enabled: true
        } %>
    
    <div class="absolute left-4 top-1/2 transform -translate-y-1/2">
      <%= ui.icon("heroicons/mini/magnifying-glass", class: "w-6 h-6 text-gray-400") %>
    </div>
    
    <button type="button" 
            class="absolute right-4 top-1/2 transform -translate-y-1/2"
            data-action="mobile-search#startVoiceSearch">
      <%= ui.icon("heroicons/mini/microphone", class: "w-6 h-6 text-gray-400") %>
    </button>
  </div>
  
  <div data-mobile-search-target="suggestions" class="mt-4 space-y-2">
    <!-- Search suggestions for mobile -->
  </div>
<% end %>
```