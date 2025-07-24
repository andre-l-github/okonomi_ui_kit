module OkonomiUiKit
  class FormBuilder < ActionView::Helpers::FormBuilder
    delegate :tag, :content_tag, :safe_join, to: :@template

    def ui
      @template.ui
    end

    def field_set(options = {}, &block)
      @template.render('okonomi/forms/tailwind/field_set', options:, form: self, &block)
    end

    def field(field_id = nil, options = {}, &block)
      @template.render('okonomi/forms/tailwind/field', field_id:, options:, form: self, &block)
    end

    def upload_field(method, options = {})
      @template.render('okonomi/forms/tailwind/upload_field', method:, options:, form: self)
    end

    def text_field(method, options = {})
      css = input_field_classes(method, :text, options)
      super(method, { autocomplete: "off" }.merge(options).merge(class: css))
    end

    def email_field(method, options = {})
      css = input_field_classes(method, :email, options)
      super(method, options.merge(class: css))
    end

    def url_field(method, options = {})
      css = input_field_classes(method, :url, options)
      super(method, options.merge(class: css))
    end

    def password_field(method, options = {})
      css = input_field_classes(method, :password, options)
      super(method, options.merge(class: css))
    end

    def number_field(method, options = {})
      css = input_field_classes(method, :number, options)
      super(method, options.merge(class: css))
    end

    def telephone_field(method, options = {})
      css = input_field_classes(method, :telephone_field, options)
      super(method, options.merge(class: css))
    end

    def search_field(method, options = {})
      css = input_field_classes(method, :search, options)
      super(method, options.merge(class: css))
    end

    def date_field(method, options = {})
      css = input_field_classes(method, :date, options)
      super(method, options.merge(class: css))
    end

    def datetime_local_field(method, options = {})
      css = input_field_classes(method, :datetime_local, options)
      super(method, options.merge(class: css))
    end

    def time_field(method, options = {})
      css = input_field_classes(method, :time, options)
      super(method, options.merge(class: css))
    end

    def text_area(method, options = {})
      css = input_field_classes(method, :textarea, options, include_disabled: false)
      super(method, options.merge(class: css))
    end

    def select(method, choices = nil, options = {}, html_options = {}, &block)
      css = [
        ui.get_theme.dig(:components, :select, :root),
        when_errors(
          method,
          ui.get_theme.dig(:components, :select, :error),
          ui.get_theme.dig(:components, :select, :valid)
        ),
        html_options[:class]
      ].compact.join(' ').split(' ').uniq

      select_html = super(method, choices, options, html_options.merge(class: css), &block)
      icon_html = @template.svg_icon(
        ui.get_theme.dig(:components, :select, :icon, :file),
        class: ui.get_theme.dig(:components, :select, :icon, :class)
      )

      @template.content_tag(:div, class: ui.get_theme.dig(:components, :select, :wrapper)) do
        @template.concat(select_html)
        @template.concat(icon_html)
      end
    end

    def collection_select(method, collection, value_method, text_method, options = {}, html_options = {})
      css = [
        select_class_base,
        when_errors(method,
                    'bg-danger-100 text-danger-600 ring-1 ring-inset ring-danger-300 focus-within:ring-2 focus-within:ring-danger-400',
                    select_class_default_state),
        html_options[:class]
      ].compact.join(' ').split(' ').uniq

      select_html = super(method, collection, value_method, text_method, options, html_options.merge(class: css))

      @template.content_tag(:div, class: "mt-2 grid grid-cols-1") do
        @template.concat(select_html)
        @template.concat(@template.ui.svg_icon(
          'chevron-down',
          class: "pointer-events-none col-start-1 row-start-1 mr-2 size-5 self-center justify-self-end text-gray-500 sm:size-4"
        ))
      end
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
      variant = options.delete(:variant) || 'contained'
      color = options.delete(:color) || 'primary'

      base_classes = ui.button_class(variant:, color:)
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
        @template.concat @template.render('okonomi/forms/tailwind/checkbox_label', method:, options:, form: self)
      end
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

    def input_field_classes(method, type, options, include_disabled: true)
      css_classes = [
        ui.get_theme.dig(:components, :input, :types, type, :root) || ui.get_theme.dig(:components, :input, :types, :text, :root),
        when_errors(
          method,
          ui.get_theme.dig(:components, :input, :types, type, :error) || ui.get_theme.dig(:components, :input, :types, :text, :error),
          ui.get_theme.dig(:components, :input, :types, type, :valid) || ui.get_theme.dig(:components, :input, :types, :text, :valid)
        ),
        options[:class]
      ]

      if include_disabled
        css_classes << (
          ui.get_theme.dig(:components, :input, :types, type, :disabled) || ui.get_theme.dig(:components, :input, :types, :text, :disabled)
        )
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
