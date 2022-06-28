import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "textfield" ]

  changed() {
    var field = this.textfieldTarget
    var curr_val = Number(field.value)
    this.textfieldTarget.value  = curr_val.toFixed(2)
  }
}
