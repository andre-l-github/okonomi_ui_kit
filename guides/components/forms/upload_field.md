# UploadField Component Guide

The UploadField component provides a drag-and-drop file upload interface with preview capabilities, progress tracking, and multiple file type support.

## Basic Usage

#### Simple File Upload
```erb
<%= form_with model: @user, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :avatar do %>
    <%= f.upload_field :avatar %>
  <% end %>
<% end %>
```

#### With File Type Restrictions
```erb
<%= f.upload_field :document, accept: ".pdf,.docx,.txt" %>
```

#### Multiple File Upload
```erb
<%= f.upload_field :attachments, multiple: true %>
```

## Customization Options

| Option | Type | Purpose |
|--------|------|---------|
| accept | String | Accepted file types (e.g., ".jpg,.png", "image/*") |
| multiple | Boolean | Allow multiple file selection |
| required | Boolean | Mark field as required |
| disabled | Boolean | Disable the upload field |
| class | String | Additional CSS classes |
| data | Hash | Data attributes for JavaScript |

## Advanced Features

#### Image Upload with Preview
```erb
<%= f.upload_field :profile_image,
    accept: "image/*",
    data: {
      controller: "image-upload",
      image_upload_max_size: 5.megabytes,
      image_upload_preview: true
    } %>
```

#### Document Upload with Validation
```erb
<%= f.upload_field :resume,
    accept: ".pdf,.doc,.docx",
    data: {
      controller: "document-upload",
      document_upload_max_size: 10.megabytes,
      document_upload_allowed_types: ["pdf", "doc", "docx"].to_json
    } %>
```

#### Progress Tracking
```erb
<%= f.upload_field :large_file,
    data: {
      controller: "upload-progress",
      upload_progress_endpoint: upload_progress_path
    } %>

<div data-upload-progress-target="progress" class="hidden mt-2">
  <div class="w-full bg-gray-200 rounded-full h-2">
    <div data-upload-progress-target="bar" 
         class="bg-blue-600 h-2 rounded-full transition-all duration-300" 
         style="width: 0%"></div>
  </div>
  <div class="text-sm text-gray-600 mt-1">
    <span data-upload-progress-target="percentage">0%</span> uploaded
  </div>
</div>
```

#### Batch Upload with Management
```erb
<%= f.upload_field :gallery_images,
    multiple: true,
    accept: "image/*",
    data: {
      controller: "batch-upload",
      batch_upload_max_files: 10,
      batch_upload_max_size_per_file: 5.megabytes
    } %>

<div data-batch-upload-target="queue" class="mt-4 space-y-2">
  <!-- Upload queue will appear here -->
</div>
```

#### Cloud Upload Integration
```erb
<%= f.upload_field :backup_file,
    data: {
      controller: "cloud-upload",
      cloud_upload_provider: "s3",
      cloud_upload_direct: true,
      cloud_upload_presigned_url: presigned_upload_url
    } %>
```

## Styling

#### Default Styles

The UploadField component includes these style classes:
- Dropzone: `border-2 border-dashed border-gray-300 rounded-md p-6 text-center cursor-pointer hover:bg-gray-50 relative`
- Label: `block cursor-pointer`
- Content: `flex flex-col items-center text-gray-600 space-y-2`
- Preview: `w-full flex justify-center items-center`
- Preview Image: `max-h-32`
- Icon: `size-12 text-gray-400`
- Filename: `text-sm text-gray-500`
- File Input: `hidden`
- Clear Button: `absolute top-2 right-2 bg-red-100 text-red-700 px-2 py-1 text-xs rounded hover:bg-red-200`

#### Customizing Styles

Override the default styles in your configuration:

```ruby
# In your initializer
module OkonomiUiKit
  module Components
    module Forms
      class UploadField
        register_styles :custom do
          {
            dropzone: "border-3 border-dashed border-blue-300 rounded-lg p-8 bg-blue-50",
            label: "block cursor-pointer",
            content: "flex flex-col items-center text-blue-600 space-y-3",
            preview: "w-full flex justify-center items-center p-4",
            preview_image: "max-h-40 rounded-lg shadow-md",
            icon: "w-16 h-16 text-blue-400",
            filename: "text-sm text-blue-700 font-medium",
            file_input: "sr-only",
            clear_button: "absolute top-3 right-3 bg-red-500 text-white px-3 py-1 text-sm rounded-full hover:bg-red-600"
          }
        end
      end
    end
  end
end
```

Or use runtime theme switching:

```erb
<% ui.theme(components: { forms: { upload_field: { 
  dropzone: "border-green-300 bg-green-50",
  content: "text-green-600"
} } }) do %>
  <%= f.upload_field :file %>
<% end %>
```

## Best Practices

1. **File Type Validation**: Always validate file types on both client and server
2. **Size Limits**: Set appropriate file size limits
3. **Progress Feedback**: Show upload progress for large files
4. **Error Handling**: Provide clear error messages for upload failures
5. **Security**: Validate and sanitize uploaded files
6. **Accessibility**: Ensure keyboard accessibility and screen reader support

