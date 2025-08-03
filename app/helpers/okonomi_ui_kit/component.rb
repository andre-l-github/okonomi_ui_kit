module OkonomiUiKit
  class Component
    attr_reader :view

    def initialize(view)
      @view = view
    end

    def template_path
      [ self.class.name.underscore.gsub("okonomi_ui_kit/", "okonomi/"), name ].join("/")
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

      deep_merge({}, internal_styles, config_styles)
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

    def self.register_styles(theme = :default, &block)
      styles = block.call if block_given?

      raise ArgumentError, "Styles must be a Hash" unless styles.is_a?(Hash)

      internal_styles_registry[theme] ||= {}
      internal_styles_registry[theme] = deep_merge(internal_styles_registry[theme], styles)
    end

    def self.internal_styles_registry
      @internal_styles_registry ||= deep_merge({}, parent_styles_registry)
    end

    def self.parent_styles_registry
      if superclass.respond_to?(:internal_styles_registry)
        superclass.internal_styles_registry
      else
        {}
      end
    end

    def self.config_styles_registry
      @config_styles_registry ||= config_classes.reverse.reduce({}) do |hash, klass|
        deep_merge(hash, klass.styles_registry)
      end
    end

    def self.config_classes
      @config_classes ||= resolve_config_classes
    end

    def self.resolve_config_classes
      classes = []
      classes << Object.const_get(config_class_name) if config_class?
      classes += superclass.config_classes if superclass <= OkonomiUiKit::Component

      classes.compact
    end

    def self.config_class_name
      "#{config_namespace.name}::#{name.demodulize}"
    end

    def self.config_namespace
      OkonomiUiKit::Configs
    end

    def self.config_class?
      Object.const_defined?(config_class_name)
    end

    def self.deep_merge(*hashes)
      OkonomiUiKit::TWMerge.deep_merge_all(*hashes)
    end
    delegate :deep_merge, to: :class
  end
end
