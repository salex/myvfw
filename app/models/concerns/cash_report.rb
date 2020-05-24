# cash_report.rb
class CashReport < Prawn::Document
  DONATIONS = %w(Coffee Dance Karaoke PhoneCards Canteen Food Amusement Rounding)
  def initialize(view)
    super( top_margin: 25, page_layout: :landscape)
    @view = view
    make_pdf
  end

  def make_pdf
    top = cursor
    bounding_box [0,top], width:320 do
      font_size 12
      text "Cash Accountability Report - Date ____________", style: :bold, align: :center
      font_size 11
      cash
      donations
    end
    bounding_box [390,top], width:320 do

      font_size 12
      text "Cash Accountability Report - Date ____________", style: :bold, align: :center
      font_size 11
      cash
      donations
    end
  end

  def cash
    move_down 5
    # font_size(10)
    data = [%w($\ Currency # Amount $\ Other Amount)]
    data << ["100's",nil,nil,{content:'Coins'},nil]
    data << ["50's",nil,nil,'Checks',nil]
    data << ["20's",nil,nil,nil,nil]
    data << ["10's",nil,nil,nil,nil]
    data << ["5's",nil,nil,nil,nil]
    data << ["1's",nil,nil,'Tot Other',nil]

    data << [{content:'Total Currency',colspan:2},nil,'Copy->>',nil]
    data << [{content:nil,colspan:4},{content:nil,:background_color => '404040'}]

    data << [{content:"(1) Total Deposit (Currency + Other)",colspan:4},nil]

    data << [{content:"Canteen Bank Retained",colspan:4,align: :right},nil]
    data << [{content:"Donation Bank Retrained",colspan:4,align: :right},nil]
    data << [{content:"Food Bank Retained",colspan:4,align: :right},nil]
    data << [{content:"Coffee Retained",colspan:4,align: :right},nil]
    data << [{content:nil,colspan:4},{content:nil,:background_color => '404040'}]
    data << [{content:"Total Cash Accountable",colspan:4},nil]

    # data << [{content:nil,colspan:5}]
    # data << [{content:"Total Retained +",colspan:2},nil,nil,nil]

    # data << [{content:"Summary",colspan: 4},"Amount"]
    # data << [{content:"Total Cash",colspan:4,align: :right},nil]
    # data << [{content:"Donations/Other Revenue Total -",colspan:4,align: :right},"-"]
    # data << [{content:nil,colspan:5}]
    # data << [{content:"Diff ( = Canteen Receipts)",colspan:4,align: :right},nil]
    e = make_table data,:cell_style => {:padding => [2,4,2,4],border_color:"808080"}, :column_widths => [90, 20, 70,70,70] do
      row(0..-1).font_style = :bold
      column(0).style font_style: :bold
      row(15).style font_style: :bold
    end
    e.draw
  end

  def donations
    # font_size(10)
    move_down 10

    data = [[{content:"Other Donation/Revenue Acct",colspan:2}, "Fund", "Amount"]]

    @total_revenue = 0.0
    donation_accounts = DONATIONS
    donation_accounts.each do |n|
      data << [{content:n,colspan:2,align: :right},nil,nil]
    end
    (10 - donation_accounts.count).times do
      data << [{content:" ",colspan:2},nil,nil]
    end
    
    data << [{content:nil,colspan:3},{content:nil,:background_color => '404040'}]


    data << [{content:"Total Other Deposited",colspan: 3,align: :right,font_style: :bold},nil]
    data << [{content:"Total Sales Deposit from Canteen Report",colspan: 3,align: :right,font_style: :bold},nil]
    data << [{content:nil,colspan:3},{content:nil,:background_color => '404040'}]

    data << [{content:"Audit: Sales + Other = Total Deposit(1)" ,colspan: 3,align: :right,font_style: :bold},nil]

    e = make_table data,:cell_style => {:padding => [2,4,2,4],border_color:"808080"}, :column_widths => [150,40,60,70] do
      row(0).font_style = :bold

    end
    e.draw
    move_down 4
    font_size 8
    # text "CIB = Cash in Bags, (R) = Retain(ed), (D) = Deposit(ed)"

  end

  

end
