module OkonomiUiKit
  class FormBuilder < ActionView::Helpers::FormBuilder
    delegate :tag, :content_tag, :safe_join, to: :@template

    def ui
      @template.ui
    end

    def field_set(options = {}, &block)
      ui.forms.field_set(self, options, &block)
    end

    def field(field_id = nil, options = {}, &block)
      ui.forms.field(self, field_id, options, &block)
    end

    def upload_field(method, options = {})
      ui.forms.upload_field(self, method, options)
    end

    def text_field(method, options = {})
      super(*resolve_arguments(:text_field, method, options))
    end

    def email_field(method, options = {})
      super(*resolve_arguments(:email_field, method, options))
    end

    def url_field(method, options = {})
      super(*resolve_arguments(:url_field, method, options))
    end

    def resolve_arguments(component_name, *args)
      component = ui.forms.resolve_component(component_name)

      if component.nil?
        args
      else
        component.render_arguments(object, *args)
      end
    end

    def password_field(method, options = {})
      super(*resolve_arguments(:password_field, method, options))
    end

    def number_field(method, options = {})
      super(*resolve_arguments(:number_field, method, options))
    end

    def telephone_field(method, options = {})
      super(*resolve_arguments(:telephone_field, method, options))
    end

    def search_field(method, options = {})
      super(*resolve_arguments(:search_field, method, options))
    end

    def date_field(method, options = {})
      super(*resolve_arguments(:date_field, method, options))
    end

    def datetime_local_field(method, options = {})
      super(*resolve_arguments(:datetime_local_field, method, options))
    end

    def time_field(method, options = {})
      super(*resolve_arguments(:time_field, method, options))
    end

    def text_area(method, options = {})
      super(*resolve_arguments(:text_area, method, options))
    end

    def select(method, choices = nil, options = {}, html_options = {}, &block)
      ui.forms.select(self, method, choices, options, html_options, &block)
    end

    def collection_select(method, collection, value_method, text_method, options = {}, html_options = {})
      ui.forms.collection_select(self, method, collection, value_method, text_method, options, html_options)
    end

    def multi_select(method, **options)
      ui.forms.multi_select(self, method, options)
    end

    def label(method, text = nil, options = {}, &block)
      ui.forms.label(self, method, text, options, &block)
    end

    def submit(value = nil, options = {})
      value, options = nil, value if value.is_a?(Hash)
      value ||= submit_default_value

      options ||= {}
      options[:type] = "submit"
      options[:variant] ||= "contained"
      options[:color] ||= "primary"

      ui.button_tag(value, options)
    end

    def check_box_with_label(method, options = {}, checked_value = true, unchecked_value = false)
      ui.forms.check_box_with_label(self, method, options, checked_value, unchecked_value)
    end

    def show_if(field:, equals:, &block)
      ui.forms.show_if(self, field: field, equals: equals, &block)
    end

    private

    def merge_class(options, new_class)
      options[:class] = OkonomiUiKit::TWMerge.merge(options[:class] || "", new_class)
      options
    end
  end
end
