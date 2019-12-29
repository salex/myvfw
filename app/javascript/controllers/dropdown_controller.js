import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ['dropit']

  clicked() {
    var hidden = this.dropitTargets
    console.log("I just got clicked")
    console.log(hidden[0])
    hidden[0].style.display = "block"
  } 

}