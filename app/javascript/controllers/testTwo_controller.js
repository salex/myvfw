
import { Controller } from "stimulus"
import Rails from '@rails/ujs';

export default class extends Controller {
  static targets = ["payload",'form', 'refresh']

  connect() {
    console.log("opened test two")
  }

  unclear(){
    const item = event.target
    const form = this.formTarget
    const payload = this.payloadTarget
    payload.value = 'n|' + item.dataset.id
    Rails.fire(form,'submit')
  }

  clear(){
    const item = event.target
    const form = this.formTarget
    const payload = this.payloadTarget
    payload.value = 'c|' + item.dataset.id
    Rails.fire(form,'submit')
  }

  onPostSuccess(event) {
    let [data, status, xhr] = event.detail;
    this.refreshTarget.innerHTML = xhr.response;
    this.payloadTarget.value = "";
  }
}
