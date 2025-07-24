module OkonomiUiKit
  module BreadcrumbsHelper
  def breadcrumbs
    content_tag(:nav, class: "flex", aria: { label: "Breadcrumb" }) do
      content_tag(:ol, class: "flex items-center space-x-4", role: "list") do
        builder = BreadcrumbBuilder.new(self)
        yield builder
        safe_join(builder.items)
      end
    end
  end

  class BreadcrumbBuilder
    attr_reader :items

    def initialize(view)
      @view = view
      @items = []
      @first = true
    end

    def link(label, url, icon: nil, current: false)
      if @first
        @items << @view.content_tag(:li) do
          @view.content_tag(:div) do
            if icon.present?
              @view.link_to(url, class: "text-gray-400 hover:text-gray-500") do
                @view.svg_icon(icon, class: "size-5") + @view.content_tag(:span, label, class: "sr-only")
              end
            else
              @view.content_tag(:div, class: "flex items-center") do
                @view.link_to(label, url, class: breadcrumb_classes(current, first: true), aria: (current ? { current: "page" } : {}))
              end
            end
          end
        end
        @first = false
      else
        @items << @view.content_tag(:li) do
          @view.content_tag(:div, class: "flex items-center") do
            chevron + @view.link_to(label, url, class: breadcrumb_classes(current), aria: (current ? { current: "page" } : {}))
          end
        end
      end
    end

    private

    def chevron
      @view.svg_icon("heroicons/solid/chevron-right", class: "size-5 shrink-0 text-gray-400")
    end

    def breadcrumb_classes(current, first: false)
      base = "text-sm font-medium"
      base = "#{base} ml-4" unless first
      current ? "#{base} text-gray-500" : "#{base} text-gray-500 hover:text-gray-700"
    end
  end
  end
end
