import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['perPage','movie','status','nextBtn','lastBtn']

  connect() {
    this.size = this.movieTargets.length
    this.page = 0
    this.perPage = Number(this.perPageTarget.innerHTML)
    this.pages = Math.floor(this.size/this.perPage)
    if ((this.size % this.perPage) > 0) {this.pages += 1}
    this.setStatus()
    // this.page points to the current set of cards (3 for example)
  }


  next_set() {
    if (this.page == (this.pages - 1)) {return}
    this.hide()
    this.page += 1
    this.show()
    this.setStatus()
  }

  last_set() {
    if (this.page == 0) {return}
    this.hide()
    this.page -= 1
    this.show()
    this.setStatus()
  }

  hide(){
    let curr = this.page * this.perPage
    let last = curr + this.perPage - 1
    while(curr <= last){
      if (curr >= 0 && curr < this.size) {
        this.movieTargets[curr].classList.add("hidden")
      }
      curr++
    }
  }

  show(){
    let curr = this.page * this.perPage
    let last = curr + this.perPage - 1
    while(curr <= last){
      if (curr >= 0 && curr < this.size) {
        this.movieTargets[curr].classList.remove("hidden")
      }
      curr++
    }
  }

  setStatus(){
    this.statusTarget.innerHTML = `Page ${this.page + 1} of ${this.pages}`
    if (this.page == 0) {
      this.lastBtnTarget.classList.add('hidden')
    }else{
      this.lastBtnTarget.classList.remove('hidden')
    }
    if (this.page == this.pages - 1) {
      this.nextBtnTarget.classList.add('hidden')
    }else{
      this.nextBtnTarget.classList.remove('hidden')
    }
  }
}
