# UrlField Component Guide

The UrlField component provides a styled URL input with built-in validation, protocol handling, and mobile-optimized keyboard support for entering web addresses.

## Basic Usage

#### Simple URL Field
```erb
<%= form_with model: @user, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :website do %>
    <%= f.url_field :website %>
  <% end %>
<% end %>
```

#### With Placeholder
```erb
<%= f.url_field :website, placeholder: "https://www.example.com" %>
```

#### With Pattern Validation
```erb
<%= f.url_field :website, 
    pattern: "https?://.+",
    title: "Please enter a valid URL starting with http:// or https://" %>
```

## Customization Options

| Option | Type | Purpose |
|--------|------|---------|
| placeholder | String | Placeholder text showing URL format |
| required | Boolean | Mark field as required |
| disabled | Boolean | Disable the input |
| readonly | Boolean | Make field read-only |
| pattern | String | Regular expression for validation |
| maxlength | Integer | Maximum number of characters |
| autocomplete | String | Autocomplete behavior ("url", "off") |
| class | String | Additional CSS classes |
| data | Hash | Data attributes for JavaScript |

## Advanced Features

#### URL Validation and Formatting
```erb
<%= f.url_field :website,
    placeholder: "https://www.example.com",
    data: {
      controller: "url-validator",
      url_validator_auto_protocol: true,
      action: "blur->url-validator#validate"
    } %>

<div data-url-validator-target="feedback" class="text-sm mt-1"></div>
```

#### Social Media URL Fields
```erb
<%= f.url_field :twitter_url,
    placeholder: "https://twitter.com/username",
    pattern: "https://(?:www\\.)?twitter\\.com/.+",
    data: {
      controller: "social-url-validator",
      social_url_validator_platform: "twitter"
    } %>
```

#### URL Preview and Validation
```erb
<%= f.url_field :link_url,
    placeholder: "https://www.example.com",
    data: {
      controller: "url-preview",
      url_preview_fetch_metadata: true,
      action: "blur->url-preview#fetchPreview"
    } %>

<div data-url-preview-target="preview" class="mt-3 p-3 border rounded-lg hidden">
  <div class="flex space-x-3">
    <img data-url-preview-target="image" class="w-16 h-16 object-cover rounded">
    <div class="flex-1">
      <h4 data-url-preview-target="title" class="font-medium"></h4>
      <p data-url-preview-target="description" class="text-sm text-gray-600"></p>
      <span data-url-preview-target="domain" class="text-xs text-gray-500"></span>
    </div>
  </div>
</div>
```

#### Multiple URL Management
```erb
<div data-controller="url-manager">
  <% @links.each_with_index do |link, index| %>
    <div data-url-manager-target="urlItem" class="flex space-x-2 mb-2">
      <%= f.url_field "links[#{index}][url]",
          placeholder: "https://www.example.com",
          class: "flex-1" %>
      
      <button type="button" 
              class="px-2 py-1 text-red-600 hover:text-red-800"
              data-action="url-manager#removeUrl">
        Remove
      </button>
    </div>
  <% end %>
  
  <button type="button" 
          class="text-blue-600 hover:text-blue-800"
          data-action="url-manager#addUrl">
    + Add URL
  </button>
</div>
```

#### URL Shortening Integration
```erb
<%= f.url_field :original_url,
    placeholder: "https://www.example.com",
    data: {
      controller: "url-shortener",
      url_shortener_api_endpoint: shorten_url_path,
      action: "blur->url-shortener#shortenUrl"
    } %>

<div data-url-shortener-target="result" class="mt-2 hidden">
  <div class="flex space-x-2 items-center">
    <span class="text-sm text-gray-600">Short URL:</span>
    <input type="text" 
           data-url-shortener-target="shortUrl" 
           class="text-sm border rounded px-2 py-1 flex-1" 
           readonly>
    <button type="button" 
            class="text-blue-600 hover:text-blue-800 text-sm"
            data-action="url-shortener#copyShortUrl">
      Copy
    </button>
  </div>
</div>
```

