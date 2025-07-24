module OkonomiUiKit
  class FormBuilder < ActionView::Helpers::FormBuilder
  delegate :tag, :content_tag, :safe_join, to: :@template

  def field_set(options = {}, &block)
    @template.render('okonomi_ui_kit/forms/tailwind/field_set', options:, form: self, &block)
  end

  def field(field_id = nil, options = {}, &block)
    @template.render('okonomi_ui_kit/forms/tailwind/field', field_id:, options:, form: self, &block)
  end

  def upload_field(method, options = {})
    @template.render('okonomi_ui_kit/forms/tailwind/upload_field', method:, options:, form: self)
  end

  def text_field(method, options = {})
    css = input_field_classes(method, options, focus_ring: 'focus-within:ring-0.5')
    super(method, { autocomplete: "off" }.merge(options).merge(class: css))
  end

  def email_field(method, options = {})
    css = input_field_classes(method, options)
    super(method, options.merge(class: css))
  end

  def url_field(method, options = {})
    css = input_field_classes(method, options)
    super(method, options.merge(class: css))
  end

  def password_field(method, options = {})
    css = input_field_classes(method, options)
    super(method, options.merge(class: css))
  end

  def number_field(method, options = {})
    css = input_field_classes(method, options)
    super(method, options.merge(class: css))
  end

  def telephone_field(method, options = {})
    css = input_field_classes(method, options)
    super(method, options.merge(class: css))
  end

  def search_field(method, options = {})
    css = input_field_classes(method, options)
    super(method, options.merge(class: css))
  end

  def date_field(method, options = {})
    css = input_field_classes(method, options)
    super(method, options.merge(class: css))
  end

  def datetime_local_field(method, options = {})
    css = input_field_classes(method, options)
    super(method, options.merge(class: css))
  end

  def time_field(method, options = {})
    css = input_field_classes(method, options)
    super(method, options.merge(class: css))
  end

  def text_area(method, options = {})
    css = input_field_classes(method, options, include_disabled: false)
    super(method, options.merge(class: css))
  end

  def select(method, choices = nil, options = {}, html_options = {}, &block)
    css = [
      select_class_base,
      when_errors(method,
                  'bg-red-100 text-red-600 ring-1 ring-inset ring-red-300 focus-within:ring-2 focus-within:ring-red-400',
                  select_class_default_state),
      html_options[:class]
    ].compact.join(' ').split(' ').uniq
    super(method, choices, options, html_options.merge(class: css), &block)
  end

  def collection_select(method, collection, value_method, text_method, options = {}, html_options = {})
    css = [
      select_class_base,
      when_errors(method,
                  'bg-red-100 text-red-600 ring-1 ring-inset ring-red-300 focus-within:ring-2 focus-within:ring-red-400',
                  select_class_default_state),
      html_options[:class]
    ].compact.join(' ').split(' ').uniq
    super(method, collection, value_method, text_method, options, html_options.merge(class: css))
  end

  def select_class_default
    [select_class_base, select_class_default_state].join(' ')
  end

  def select_class_base
    "col-start-1 row-start-1 w-full rounded-md bg-white py-2 pr-8 pl-3 text-base text-gray-900 outline-1 -outline-offset-1 outline-gray-300 focus:outline-2 focus:-outline-offset-2 focus:outline-primary-600 sm:text-sm/6"
  end

  def select_class_default_state
    'ring-1 ring-inset ring-gray-300 focus-within:ring-2 focus-within:ring-gray-400'
  end

  def label(method, text = nil, options = {}, &block)
    base_classes = "block text-sm/6 font-medium text-gray-900"
    super(method, text, merge_class(options, base_classes), &block)
  end

  def submit(value = nil, options = {})
    base_classes = "inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
    super(value, merge_class(options, base_classes))
  end

  def label_class(label_css = nil)
    ["block text-base font-medium leading-6 text-gray-900 whitespace-nowrap", label_css].compact_blank.join(' ')
  end

  def check_box_with_label(method, options = {}, checked_value = true, unchecked_value = false)
    @template.content_tag(:div, class: 'flex gap-2 items-center') do
      @template.concat check_box(
                         method,
                         {
                           class: 'cursor-pointer h-4 w-4 rounded-sm border-gray-300 text-primary-600 focus:ring-0 focus:ring-primary-600'
                         }.merge(options || {}),
                         checked_value,
                         unchecked_value
                       )
      @template.concat @template.render('okonomi_ui_kit/forms/tailwind/checkbox_label', method:, options:, form: self)
    end
  end

  def multi_select(method, **options)
    @template.render(
      partial: 'okonomi_ui_kit/forms/tailwind/multi_select',
      locals: {
        form: self,
        method: method,
        options: options
      }
    )
  end

  def show_if(field:, equals:, &block)
    field_id = "#{object_name}_#{field}"
    @template.tag.div(
      class: "hidden",
      data: {
        controller: "form-field-visibility",
        "form-field-visibility-field-id-value": field_id,
        "form-field-visibility-equals-value": equals
      },
      &block
    )
  end

  private

  def input_field_classes(method, options, focus_ring: 'focus-within:ring-1', include_disabled: true)
    css_classes = [
      'w-full border-0 text-gray-700 px-3 py-2 rounded-md',
      "ring-1 ring-inset ring-gray-300 #{focus_ring} focus-within:ring-gray-400",
      when_errors(method, 'bg-red-100 ring-2 ring-red-400'),
      options[:class]
    ]
    
    if include_disabled
      css_classes << 'disabled:bg-gray-50 disabled:cursor-not-allowed'
    end
    
    css_classes.compact.join(' ').split(' ').uniq
  end

  def when_errors(method, value, default_value = nil)
    key = method.to_s.gsub('_id', '').to_sym
    if object.errors.include?(key) || object.errors.include?(method)
      value
    else
      default_value
    end
  end

  def merge_class(options, new_class)
    options[:class] = [options[:class], new_class].compact.join(" ")
    options
  end
  end
end
