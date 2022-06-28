
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ ]

  connect() {
    this.numeric = false
    // console.log("GOT SORT")
  }

  sortBy(){
    const th = event.target
    this.numeric = th.classList.contains('numeric')
    const tr = th.closest('tr')
    const table = tr.closest('table')
    var idx = Array.from(tr.children).indexOf(th)
    // idx is col index
    this.sortTable(table,idx)
  }

  sortTable(table,idx) {
    var  rows, switching, i, x, y, shouldSwitch, dir, switchcount = 0;
    switching = true;
    // Set the sorting direction to ascending:
    dir = "asc"; 
    /* Make a loop that will continue until
    no switching has been done: */

    while (switching) {
      // Start by saying: no switching is done:
      switching = false;
      rows = table.rows;
      /* Loop through all table rows (except the
      first, which contains table headers): */

      for (i = 1; i < (rows.length - 1); i++) {
        // Start by saying there should be no switching:
        shouldSwitch = false;
        /* Get the two elements you want to compare,
        one from current row and one from the next: */

        x = rows[i].getElementsByTagName("TD")[idx];
        y = rows[i + 1].getElementsByTagName("TD")[idx];
        // Added this check if there is a row that has a colspan e.g. ending balance row
        if ((x == undefined) || (y == undefined)){continue}
        /* Check if the two rows should switch place,
        based on the direction, asc or desc: */

        // Check if numeric sort (th has class numeric) added by ME
        if (!this.numeric) {
          // if has an anchor, get innerhtml of anchor instead of td
          var tst = x.getElementsByTagName("A").length
          if (tst > 0){
            var compx = x.firstChild.innerHTML.toLowerCase()
            var compy = y.firstChild.innerHTML.toLowerCase()
          }else{
            var compx = x.innerHTML.toLowerCase()
            var compy = y.innerHTML.toLowerCase()
          }
        }else{
          var compx = /\d/.test(x.innerHTML) ? parseFloat(x.innerHTML) : 0 
          var compy = /\d/.test(y.innerHTML) ? parseFloat(y.innerHTML) : 0 
        }
        if (dir == "asc") {
          if (compx > compy) {
            // If so, mark as a switch and break the loop:
            shouldSwitch = true;
            break;
          }
        } else if (dir == "desc") {
          if (compx < compy) {
            // If so, mark as a switch and break the loop:
            shouldSwitch = true;
            break;
          }
        }
      }
      if (shouldSwitch) {
        /* If a switch has been marked, make the switch
        and mark that a switch has been done: */
        rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
        switching = true;
        // Each time a switch is done, increase this count by 1:
        switchcount ++; 
      } else {
        /* If no switching has been done AND the direction is "asc",
        set the direction to "desc" and run the while loop again. */
        if (switchcount == 0 && dir == "asc") {
          dir = "desc";
          switching = true;
        }
      }
    }
  }

}


// Stimulus controler to sort html table by clicked column in thead
// sorts rows in first tbody. Does number filter and Asc Dsc

// import { Controller } from "@hotwired/stimulus"

// export default class extends Controller {

//   sortBy() {
//     var th = event.currentTarget
//     var idx = th.cellIndex
//     var tbl = th.closest('table')
//     var tbody = tbl.querySelector('tbody')
//     this.sort(tbody,idx)
//   } 

//   sort(tbody, col) {
//     var tr = Array.from(tbody.querySelectorAll('tr'))
//     this.asc = !this.asc
//     var reverse = this.asc ? 1 : -1
//     var lt_eq_gt

//     // Sort rows
//     tr = tr.sort(function (a, b) {
//         // numbers stuff
//         var v1 = a.cells[col].textContent.replace('$','').replace(',','')
//         var v2 = b.cells[col].textContent.replace('$','').replace(',','')
//         if  (v1 !== '' && v2 !== '' && !isNaN(v1) && !isNaN(v2)){
//           lt_eq_gt = v1 - v2 
//         }else{
//           lt_eq_gt = v1.trim().localeCompare(v2.trim())
//         }
//         return reverse * lt_eq_gt
//     })

//     var i
//     for(i = 0; i < tr.length; ++i){
//         // Append rows in new order
//         tbody.appendChild(tr[i]);
//     }
//   }

// }
