module OkonomiUiKit
  module Components
    class Alert < OkonomiUiKit::Component
      def render(title, options = {}, &block)
        view.render(template_path, title:, options: options.with_indifferent_access, &block)
      end
    end
  end
end
