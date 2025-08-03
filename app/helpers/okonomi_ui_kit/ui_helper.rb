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

        component_name.constantize.new(@template)
      end

      def forms
        @forms ||= self.class.new(@template, namespace: OkonomiUiKit::Components::Forms)
      end
    end
  end
end
