class ShowcaseController < ApplicationController
  def index
    @components = [
      { name: "icons", title: "Icons", description: "SVG icons from Heroicons with various styles" },
      { name: "page_builder", title: "Page Builder", description: "Semantic page layout system with headers, sections, and attributes" }
    ]
  end

  def show
    @component = params[:component]
    render "showcase/components/#{@component}"
  rescue ActionView::MissingTemplate
    redirect_to root_path, alert: "Component not found"
  end
end