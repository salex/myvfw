
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "name","beginning","debit","credit","ending","type","balance","outstanding","other"]

  changed(){
    // var totals = document.getElementById('acct-totals')
    this.sum_all()
   }
   connect(){
    this.sum_all()
   }


  sum_all(){
    console.log("hi")
    var name = this.nameTargets
    var begin = this.beginningTargets
    var credit = this.creditTargets
    var debit = this.debitTargets
    var ending = this.endingTargets
    var type = this.typeTargets
    var tot_begin = 0
    var tot_credit = 0
    var tot_debit= 0
    var tot_ending = 0
    var tot_cash = 0
    var tot_cd = 0
    var tot_save = 0
    this.format_field(this.outstandingTarget)
    this.format_field(this.balanceTarget)
    this.format_field(this.otherTarget)

    var i
    var val
    var bal
    for (i in name){

      // console.log("what is type of "+ i +  typeof(name[i].value) + " val  "+name[i].value)
      if (name[i].value == '') {
        // console.log("got a blank name")
        begin[i].value = ''
        credit[i].value = ''
        debit[i].value = ''
        ending[i].value = ''
      }else{
        bal = 0

        val = Number(begin[i].value)|| 0
        begin[i].value = val.toFixed(2)
        bal +=  val
        tot_begin += val

        val = Number(debit[i].value) || 0
        debit[i].value = val.toFixed(2)
        bal += val
        tot_debit += val

        val = Number(credit[i].value) || 0
        credit[i].value = val.toFixed(2)
        bal -= val
        tot_credit += val

        ending[i].value = bal.toFixed(2)
        tot_ending += bal
        if (type[i].value == 'CD') {tot_cd += bal}
        if (type[i].value == 'Ca') {tot_cash += bal}
        if (type[i].value == 'Sv') {tot_save += bal}



       }
    }
    document.getElementById('audit[totals][beginning]').value = tot_begin.toFixed(2)
    document.getElementById('audit[totals][debit]').value = tot_debit.toFixed(2)
    document.getElementById('audit[totals][credit]').value = tot_credit.toFixed(2)
    document.getElementById('audit[totals][ending]').value = tot_ending.toFixed(2)

    this.set_balance(tot_ending,tot_cd,tot_cash,tot_save)
  
  }
  format_field(target){
    var curr_val = Number(target.value)
    target.value  = curr_val.toFixed(2)
  }

  set_balance(tot_ending,tot_cd,tot_cash,tot_save){
    // console.log(`Total Cash: ${tot_cash}`)
    // console.log(`Total Saving: ${tot_cd}`)
    // console.log(`Total All: ${tot_ending}`)
    var balance = document.getElementById("audit[checking][balance]")
    var outstanding = document.getElementById("audit[checking][outstanding]")
    var actual = document.getElementById("audit[checking][actual]")
    var other = document.getElementById("audit[checking][other]")
    var cash = document.getElementById("audit[checking][cash]")
    var subtotal = document.getElementById("audit[checking][subtotal]")
    var cd = document.getElementById("audit[checking][cd]")
    var total = document.getElementById("audit[checking][total]")
    actual.value = (Number(balance.value) - Number(outstanding.value)).toFixed(2)
    cash.value = tot_cash.toFixed(2)
    cd.value = tot_cd.toFixed(2)
    other.value = tot_save.toFixed(2)

    var subtotal_calc = (Number(other.value) + Number(actual.value) + tot_cash)
    subtotal.value = subtotal_calc.toFixed(2)
    total.value = (subtotal_calc + tot_cd).toFixed(2)
    var error = document.getElementById("balanceError")
    var comp_end = subtotal_calc + tot_cd
    var balanced = comp_end == tot_ending
    if (!balanced) {
      error.innerHTML = `Out of Balance:  ${(comp_end - tot_ending).toFixed(2)}`
      error.classList.remove('w3-hide')
    }else{
      error.innerHTML = ''
      error.classList.add('w3-hide')
    }


  }

}

// id="audit[checking][outstanding]