module OkonomiUiKit
  module UiHelper
    def ui
      @ui ||= UiBuilder.new(self)
    end

    class UiBuilder
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::CaptureHelper

      def initialize(template)
        @template = template
      end

      def theme(t = {}, &block)
        old_theme = get_theme

        @_okonomi_ui_kit_theme = {}.merge(old_theme).merge(t || {})

        yield(@_okonomi_ui_kit_theme)

        @_okonomi_ui_kit_theme = old_theme
      end

      def get_theme
        @_okonomi_ui_kit_theme ||= OkonomiUiKit::Theme::DEFAULT_THEME
      end

      def link_to(name = nil, options = nil, html_options = nil, &block)
        html_options, options, name = options, name, block if block_given?

        html_options ||= {}
        html_options[:class] ||= ''

        variant = (html_options.delete(:variant) || 'text').to_sym
        color = (html_options.delete(:color) || 'default').to_sym

        html_options[:class] = button_class(variant:, color:, classes: html_options[:class])

        if block_given?
          @template.link_to(options, html_options, &block)
        else
          @template.link_to(name, options, html_options)
        end
      end

      def button_to(name = nil, options = nil, html_options = nil, &block)
        html_options, options, name = options, name, block if block_given?

        html_options ||= {}
        html_options[:class] ||= ''

        variant = (html_options.delete(:variant) || 'contained').to_sym
        color = (html_options.delete(:color) || 'default').to_sym

        html_options[:class] = button_class(variant:, color:, classes: html_options[:class])

        if block_given?
          @template.button_to(options, html_options, &block)
        else
          @template.button_to(name, options, html_options)
        end
      end

      def button_class(variant: 'contained', color: 'default', classes: '')
        [
          get_theme.dig(:components, :link, :root) || '',
          get_theme.dig(:components, :link, variant.to_sym, :root) || '',
          get_theme.dig(:components, :link, variant.to_sym, :colors, color.to_sym) || '',
          classes,
        ].join(' ')
      end

      def page(&block)
        @template.page(&block)
      end

      def confirmation_modal(title:, message:, confirm_text: "Confirm", cancel_text: "Cancel", variant: :warning, size: :md, **options, &block)
        modal_options = {
          title: title,
          message: message, 
          confirm_text: confirm_text,
          cancel_text: cancel_text,
          variant: variant,
          size: size,
          has_custom_actions: block_given?,
          **options
        }
        @template.render("okonomi/modals/confirmation_modal", options: modal_options, ui: self, &block)
      end

      def modal_data_attributes(options)
        return "" unless options[:data]
        
        options[:data].map { |k, v| "data-#{k.to_s.dasherize}=\"#{v}\"" }.join(' ').html_safe
      end

      def modal_panel_class(size)
        [
          get_theme.dig(:components, :modal, :panel, :base),
          get_theme.dig(:components, :modal, :panel, :sizes, size)
        ].compact.join(' ')
      end

      def modal_icon_wrapper_class(variant)
        [
          get_theme.dig(:components, :modal, :icon, :wrapper),
          get_theme.dig(:components, :modal, :icon, :variants, variant, :wrapper)
        ].compact.join(' ')
      end

      def method_missing(method_name, *args, &block)
        component_name = "OkonomiUiKit::Components::#{method_name.to_s.camelize}"
        if Object.const_defined?(component_name)
          return component_name.constantize.new(@template, get_theme).render(*args, &block)
        else
          super
        end
      end
    end
  end
end
