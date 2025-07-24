// app/javascript/controllers/file_input_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.input = this.element
    this.label = document.getElementById("file-name")

    this.input.addEventListener("change", () => {
      this.label.textContent = this.input.files[0]?.name || "No file chosen"
    })
  }
}