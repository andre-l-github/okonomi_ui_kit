module OkonomiUiKit
  class Config
    def self.register_styles(theme = :default, &block)
      styles = block.call if block_given?

      raise ArgumentError, "Styles must be a Hash" unless styles.is_a?(Hash)

      styles_registry[theme] ||= {}
      styles_registry[theme] = deep_merge({}, styles_registry[theme], styles)
    end

    def self.styles_registry
      @styles_registry ||= {}
    end

    def self.deep_merge(*hashes)
      OkonomiUiKit::TWMerge.deep_merge_all(*hashes)
    end
  end
end
