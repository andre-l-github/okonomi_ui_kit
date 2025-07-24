# frozen_string_literal: true

module OkonomiUiKit
  module IconHelper
  def icon_tag(icon, variant = :outlined, options = {})
    if icon.is_a?(Icon)
      doc = Nokogiri::HTML::DocumentFragment.parse icon.send(:"content_#{variant}")
      svg = doc.at_css 'svg'

      svg['class'] = options[:class] if options[:class].present?
      svg['style'] = options[:style] if options[:style].present?

      svg['width'] = options[:width] if options[:width].present?
      svg['height'] = options[:height] if options[:height].present?

      raw doc
    else
      svg_icon(icon, options)
    end
  end

  def svg_icon(name, options = {})
    if OkonomiUiKit::SvgIcons.exist?(name)
      doc = Nokogiri::HTML::DocumentFragment.parse OkonomiUiKit::SvgIcons.read(name)
      svg = doc.at_css 'svg'

      svg['class'] = options[:class] if options[:class].present?
      svg['style'] = options[:style] if options[:style].present?

      svg['width'] = options[:width] if options[:width].present?
      svg['height'] = options[:height] if options[:height].present?
    else
      doc = "<!-- SVG #{name} not found -->"
    end

    raw doc
  end
  end
end
