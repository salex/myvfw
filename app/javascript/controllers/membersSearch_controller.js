// src/controllers/member_search_controller.js
// rember to camel case controlers, no dash = or underline_
import { Controller } from "@hotwired/stimulus"
  export default class extends Controller {
    connect() {
      // console.log("got a search")
    }

    changed() {
      var lookup = event.target.value
      this.element.requestSubmit();
      // if (lookup.length >= 2) {
      //   this.element.requestSubmit();
      // }
    }
  }
