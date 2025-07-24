class ShowcaseController < ApplicationController
  def index
    @components = [
      { name: "buttons", title: "Buttons", description: "Various button styles and states" },
      { name: "icons", title: "Icons", description: "SVG icons from Heroicons with various styles" },
      { name: "forms", title: "Form Elements", description: "Input fields, selects, checkboxes, and more" },
      { name: "cards", title: "Cards", description: "Content containers with various layouts" },
      { name: "alerts", title: "Alerts", description: "Notification and alert components" },
      { name: "modals", title: "Modals", description: "Dialog boxes and overlays" },
      { name: "navigation", title: "Navigation", description: "Navigation bars, breadcrumbs, and tabs" }
    ]
  end

  def show
    @component = params[:component]
    render "showcase/components/#{@component}"
  rescue ActionView::MissingTemplate
    redirect_to root_path, alert: "Component not found"
  end
end