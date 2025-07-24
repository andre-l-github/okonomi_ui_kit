import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["message"]
  static values = { autoDismiss: Number }

  connect() {
    if (this.hasAutoDismissValue && this.autoDismissValue > 0) {
      setTimeout(() => {
        this.dismiss()
      }, this.autoDismissValue)
    }
  }

  dismiss() {
    this.element.style.transition = 'opacity 0.3s ease-out, transform 0.3s ease-out'
    this.element.style.opacity = '0'
    this.element.style.transform = 'translateX(100%)'
    
    setTimeout(() => {
      if (this.element.parentNode) {
        this.element.remove()
      }
    }, 300)
  }

  close(event) {
    event.preventDefault()
    this.dismiss()
  }
}