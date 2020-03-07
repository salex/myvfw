
import { Controller } from "stimulus"
import Rails from '@rails/ujs';

export default class extends Controller {
  static targets = []

  connect() {
    console.log("opened test one")
  }

  unclear(){
    const item = event.target
    const id = item.dataset.id
    Rails.ajax({
      url: "/test/unclear.js",
      type: "patch",
      data: "id="+id,
    })
  }

  clear(){
    const item = event.target
    const id = item.dataset.id
    Rails.ajax({
      url: "/test/clear.js",
      type: "patch",
      data: "id="+id,
    })
  }
}
