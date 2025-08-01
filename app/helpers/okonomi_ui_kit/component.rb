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

    def style(*args)
      styles.dig(*args)
    end

    def styles
      @combined_styles ||= combined_styles
    end

    def combined_styles
      internal_name = internal_styles_registry.has_key?(theme_name) ? theme_name : :default
      config_name = config_styles_registry.has_key?(theme_name) ? theme_name : :default

      internal_styles = internal_styles_registry[internal_name] || {}
      config_styles = config_styles_registry[config_name] || {}

      {}.deep_merge(internal_styles).deep_merge(config_styles)
    end

    def internal_styles_registry
      self.class.internal_styles_registry
    end

    def config_styles_registry
      self.class.config_styles_registry
    end

    def theme_name
      :default
    end

    def self.config_styles_registry
      return Hash.new({}) unless config_class?

      config_class.styles_registry
    end

    def self.config_class
      return nil unless config_class?

      Object.const_get(config_class_name)
    end

    def self.config_class_name
      "OkonomiUiKit::Configs::#{name.demodulize}"
    end

    def self.config_class?
      Object.const_defined?(config_class_name)
    end

    def self.register_styles(theme = :default, &block)
      styles = block.call if block_given?

      raise ArgumentError, "Styles must be a Hash" unless styles.is_a?(Hash)

      internal_styles_registry[theme] = styles if styles.is_a?(Hash)
    end

    def self.internal_styles_registry
      @internal_styles_registry ||= {}
    end
  end
end
