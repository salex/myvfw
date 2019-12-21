import Flatpickr from "stimulus-flatpickr";
console.log("entering picker")

// import a theme (could be in your main CSS entry too...)
import "flatpickr/dist/flatpickr.css";

export default class extends Flatpickr {

  initialize() {
     //global options
    console.log("got a picker")
    his.config = {
      altInput: true,
      altFormat: "F j, Y",
      dateFormat: "Y-m-d"
    }
    super.connect();

  }
}

