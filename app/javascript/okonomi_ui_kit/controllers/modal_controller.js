import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "backdrop", "panel"]
  static values = { 
    size: String,
    autoOpen: Boolean 
  }

  connect() {
    this.close()
    if (this.autoOpenValue) {
      this.open()
    }
    
    // Bind escape key handler
    this.handleEscape = this.handleEscape.bind(this)
  }

  disconnect() {
    this.unlockBodyScroll()
    document.removeEventListener('keydown', this.handleEscape)
  }

  open() {
    this.containerTarget.style.display = 'block'
    this.lockBodyScroll()
    document.addEventListener('keydown', this.handleEscape)
    
    // Focus trap - focus first focusable element in modal
    this.focusFirstElement()
    
    // Add entrance animations
    requestAnimationFrame(() => {
      this.backdropTarget.classList.remove('opacity-0')
      this.backdropTarget.classList.add('opacity-100')
      
      this.panelTarget.classList.remove('opacity-0', 'translate-y-4', 'sm:translate-y-0', 'sm:scale-95')
      this.panelTarget.classList.add('opacity-100', 'translate-y-0', 'sm:scale-100')
    })
  }

  close() {
    // Add exit animations
    this.backdropTarget.classList.remove('opacity-100')
    this.backdropTarget.classList.add('opacity-0')
    
    this.panelTarget.classList.remove('opacity-100', 'translate-y-0', 'sm:scale-100')
    this.panelTarget.classList.add('opacity-0', 'translate-y-4', 'sm:translate-y-0', 'sm:scale-95')
    
    // Hide after animation completes
    setTimeout(() => {
      this.containerTarget.style.display = 'none'
      this.unlockBodyScroll()
      document.removeEventListener('keydown', this.handleEscape)
    }, 200)
  }

  confirm() {
    // Dispatch confirm event for custom handling
    this.dispatch('confirm', { detail: { modal: this } })
    this.close()
  }

  cancel() {
    // Dispatch cancel event for custom handling  
    this.dispatch('cancel', { detail: { modal: this } })
    this.close()
  }

  handleEscape(event) {
    if (event.key === 'Escape') {
      this.close()
    }
  }

  lockBodyScroll() {
    document.body.style.overflow = 'hidden'
  }

  unlockBodyScroll() {
    document.body.style.overflow = ''
  }

  focusFirstElement() {
    const focusableElements = this.panelTarget.querySelectorAll(
      'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
    )
    
    if (focusableElements.length > 0) {
      focusableElements[0].focus()
    }
  }
}