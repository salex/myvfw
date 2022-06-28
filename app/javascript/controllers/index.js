// Load all the controllers within this directory and all subdirectories. 
// Controller files must be named *_controller.js.

import { application } from "controllers/application"

import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

// Lazy load controllers as they appear in the DOM (remember not to preload controllers in import map!)
// import { lazyLoadControllersFrom } from "@hotwired/stimulus-loading"
// lazyLoadControllersFrom("controllers", application)
import Flatpickr from 'stimulus-flatpickr'
application.register('flatpickr', Flatpickr)

import { Autocomplete } from 'stimulus-autocomplete'
application.register('autocomplete', Autocomplete)
