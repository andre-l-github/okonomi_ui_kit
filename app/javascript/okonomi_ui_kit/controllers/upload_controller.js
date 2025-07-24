import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "filename", "dropzone", "preview", "destroyInput"]

  connect() {
    this.dropzoneTarget.addEventListener("dragover", (e) => {
      e.preventDefault()
      this.dropzoneTarget.classList.add("bg-gray-100")
    })

    this.dropzoneTarget.addEventListener("dragleave", () => {
      this.dropzoneTarget.classList.remove("bg-gray-100")
    })

    this.dropzoneTarget.addEventListener("drop", (e) => {
      e.preventDefault()
      this.dropzoneTarget.classList.remove("bg-gray-100")
      const files = e.dataTransfer.files
      if (files.length > 0) {
        this.inputTarget.files = files
        this.updatePreview()
      }
    })
  }

  updatePreview() {
    const file = this.inputTarget.files[0]
    this.filenameTarget.textContent = file ? file.name : "No file selected"
    this.destroyInputTarget.value = "0"

    if (file && file.type.startsWith("image/")) {
      const reader = new FileReader()
      reader.onload = (e) => {
        this.previewTarget.innerHTML = `<img src="${e.target.result}" class="max-h-32 rounded" />`
      }
      reader.readAsDataURL(file)
    } else if (file) {
      this.previewTarget.innerHTML = `
        <svg class="size-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16v-4m0 0V7m0 5H3m4 0h4" />
        </svg>`
    }
  }

  clear() {
    this.inputTarget.value = ""
    this.filenameTarget.textContent = "No file selected"
    this.previewTarget.innerHTML = `
      <svg class="size-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16v-4m0 0V7m0 5H3m4 0h4" />
      </svg>`
    this.destroyInputTarget.value = "1"
  }
}
