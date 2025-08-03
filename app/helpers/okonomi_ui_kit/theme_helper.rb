module OkonomiUiKit
  module ThemeHelper
    def theme(t = {}, &block)
      old_theme = theme

      @_okonomi_ui_kit_theme = {}.merge(old_theme).merge(t || {})

      yield(@_okonomi_ui_kit_theme)

      @_okonomi_ui_kit_theme = old_theme
    end

    def get_theme
      @_okonomi_ui_kit_theme ||= OkonomiUiKit::Theme::DEFAULT_THEME
    end
  end
end
