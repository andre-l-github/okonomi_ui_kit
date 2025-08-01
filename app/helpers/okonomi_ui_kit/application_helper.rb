module OkonomiUiKit
  module ApplicationHelper
    def active_link_to(path, options = {}, &block)
      path_to_check = path.split('?').first
      if (options[:exact] && request.path == path_to_check) || (!options[:exact] && request.path.include?(path_to_check))
        options[:class] = options[:active_class].presence || [options[:class], 'active'].compact.join(' ')
      end

      link_to(path, options, &block)
    end
  end
end
