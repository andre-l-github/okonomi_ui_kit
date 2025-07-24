import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { fieldId: String, equals: String }

  connect() {
    console.log("FormFieldVisibilityController connected")
    this.field = document.getElementById(this.fieldIdValue)
    if (this.field) {
      this.toggle()
      this.field.addEventListener("change", this.toggle.bind(this))
    }
  }

  toggle() {
    let currentValue

    if (this.field.type === "checkbox") {
      currentValue = this.field.checked ? this.field.value : null
    } else {
      currentValue = this.field.value
    }

    const shouldShow = currentValue === this.equalsValue
    this.element.classList.toggle("hidden", !shouldShow)
  }
}
