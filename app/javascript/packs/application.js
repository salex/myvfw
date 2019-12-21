// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
// require("../src/hello_coffee.coffee")
// require("./vendor/foopicker.js")
// require("./hello_coffee.coffee")
// import foopicker from 'foopicker'
// require("foopicker/css/foopicker.css")

// document.addEventListener("turbolinks:load", () => {
//   foopicker("[data-behavior='foopicker']")
// })

// import flatpickr from "flatpickr"
// require("flatpickr/dist/flatpickr.css")

// require("./src/listners.js")

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

import { Application } from 'stimulus'
// import Flatpickr
import Flatpickr from 'stimulus-flatpickr'

import { definitionsFromContext } from 'stimulus/webpack-helpers'
const application = Application.start()
const context = require.context('../controllers', true, /\.js$/)
application.load(definitionsFromContext(context))

// Manually register Flatpickr as a stimulus controller
application.register('flatpickr', Flatpickr)

// import "controllers"