## Accessibility

The UploadField component ensures accessibility by:
- Using semantic HTML input elements
- Supporting keyboard navigation (Tab, Enter, Space)
- Providing clear label associations
- Including proper ARIA attributes
- Working with screen readers
- Supporting drag-and-drop with keyboard alternatives
- Showing visual focus indicators
- Announcing upload status changes

## Examples

#### Profile Image Upload
```erb
<%= form_with model: @user, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :profile_image, hint: "Upload a profile picture (JPG, PNG, max 5MB)" do %>
    <div class="max-w-sm mx-auto">
      <%= f.upload_field :profile_image,
          accept: "image/jpeg,image/png,image/webp",
          data: {
            controller: "profile-image-upload",
            profile_image_upload_max_size: 5.megabytes,
            profile_image_upload_min_dimensions: "200x200",
            profile_image_upload_crop: true
          } %>
      
      <div data-profile-image-upload-target="crop" class="hidden mt-4">
        <h4 class="font-medium mb-2">Crop your image:</h4>
        <div data-profile-image-upload-target="cropper" class="border rounded-lg"></div>
        <div class="flex justify-center space-x-2 mt-4">
          <button type="button" 
                  class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700"
                  data-action="profile-image-upload#applyCrop">
            Apply Crop
          </button>
          <button type="button" 
                  class="px-4 py-2 bg-gray-300 text-gray-700 rounded hover:bg-gray-400"
                  data-action="profile-image-upload#cancelCrop">
            Cancel
          </button>
        </div>
      </div>
    </div>
  <% end %>
<% end %>
```

#### Document Upload System
```erb
<%= form_with model: @document, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :title do %>
    <%= f.text_field :title, required: true %>
  <% end %>
  
  <%= f.field :category do %>
    <%= f.select :category, [
      ['Contract', 'contract'],
      ['Invoice', 'invoice'],
      ['Report', 'report'],
      ['Other', 'other']
    ], { prompt: 'Select document type' } %>
  <% end %>
  
  <%= f.field :file, hint: "Supported formats: PDF, DOC, DOCX (max 25MB)" do %>
    <%= f.upload_field :file,
        accept: ".pdf,.doc,.docx",
        required: true,
        data: {
          controller: "document-upload-validator",
          document_upload_validator_max_size: 25.megabytes,
          document_upload_validator_allowed_types: ["pdf", "doc", "docx"].to_json
        } %>
    
    <div data-document-upload-validator-target="validation" class="mt-2 text-sm">
      <!-- Validation messages appear here -->
    </div>
    
    <div data-document-upload-validator-target="metadata" class="mt-2 text-sm text-gray-600 hidden">
      <div>File size: <span data-document-upload-validator-target="fileSize"></span></div>
      <div>Last modified: <span data-document-upload-validator-target="lastModified"></span></div>
    </div>
  <% end %>
<% end %>
```

#### Gallery Upload with Management
```erb
<%= form_with model: @gallery, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :images, hint: "Upload multiple images for your gallery (JPG, PNG, WebP)" do %>
    <%= f.upload_field :images,
        multiple: true,
        accept: "image/*",
        data: {
          controller: "gallery-upload",
          gallery_upload_max_files: 20,
          gallery_upload_max_size_per_file: 10.megabytes,
          gallery_upload_generate_thumbnails: true
        } %>
    
    <div data-gallery-upload-target="queue" class="mt-4 space-y-3">
      <!-- Upload queue with thumbnails -->
    </div>
    
    <div data-gallery-upload-target="uploaded" class="mt-6">
      <h4 class="font-medium mb-3">Uploaded Images:</h4>
      <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
        <!-- Uploaded images grid -->
      </div>
    </div>
  <% end %>
<% end %>
```

#### Resume Upload with Parsing
```erb
<%= form_with model: @job_application, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :resume, hint: "Upload your resume (PDF preferred, max 10MB)" do %>
    <%= f.upload_field :resume,
        accept: ".pdf,.doc,.docx",
        required: true,
        data: {
          controller: "resume-upload",
          resume_upload_parse_url: parse_resume_path,
          resume_upload_max_size: 10.megabytes
        } %>
    
    <div data-resume-upload-target="parsing" class="hidden mt-4 p-4 bg-blue-50 rounded-lg">
      <div class="flex items-center space-x-2">
        <div class="animate-spin rounded-full h-4 w-4 border-b-2 border-blue-600"></div>
        <span class="text-blue-700">Parsing resume...</span>
      </div>
    </div>
    
    <div data-resume-upload-target="parsed" class="hidden mt-4 p-4 bg-green-50 rounded-lg">
      <h4 class="font-medium text-green-800 mb-2">Parsed Information:</h4>
      <div data-resume-upload-target="extractedData" class="text-sm text-green-700">
        <!-- Parsed resume data will appear here -->
      </div>
    </div>
  <% end %>
  
  <!-- These fields may be auto-filled from resume parsing -->
  <%= f.field :name do %>
    <%= f.text_field :name, 
        data: { resume_upload_target: "nameField" } %>
  <% end %>
  
  <%= f.field :email do %>
    <%= f.email_field :email, 
        data: { resume_upload_target: "emailField" } %>
  <% end %>
  
  <%= f.field :phone do %>
    <%= f.telephone_field :phone, 
        data: { resume_upload_target: "phoneField" } %>
  <% end %>
<% end %>
```

