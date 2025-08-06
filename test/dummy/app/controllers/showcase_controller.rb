class ShowcaseController < ApplicationController
  def index
    @components = [
      { name: "buttons", title: "Buttons", description: "Interactive buttons with variants, colors, sizes, and icon support" },
      { name: "typography", title: "Typography", description: "Headings, Paragraphs, ..." },
      { name: "icons", title: "Icons", description: "SVG icons from Heroicons with various styles" },
      { name: "page_builder", title: "Page Builder", description: "Semantic page layout system with headers, sections, and attributes" },
      { name: "form_builder", title: "Form Builder", description: "Tailwind-styled forms with validation, labels, hints, and i18n support" },
      { name: "dropdown_button", title: "Dropdown Button", description: "Button with dropdown menu for actions and navigation" },
      { name: "modals", title: "Confirmation Modals", description: "Accessible confirmation dialogs with customizable actions and variants" },
      { name: "tables", title: "Tables", description: "Responsive data tables with headers, bodies, custom styling, and empty states" },
      { name: "navigation", title: "Navigation", description: "Sidebar navigation menus with groups, links, and profile sections" },
      { name: "progress_bars", title: "Progress Bars", description: "Linear progress indicators with colors, sizes, and optional text labels" }
    ]
  end

  def show
    @component = params[:component]

    if @component == "form_builder"
      setup_form_builder_showcase
    end

    render "showcase/components/#{@component}"
  rescue ActionView::MissingTemplate
    redirect_to root_path, alert: "Component not found"
  end

  def form_builder_demo
    @user_form = UserForm.new(user_form_params)

    if request.post?
      if @user_form.valid?
        flash[:notice] = "Form submitted successfully! (This is just a demo)"
        redirect_to showcase_path("form_builder")
        return
      else
        flash.now[:alert] = "Please fix the errors below"
      end
    end

    render "showcase/components/form_builder"
  end

  private

  def setup_form_builder_showcase
    @user_form = UserForm.new
    @user_form_with_errors = UserForm.new(
      first_name: "",
      last_name: "X",
      email: "invalid-email",
      phone: "invalid phone",
      website: "not-a-url",
      bio: "A" * 600,
      birth_date: 1.year.from_now,
      country: "INVALID",
      terms_accepted: false
    )
    @user_form_with_errors.validate
  end

  def user_form_params
    return {} unless params[:user_form]

    params.require(:user_form).permit(
      :first_name, :last_name, :email, :phone, :website,
      :bio, :birth_date, :country, :terms_accepted,
      :newsletter_subscription, :profile_visibility
    )
  end
end
