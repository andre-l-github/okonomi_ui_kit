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

      TYPOGRAPHY_COMPONENTS = {
        body1: 'p',
        body2: 'p',
        h1: 'h1',
        h2: 'h2',
        h3: 'h3',
        h4: 'h4',
        h5: 'h5',
        h6: 'h6',
      }.freeze

      def typography(text = nil, options = nil, &block)
        options, text = text, nil if block_given?
        options ||= {}

        variant = (options.delete(:variant) || 'body1').to_sym
        component = (TYPOGRAPHY_COMPONENTS[variant] || 'span').to_s
        color = (options.delete(:color) || 'default').to_sym
        classes = [
          get_theme.dig(:components, :typography, :variants, variant) || '',
          get_theme.dig(:components, :typography, :colors, color) || '',
          options.delete(:class) || ''
        ]

        if block_given?
          @template.render("okonomi/components/typography", options:, variant:, component:, classes:, &block)
        else
          @template.render("okonomi/components/typography", text:, options:, variant:, component:, classes:)
        end
      end
    end
  end
end