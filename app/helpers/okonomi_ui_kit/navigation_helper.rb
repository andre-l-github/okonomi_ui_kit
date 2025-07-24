module OkonomiUiKit
  module NavigationHelper
  def navigation_menu(**options, &block)
    builder = NavigationBuilder.new(self)
    render 'okonomi_ui_kit/navigation/menu', builder: builder, options: options, &block
  end

  class NavigationBuilder
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::CaptureHelper

    def initialize(template)
      @template = template
    end

    def group(title, &block)
      group_builder = NavigationGroupBuilder.new(@template)
      content = capture(group_builder, &block)
      
      tag.li do
        tag.div(title, class: "text-xs/6 font-semibold text-gray-400") +
        tag.ul(content, role: "list", class: "-mx-2 mt-2 space-y-1")
      end
    end

    def profile_section(&block)
      content = capture(&block)
      tag.li(content, class: "-mx-6 mt-auto")
    end

    private

    def tag
      @template.tag
    end

    def capture(*args, &block)
      @template.capture(*args, &block)
    end
  end

  class NavigationGroupBuilder
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::CaptureHelper

    def initialize(template)
      @template = template
    end

    def nav_link(title, path, icon: nil, initials: nil, exact: false)
      tag.li do
        @template.render "okonomi_ui_kit/navigation/link",
                        path: path, 
                        title: title, 
                        icon: icon,
                        initials: initials,
                        exact: exact
      end
    end

    private

    def tag
      @template.tag
    end

    def capture(*args, &block)
      @template.capture(*args, &block)
    end
  end
  end
end