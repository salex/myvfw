// hideTarget.controller
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['hidder','parent']
  // connect() {
  //   console.log('Hello, My Stimulus! I do not understand it yet, but wow!')
  // }

  clicked() {
    var hidder = event.currentTarget

    var parent = hidder.parentNode
    parent.style.display = "none"
 
  } 

}
