import Flatpickr from "stimulus-flatpickr";
console.log("entering picker")

import { Application } from 'stimulus'
// import Flatpickr from 'stimulus-flatpickr'

import { definitionsFromContext } from 'stimulus/webpack-helpers'
const application = Application.start()
const context = require.context('../controllers', true, /\.js$/)
application.load(definitionsFromContext(context))

// Manually register Flatpickr as a stimulus controller
application.register('flatpickr', Flatpickr)

// import a theme (could be in your main CSS entry too...)

export default class extends Flatpickr {
  change(selectedDates, dateStr) {
     this.data.set('defaultDate', dateStr)
   }


  initialize() {
     //global options
    console.log("got a picker")
    this.config = {
      altInput: true,
      altFormat: "F j, Y",
      dateFormat: "Y-m-d"
    }
    super.connect();

  }

  
}

