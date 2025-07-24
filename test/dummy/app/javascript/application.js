import "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

const application = Application.start()
application.debug = false
window.Stimulus = application

// Load all controllers from the dummy app (if any exist)
try {
  eagerLoadControllersFrom("controllers", application)
} catch (e) {
  // Controllers directory might not exist, that's OK
}

// Load all controllers from OkonomiUiKit engine
eagerLoadControllersFrom("okonomi_ui_kit/controllers", application)

export { application }