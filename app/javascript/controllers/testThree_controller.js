
import { Controller } from "stimulus"
import Rails from '@rails/ujs';

export default class extends Controller {
  static targets = [ 'refresh']

  connect() {
    console.log("opened test thtee")
  }

  onSuccess(event) {
    console.log("twas called")
    let [data, status, xhr] = event.detail;
    this.refreshTarget.innerHTML = xhr.response;
  }
}