## Styling

#### Default Styles

The UrlField inherits styles from InputBase:
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
      class UrlField
        register_styles :custom do
          {
            root: "w-full px-4 py-3 border-2 border-gray-200 rounded-lg font-mono",
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
<% ui.theme(components: { forms: { url_field: { 
  root: "font-mono text-blue-600" 
} } }) do %>
  <%= f.url_field :website %>
<% end %>
```

## Best Practices

1. **Clear Format**: Show expected URL format in placeholders
2. **Protocol Handling**: Auto-add protocols when missing
3. **Validation**: Validate URLs on both client and server
4. **User Feedback**: Provide clear error messages for invalid URLs
5. **Security**: Validate and sanitize URLs for security
6. **Accessibility**: Ensure proper keyboard and screen reader support

## Accessibility

The UrlField component ensures accessibility by:
- Using native HTML5 url input type
- Triggering appropriate keyboards on mobile devices
- Supporting keyboard navigation (Tab, Enter)
- Providing clear label associations
- Including proper ARIA attributes for error states
- Working with screen readers
- Supporting autocomplete for better UX
- Showing visual focus indicators

## Examples

#### Social Media Links Form
```erb
<%= form_with model: @social_profile, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <h3>Social Media Links</h3>
    <p class="text-gray-600 mb-4">Add links to your social media profiles</p>
    
    <%= f.field :website do %>
      <%= f.url_field :website,
          placeholder: "https://www.yoursite.com",
          data: {
            controller: "url-validator",
            url_validator_auto_protocol: true
          } %>
    <% end %>
    
    <%= f.field :linkedin_url do %>
      <%= f.url_field :linkedin_url,
          placeholder: "https://linkedin.com/in/username",
          pattern: "https://(?:www\\.)?linkedin\\.com/in/.+",
          data: {
            controller: "social-url-validator",
            social_url_validator_platform: "linkedin"
          } %>
    <% end %>
    
    <%= f.field :twitter_url do %>
      <%= f.url_field :twitter_url,
          placeholder: "https://twitter.com/username",
          pattern: "https://(?:www\\.)?twitter\\.com/.+",
          data: {
            controller: "social-url-validator",
            social_url_validator_platform: "twitter"
          } %>
    <% end %>
    
    <%= f.field :github_url do %>
      <%= f.url_field :github_url,
          placeholder: "https://github.com/username",
          pattern: "https://(?:www\\.)?github\\.com/.+",
          data: {
            controller: "social-url-validator",
            social_url_validator_platform: "github"
          } %>
    <% end %>
  <% end %>
<% end %>
```

#### Company Information Form
```erb
<%= form_with model: @company, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :website do %>
    <%= f.url_field :website,
        placeholder: "https://www.company.com",
        required: true,
        data: {
          controller: "url-validator url-preview",
          url_validator_auto_protocol: true,
          url_preview_fetch_metadata: true,
          action: "blur->url-validator#validate blur->url-preview#fetchPreview"
        } %>
    
    <div data-url-preview-target="preview" class="mt-3 p-3 bg-gray-50 rounded-lg hidden">
      <div class="flex items-start space-x-3">
        <img data-url-preview-target="favicon" class="w-6 h-6 mt-1">
        <div>
          <h4 data-url-preview-target="title" class="font-medium text-gray-900"></h4>
          <p data-url-preview-target="description" class="text-sm text-gray-600 mt-1"></p>
        </div>
      </div>
    </div>
  <% end %>
  
  <%= f.field :blog_url do %>
    <%= f.url_field :blog_url,
        placeholder: "https://blog.company.com (optional)" %>
  <% end %>
  
  <%= f.field :support_url do %>
    <%= f.url_field :support_url,
        placeholder: "https://support.company.com (optional)" %>
  <% end %>
  
  <%= f.field :careers_url do %>
    <%= f.url_field :careers_url,
        placeholder: "https://careers.company.com (optional)" %>
  <% end %>
<% end %>
```

#### Link Collection Manager
```erb
<%= form_with model: @link_collection, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :title do %>
    <%= f.text_field :title, required: true %>
  <% end %>
  
  <%= f.field :links, hint: "Add multiple useful links" do %>
    <div data-controller="link-manager">
      <div data-link-manager-target="links">
        <% @link_collection.links.each_with_index do |link, index| %>
          <div data-link-manager-target="linkItem" class="space-y-2 p-4 border rounded-lg mb-4">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <%= f.text_field "links[#{index}][title]",
                  placeholder: "Link title",
                  class: "md:col-span-1" %>
              
              <%= f.url_field "links[#{index}][url]",
                  placeholder: "https://www.example.com",
                  class: "md:col-span-1",
                  data: {
                    controller: "url-preview",
                    url_preview_auto_title: true,
                    url_preview_title_field: "#link_collection_links_#{index}_title",
                    action: "blur->url-preview#fetchTitleForField"
                  } %>
            </div>
            
            <%= f.text_area "links[#{index}][description]",
                placeholder: "Optional description",
                rows: 2 %>
            
            <div class="flex justify-between items-center">
              <div data-url-preview-target="status" class="text-sm text-gray-500"></div>
              <button type="button" 
                      class="text-red-600 hover:text-red-800 text-sm"
                      data-action="link-manager#removeLink">
                Remove Link
              </button>
            </div>
          </div>
        <% end %>
      </div>
      
      <button type="button" 
              class="w-full py-2 border-2 border-dashed border-gray-300 rounded-lg text-gray-600 hover:border-gray-400 hover:text-gray-700"
              data-action="link-manager#addLink">
        + Add Another Link
      </button>
    </div>
  <% end %>
<% end %>
```

#### Project Repository Links
```erb
<%= form_with model: @project, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :repository_url, hint: "Link to your code repository" do %>
    <%= f.url_field :repository_url,
        placeholder: "https://github.com/user/repo",
        pattern: "https://(github\\.com|gitlab\\.com|bitbucket\\.org)/.+",
        data: {
          controller: "repo-url-validator",
          repo_url_validator_supported_hosts: ["github.com", "gitlab.com", "bitbucket.org"].to_json,
          action: "blur->repo-url-validator#validateRepository"
        } %>
    
    <div data-repo-url-validator-target="info" class="mt-2 text-sm hidden">
      <div class="p-3 bg-blue-50 rounded-lg">
        <div class="flex items-center space-x-2">
          <span data-repo-url-validator-target="platform" class="font-medium"></span>
          <span data-repo-url-validator-target="status" class="px-2 py-1 text-xs rounded-full"></span>
        </div>
        <div data-repo-url-validator-target="description" class="text-gray-600 mt-1"></div>
      </div>
    </div>
  <% end %>
  
  <%= f.field :demo_url, hint: "Live demo or preview URL" do %>
    <%= f.url_field :demo_url,
        placeholder: "https://your-project-demo.com",
        data: {
          controller: "demo-url-validator",
          action: "blur->demo-url-validator#checkAvailability"
        } %>
    
    <div data-demo-url-validator-target="status" class="mt-1 text-sm"></div>
  <% end %>
  
  <%= f.field :documentation_url do %>
    <%= f.url_field :documentation_url,
        placeholder: "https://docs.your-project.com (optional)" %>
  <% end %>
<% end %>
```

#### Resource Links Form
```erb
<%= form_with model: @tutorial, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :title do %>
    <%= f.text_field :title, required: true %>
  <% end %>
  
  <%= f.field_set do %>
    <h3>External Resources</h3>
    <p class="text-gray-600 mb-4">Add helpful links and resources</p>
    
    <%= f.field :official_docs_url do %>
      <%= f.url_field :official_docs_url,
          placeholder: "https://docs.example.com",
          data: {
            controller: "resource-validator",
            resource_validator_type: "documentation"
          } %>
      <span class="text-sm text-gray-500">Official documentation</span>
    <% end %>
    
    <%= f.field :tutorial_video_url do %>
      <%= f.url_field :tutorial_video_url,
          placeholder: "https://youtube.com/watch?v=...",
          pattern: "https://(www\\.)?(youtube\\.com/watch\\?v=|youtu\\.be/).+",
          data: {
            controller: "video-url-validator",
            video_url_validator_platforms: ["youtube", "vimeo"].to_json
          } %>
      <span class="text-sm text-gray-500">Tutorial video (YouTube/Vimeo)</span>
      
      <div data-video-url-validator-target="preview" class="mt-2 hidden">
        <div class="aspect-video bg-gray-100 rounded-lg flex items-center justify-center">
          <span class="text-gray-500">Video preview</span>
        </div>
      </div>
    <% end %>
    
    <%= f.field :example_code_url do %>
      <%= f.url_field :example_code_url,
          placeholder: "https://codepen.io/pen/...",
          data: {
            controller: "code-example-validator",
            code_example_validator_platforms: ["codepen", "jsfiddle", "codesandbox"].to_json
          } %>
      <span class="text-sm text-gray-500">Code example (CodePen, JSFiddle, etc.)</span>
    <% end %>
  <% end %>
<% end %>
```

#### Website Settings Form
```erb
<%= form_with model: @site_settings, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <h3>Site URLs</h3>
    
    <%= f.field :site_url do %>
      <%= f.url_field :site_url,
          placeholder: "https://www.yoursite.com",
          required: true,
          data: {
            controller: "site-url-validator",
            site_url_validator_check_ssl: true,
            action: "blur->site-url-validator#validateSite"
          } %>
      
      <div data-site-url-validator-target="sslStatus" class="mt-1 text-sm"></div>
    <% end %>
    
    <%= f.field :admin_url do %>
      <%= f.url_field :admin_url,
          placeholder: "https://admin.yoursite.com",
          data: {
            controller: "admin-url-validator",
            action: "blur->admin-url-validator#checkAccessibility"
          } %>
    <% end %>
    
    <%= f.field :api_base_url do %>
      <%= f.url_field :api_base_url,
          placeholder: "https://api.yoursite.com",
          pattern: "https://api\\..+",
          data: {
            controller: "api-url-validator",
            action: "blur->api-url-validator#testEndpoint"
          } %>
      
      <div data-api-url-validator-target="status" class="mt-1 text-sm"></div>
    <% end %>
    
    <%= f.field :cdn_url do %>
      <%= f.url_field :cdn_url,
          placeholder: "https://cdn.yoursite.com (optional)" %>
      <span class="text-sm text-gray-500">Content delivery network URL</span>
    <% end %>
  <% end %>
<% end %>
```

#### SEO and Analytics Form
```erb
<%= form_with model: @seo_settings, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field_set do %>
    <h3>SEO & Analytics</h3>
    
    <%= f.field :canonical_url do %>
      <%= f.url_field :canonical_url,
          placeholder: "https://www.yoursite.com",
          data: {
            controller: "canonical-url-validator",
            action: "blur->canonical-url-validator#validate"
          } %>
      <span class="text-sm text-gray-500">Preferred domain for search engines</span>
    <% end %>
    
    <%= f.field :sitemap_url do %>
      <%= f.url_field :sitemap_url,
          placeholder: "https://www.yoursite.com/sitemap.xml",
          pattern: "https://.+/sitemap\\.xml",
          data: {
            controller: "sitemap-validator",
            action: "blur->sitemap-validator#validateSitemap"
          } %>
      
      <div data-sitemap-validator-target="info" class="mt-1 text-sm"></div>
    <% end %>
    
    <%= f.field :robots_txt_url do %>
      <%= f.url_field :robots_txt_url,
          placeholder: "https://www.yoursite.com/robots.txt",
          pattern: "https://.+/robots\\.txt" %>
    <% end %>
    
    <%= f.field :google_search_console_url do %>
      <%= f.url_field :google_search_console_url,
          placeholder: "https://search.google.com/search-console?resource_id=...",
          pattern: "https://search\\.google\\.com/search-console.+" %>
    <% end %>
  <% end %>
<% end %>
```