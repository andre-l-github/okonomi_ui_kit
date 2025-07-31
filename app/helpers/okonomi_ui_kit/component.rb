module OkonomiUiKit
  class Component
    attr_reader :view, :theme

    def initialize(view, theme)
      @view = view
      @theme = theme || OkonomiUiKit::Theme::DEFAULT_THEME
    end

    def template_path
      "okonomi/components/#{name}/#{name}"
    end

    def name
      self.class.name.demodulize.underscore
    end
  end
end
