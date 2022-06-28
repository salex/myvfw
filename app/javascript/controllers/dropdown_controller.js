import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['name']

  // connect() {
  //   console.log('Hello, My Stimulus! I do not understand it yet, but wow!')
  //   console.log(`Where are the targets ${this.hiddenTargets}`)
  //   console.log(this.nameTargets)
  // }


  showme() {
    var name = event.currentTarget

    var dt = name.parentNode
    var dd = dt.nextSibling
    // console.log(hidden[0])
    // hidden[0].style.display = "block"
    // console.log("a name was clicked")
    // console.log(dt)
    // console.log(dd.style.display)
    dd.classList.toggle("hidden")
 
  } 

}