#### Bulk File Upload with Progress
```erb
<%= form_with model: @batch_upload, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :files, hint: "Upload multiple files (any type, max 100MB per file)" do %>
    <%= f.upload_field :files,
        multiple: true,
        data: {
          controller: "bulk-upload",
          bulk_upload_max_files: 50,
          bulk_upload_max_size_per_file: 100.megabytes,
          bulk_upload_concurrent_uploads: 3,
          bulk_upload_chunk_size: 5.megabytes
        } %>
    
    <div data-bulk-upload-target="queue" class="mt-4 space-y-2">
      <!-- File upload queue -->
    </div>
    
    <div data-bulk-upload-target="overall" class="mt-4 p-4 bg-gray-50 rounded-lg hidden">
      <div class="flex justify-between items-center mb-2">
        <span class="font-medium">Overall Progress</span>
        <span data-bulk-upload-target="overallPercentage">0%</span>
      </div>
      <div class="w-full bg-gray-200 rounded-full h-3">
        <div data-bulk-upload-target="overallBar" 
             class="bg-green-600 h-3 rounded-full transition-all duration-300" 
             style="width: 0%"></div>
      </div>
      <div class="text-sm text-gray-600 mt-2">
        <span data-bulk-upload-target="completedCount">0</span> of 
        <span data-bulk-upload-target="totalCount">0</span> files uploaded
      </div>
    </div>
  <% end %>
<% end %>
```

#### Avatar Upload with Crop and Filters
```erb
<%= form_with model: @user, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :avatar, hint: "Upload and customize your avatar" do %>
    <div class="max-w-md mx-auto">
      <%= f.upload_field :avatar,
          accept: "image/*",
          data: {
            controller: "avatar-editor",
            avatar_editor_crop_aspect: "1:1",
            avatar_editor_min_size: 150,
            avatar_editor_filters: true
          } %>
      
      <div data-avatar-editor-target="editor" class="hidden mt-4 space-y-4">
        <div class="border rounded-lg p-4">
          <div data-avatar-editor-target="cropArea" class="bg-gray-100 rounded-lg h-64"></div>
        </div>
        
        <div class="space-y-3">
          <div>
            <label class="block text-sm font-medium mb-1">Brightness</label>
            <input type="range" min="0" max="200" value="100" 
                   class="w-full"
                   data-avatar-editor-target="brightnessSlider"
                   data-action="input->avatar-editor#adjustBrightness">
          </div>
          
          <div>
            <label class="block text-sm font-medium mb-1">Contrast</label>
            <input type="range" min="0" max="200" value="100" 
                   class="w-full"
                   data-avatar-editor-target="contrastSlider"
                   data-action="input->avatar-editor#adjustContrast">
          </div>
          
          <div>
            <label class="block text-sm font-medium mb-1">Saturation</label>
            <input type="range" min="0" max="200" value="100" 
                   class="w-full"
                   data-avatar-editor-target="saturationSlider"
                   data-action="input->avatar-editor#adjustSaturation">
          </div>
        </div>
        
        <div class="flex justify-center space-x-3">
          <button type="button" 
                  class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700"
                  data-action="avatar-editor#saveAvatar">
            Save Avatar
          </button>
          <button type="button" 
                  class="px-4 py-2 bg-gray-300 text-gray-700 rounded hover:bg-gray-400"
                  data-action="avatar-editor#resetEditor">
            Reset
          </button>
        </div>
      </div>
    </div>
  <% end %>
<% end %>
```

#### File Upload with Virus Scanning
```erb
<%= form_with model: @secure_upload, builder: OkonomiUiKit::FormBuilder do |f| %>
  <%= f.field :secure_file, hint: "All files are scanned for security" do %>
    <%= f.upload_field :secure_file,
        data: {
          controller: "secure-upload",
          secure_upload_scan_endpoint: virus_scan_path,
          secure_upload_max_size: 50.megabytes
        } %>
    
    <div data-secure-upload-target="scanning" class="hidden mt-4 p-4 bg-yellow-50 rounded-lg">
      <div class="flex items-center space-x-2">
        <div class="animate-spin rounded-full h-4 w-4 border-b-2 border-yellow-600"></div>
        <span class="text-yellow-700">Scanning file for security threats...</span>
      </div>
    </div>
    
    <div data-secure-upload-target="scanResult" class="mt-4 p-4 rounded-lg hidden">
      <div data-secure-upload-target="scanMessage"></div>
    </div>
  <% end %>
<% end %>
```