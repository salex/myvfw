// src/controllers/member_search_controller.js
// rember to camel case controlers, no dash = or underline_
import { Controller } from "stimulus"
import Rails from '@rails/ujs';

export default class extends Controller {
  static targets = [ "lookup" ]

  changed() {
    // console.log(`Hello, ${this.name}!`)
    var mydata = {name:this.name} 
    // console.log(mydata)
    Rails.ajax({
      url: "/members/search.js",
      type: 'POST',
      beforeSend(xhr, options) {
         xhr.setRequestHeader('Content-Type', 'application/json; charset=UTF-8')
         // Workaround: add options.data late to avoid Content-Type header to already being set in stone
         // https://github.com/rails/rails/blob/master/actionview/app/assets/javascripts/rails-ujs/utils/ajax.coffee#L53
         options.data = JSON.stringify(mydata)
         return true
       }
    })
  }

  get name() {
    return this.lookupTarget.value
  }
}