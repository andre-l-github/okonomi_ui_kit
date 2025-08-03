# frozen_string_literal: true

module OkonomiUiKit
  class SvgIcons
  def self.read(name)
    registry.merge!(name => File.read(file_path(name))) if registry[name].nil?
    registry[name]
  end

  def self.exist?(name)
    registry[name].present? || file_path(name).present?
  end

  def self.file_path(name)
    # First check in the host application
    host_path = Rails.root.join("app", "assets", "images", "#{name}.svg")
    return host_path if File.exist?(host_path)

    # Fall back to the engine's icons
    engine_path = OkonomiUiKit::Engine.root.join("app", "assets", "images", "#{name}.svg")
    return engine_path if File.exist?(engine_path)

    nil
  end

  # Deprecated, kept for backwards compatibility
  def self.file_name(name)
    file_path(name)
  end

  def self.registry
    @registry ||= {}
  end
  end
end
