module OkonomiUiKit
  module Components
    class Navigation < OkonomiUiKit::Component
      def render(options = {}, &block)
        options = options.with_indifferent_access
        builder = NavigationBuilder.new(view, self)

        view.render(template_path, builder: builder, options: options, &block)
      end

      register_styles :default do
        {
          menu: {
            base: "flex flex-1 flex-col gap-y-7"
          },
          group: {
            title: "text-xs/6 font-semibold text-gray-400",
            list: "-mx-2 mt-2 space-y-1"
          },
          link: {
            base: "group flex gap-x-3 rounded-md p-2 text-sm/6 font-semibold hover:bg-gray-50 hover:text-primary-600 text-gray-700",
            active: "group flex gap-x-3 rounded-md p-2 text-sm/6 font-semibold hover:bg-gray-50 hover:text-primary-600 bg-gray-50 text-primary-600",
            icon: "size-6 text-gray-400 group-hover:text-primary-600",
            initials: {
              base: "flex size-6 shrink-0 items-center justify-center rounded-lg border border-gray-200 bg-white text-[0.625rem] font-medium text-gray-400 group-hover:border-primary-600 group-hover:text-primary-600"
            }
          },
          profile_section: {
            base: "-mx-6 mt-auto"
          }
        }
      end
    end

    class NavigationBuilder
      attr_reader :view, :navigation_component, :groups

      def initialize(view, navigation_component)
        @view = view
        @navigation_component = navigation_component
        @groups = []
      end

      def group(title, &block)
        group_builder = NavigationGroupBuilder.new(view, navigation_component)
        yield(group_builder)

        @groups << view.tag.li do
          view.tag.div(title, class: style(:group, :title)) +
          view.tag.ul(group_builder.render_links, role: "list", class: style(:group, :list))
        end
      end

      def profile_section(&block)
        content = view.capture(&block)
        @groups << view.tag.li(content, class: style(:profile_section, :base))
      end

      def style(*args)
        navigation_component.style(*args)
      end

      def render_groups
        view.safe_join(@groups)
      end
    end

    class NavigationGroupBuilder
      attr_reader :view, :navigation_component, :links

      def initialize(view, navigation_component)
        @view = view
        @navigation_component = navigation_component
        @links = []
      end

      def nav_link(title, path, icon: nil, initials: nil, exact: false)
        @links << view.tag.li do
          view.render "okonomi/components/navigation/link",
                      path: path,
                      title: title,
                      icon: icon,
                      initials: initials,
                      exact: exact,
                      style_helper: self
        end
      end

      def style(*args)
        navigation_component.style(*args)
      end

      def render_links
        view.safe_join(@links)
      end
    end
  end
end
