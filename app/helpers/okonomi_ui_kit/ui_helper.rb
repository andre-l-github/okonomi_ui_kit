module OkonomiUiKit
  module UiHelper
    def ui
      @ui ||= UiBuilder.new(self)
    end

    class UiBuilder
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::CaptureHelper

      attr_reader :template, :namespace

      def initialize(template, namespace: OkonomiUiKit::Components)
        @template = template
        @namespace = namespace
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

      def button_class(variant: "contained", color: "default", classes: "")
        [
          get_theme.dig(:components, :link, :root) || "",
          get_theme.dig(:components, :link, variant.to_sym, :root) || "",
          get_theme.dig(:components, :link, variant.to_sym, :colors, color.to_sym) || "",
          classes
        ].compact.join(" ")
      end


      def method_missing(method_name, *args, &block)
        component = resolve_component(method_name)

        if component
          component.render(*args, &block)
        else
          super
        end
      end

      def resolve_component(name)
        component_name = "#{namespace.name}::#{name.to_s.camelize}"

        return nil unless Object.const_defined?(component_name)

        component_name.constantize.new(@template, get_theme)
      end

      def forms
        @forms ||= self.class.new(@template, namespace: OkonomiUiKit::Components::Forms)
      end
    end
  end
end
