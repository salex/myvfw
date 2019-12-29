// Stimulus controler to sort html table by clicked column in thead
// sorts rows in first tbody. Does number filter and Asc Dsc

import { Controller } from "stimulus"

export default class extends Controller {

  clicked() {
    var th = event.currentTarget
    var idx = th.cellIndex
    var tbl = th.closest('table')
    var tbody = tbl.querySelector('tbody')
    this.sort(tbody,idx)
  } 

  sort(tbody, col) {
    var tr = Array.from(tbody.querySelectorAll('tr'))
    this.asc = !this.asc
    var reverse = this.asc ? 1 : -1
    var lt_eq_gt

    // Sort rows
    tr = tr.sort(function (a, b) {
        // numbers stuff
        var v1 = a.cells[col].textContent.replace('$','').replace(',','')
        var v2 = b.cells[col].textContent.replace('$','').replace(',','')
        if  (v1 !== '' && v2 !== '' && !isNaN(v1) && !isNaN(v2)){
          lt_eq_gt = v1 - v2 
        }else{
          lt_eq_gt = v1.trim().localeCompare(v2.trim())
        }
        return reverse * lt_eq_gt
    })

    var i
    for(i = 0; i < tr.length; ++i){
        // Append rows in new order
        tbody.appendChild(tr[i]);
    }
  }

}
