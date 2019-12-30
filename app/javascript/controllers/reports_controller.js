
import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "volunteers","hours_each","total_hours","miles_each","total_miles"]

  changed(){
    var volunteers_val = this.get_volenteers()
    var hours_each_val = this.get_hours_each()
    var miles_each_val = this.get_miles_each()
    if(miles_each_val > 0){
      this.set_total_miles(volunteers_val * miles_each_val)
    }
    if(hours_each_val > 0){
      this.set_total_hours(volunteers_val * hours_each_val)
    }
    // console.log("something changed")
  }

  get_volenteers(){
    return Number(this.targets.find("volunteers").value)
  }

  get_hours_each(){
    return Number(this.targets.find("hours_each").value)
  }

  get_miles_each(){
    return Number(this.targets.find("miles_each").value)
  }

  set_total_miles(val){
    this.targets.find("total_miles").value = val.toFixed(1)
  }

  set_total_hours(val){
    this.targets.find("total_hours").value = val.toFixed(1)
  }

}
