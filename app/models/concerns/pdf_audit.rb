
class PdfAudit < Prawn::Document
  attr_accessor :summary,:config,:range
  include  ActionView::Helpers::AssetTagHelper

  def initialize(date=nil)
    super(page_layout: :portrait, top_margin:6)
    @layout = {top:bounds.height.to_i,right:bounds.width.to_i,left:0,bottom:0,cursor:cursor}

    if date.present?
      boq = Date.parse(date).beginning_of_quarter - 3.months
      eoq = (boq + 2.months).end_of_month
      @range = boq..eoq
    else
      boq = Date.today.beginning_of_quarter - 3.months
      eoq = (boq + 2.months).end_of_month
      @range = boq..eoq
    end
    @config = TrusteeAudit.new(@range.last + 1.day).config


    # @summary = get_summary
    make_pdf

  end

  def get_summary
    summary = Account.find_by(name:@config.current_assets).family_summary(@range.first,@range.last)
  end

  def money(fixed,sign="")
    sign+fixed.gsub(/(\d)(?=(\d{3})+(?!\d))/, "\\1,") # add commas
  end

  def fixed_to_int(fixed)
    fixed.gsub(/\D/,'').to_i
  end

  def int_to_fixed(int)
    dollars = int / 100
    cents = (int % 100) / 100.0
    amt = dollars + cents
    fixed = sprintf('%.2f',amt) # now have a string to 2 decimals
    money(fixed)
  end

  def make_pdf
    @funds = @config.accounts.count
    font_size(9)
    @page_numb = 0
    stroke_color('777777')

    define_grid(:columns => 24, :rows => 32, :gutter => 5)
    # grid.show_all
    header
    assets
    operations
    reconcile
    certify
    trustee
    commander
    number_pages "MyVFW Form -   Page <page> of <total>", { :start_count_at => 0, :page_filter => :all, :at => [bounds.right - 100, 0], :align => :right, :size => 6 }

  end

  def header
    grid([0,0],[4,4]).bounding_box do
      font_size 12
      c = cursor
      image(Rails.root.join('app/assets/images/vfw_logo2.jpg'),width:100 ) 

      font_size 9
      move_cursor_to c
    end
    grid([0,5], [3,23]).bounding_box do
      font_size(9)
      move_down 7

      text "TRUSTEES' REPORT OF AUDIT of",style: :bold, size:14      # stroke_bounds
      text_box "The Books and Records of the Quartermaster and Adjutant of:  <strong><u>#{@config.post.name} #{@config.post.post}</u></strong>", at:[20,68], inline_format:true
      text_box "Department of <strong><u>#{@config.post.department}</u></strong> for Fiscal Quarter ending:     <strong><u>#{@range.last}</u></strong>", at:[20,57], inline_format:true
      text_box "Fiscal Quarter    <strong><u> #{@range}</u></strong>", at:[20,46], inline_format:true
    end
  end

  def assets

    grid([3,0], [10,23]).bounding_box do
      # stroke_bounds
      font_size(9)
      rows = []
      h = [ "FUNDS - Current Assets",
        "#{@funds + 1}.  Net Cash Balances at Beginning of Quarter",
        "#{@funds + 2}.  Receipts During Quarter",
        "#{@funds + 3}.  Expenditures During Quarter",
        "#{@funds + 4}.  Net Cash Balances at End of Quarter"]
      rows << h
      e = make_table rows,:cell_style => {:padding => [1, 2, 2, 1] ,border_color:"777777"},
        :column_widths => [240, 75,75,75,75] do
          row(0).column(0).font_style = :bold
          row(0).column(0).size = 10
          row(0).column(1..4).size = 6
          row(0).column(1..4).font_style = :bold
          row(-1).font_style = :bold
          column(0..4).align = :left
          # row(-1).align = :right
        end
      e.draw
      rows = []
      @config.accounts.each_with_index do |a,i|
        next if a.name.blank?
        h = ["#{i+1}. #{a.name}",
        money(a.beginning),
        money(a.debit),
        money(a.credit),
        money(a.ending)
        ]
        rows << h
      end
      e = make_table rows,:cell_style => {:padding => [1, 2, 2, 1] ,border_color:"777777"},
        :column_widths => [240, 75,75,75,75] do
          column(1..4).align = :right
          # row(-1).align = :right
      end
      e.draw
 
      tot = @config.totals
      rows = [
        ["#{@funds+5}. Totals",
        money(tot.beginning),
        money(tot.debit),
        money(tot.credit),
        "#{@funds+6}.     #{money(tot.ending)}"]
      ]
      e = make_table rows,:cell_style => {:padding => [1, 2, 2, 1] ,border_color:"777777"},
        :column_widths => [240, 75,75,75,75] do
          column(1..4).align = :right
          row(-1).font_style = :bold
          row(-1).align = :right
          row(-1).size = 9
      end
      e.draw
      move_down 6
      # text "Note: Funds Fee and Temporary have been archived and no longer used"
  
    end
  end

  def operations
    grid([12,0], [20,12]).bounding_box do
      font_size(8)

      move_down 6
      text "#{@config.accounts.count+7}.   OPERATIONS", size:10, style: :bold
      stroke_horizontal_rule
      move_down(2)
      qr = @config.operations
      rows = []
      letters = "abcdefghijklmn"
      puts letters
      qr.each_with_index do |r,i|
        r.response = "0.00" if r.response == '0'
        fixed = !r.response.match(/\d\.\d\d/).nil?
        rows << ["#{letters[i]}. #{r.question}",fixed ? money(r.response) : r.response] unless r.question.blank?
      end
      move_down(2)
        indent 3,3 do
        e = make_table rows,row_colors: ["E8E8E8", "FFFFFF"],:cell_style => {:padding => [3, 2, 2, 3] ,border_color:"FFFFFF",
          border_widths: [0,0,0,0]},
          :column_widths => [210, 60] do
            column(1).align = :right
          end
        e.draw
      end
      font_size(9)
      stroke_bounds
    end
  end
  def reconcile
    grid([12,13], [18,23]).bounding_box do
      move_down 5
      text "#{@funds+8}.    RECONCILIATION OF FUND BALANCES", size:10, style: :bold
      stroke_horizontal_rule
      move_down(2)

      rows = []
      rows << ['Checking Account Balance',{content:money(@config.checking.balance),align: :right},nil]
      rows << ['Less Outstand Checks',{content:money(@config.checking.outstanding), align: :right},nil]
      ck = @config.checking
      diff = @config.totals.ending == ck.total 
      if !diff
        diff_amt = int_to_fixed(fixed_to_int(@config.totals.ending) - fixed_to_int(ck.total))
      end
      tot_label = diff ? "Total" : "Out of Balance Total (#{money(diff_amt)})"
      rows << [{content:'Actual Balance', align: :right, colspan: 2},{content:money(ck.actual),align: :right}]
      rows << [{content:'Savings Account Balance', align: :right, colspan: 2},{content:money(ck.other),align: :right}]
      rows << [{content:'Cash on Hand', align: :right, colspan: 2},{content:money(ck.cash),align: :right}]
      rows << [{content:'Total', align: :right, colspan: 2},{content:money(ck.subtotal),align: :right}]
      rows << [{content:'Bonds and Investments (cost value)', align: :right, colspan: 2},{content:money(ck.cd),align: :right}]
      rows << [{content:tot_label, align: :right, colspan: 2,text_color: (!diff ? 'FF0000' : '000000')},{content:money(ck.total),align: :right, text_color: (!diff ? 'FF0000' : '000000')}]
      indent 2,2 do
        e = make_table rows,row_colors: ["F8F8F8", "FFFFFF"],:cell_style => {:padding => [3, 2, 2, 3] ,border_color:"FFFFFF",
          border_widths: [0,0,0,0]},
          :column_widths => [120, 60, 60] do
            row(-1).font_style = :bold
          end
        e.draw
      end
      stroke_bounds
    end
  end

  def certify
    grid([19,13], [20,23]).bounding_box do
      draw_text "#{@funds+9}.", at:[5,30]
      draw_text "TRUSTEEs' and COMMANDER's", at:[40,30], style: :bold, size:10
      draw_text "CERTIFICATE OF AUDIT", at:[55,20], style: :bold, size:10
      move_down 30
      text "<strong>Date: <u> #{@config.date} </u></strong>", inline_format:true, indent_paragraphs:35
    end
    grid([21,0], [23,23]).bounding_box do
      move_down 6
      text "#{Prawn::Text::NBSP * 5}This is to certify that we (or qualified accountants) have audited the books and records of the Adjutant & Quartermaster of"+
      " \n<strong><u> #{@config.post.post} </u></strong> (District/County Council/Post No.)"+
      " For the Fiscal Quarter ending <strong><u> #{@range.last} </u></strong> in accordance of the National By-Laws and this Report"+
      " is a true and correct statement thereof to the best of our knowledge and belief. All Vouchers and checks have been examined"+
      " and found to be properly approved and checks properly signed.", inline_format:true
    end
  end

  def trustee
    grid([23,0], [26,10]).bounding_box do
      bounding_box([0, cursor], :width => @layout[:right]/2, :height => 80) do
        draw_text "Post Quartermaster:", at:[5,65], style: :bold
        draw_text "Name and Address", at:[120,65], size: 6
        draw_text @config.qm.name, at:[120,50]

        draw_text @config.qm.address, at:[120,35]
        draw_text @config.qm.city, at:[120,25]    
      end

    end

    grid([23,11], [26,23]).bounding_box do


      move_down 14
      text "Signed _____________________________________ Trustee"
      move_down 16

      text "Signed _____________________________________ Trustee"
      move_down 16

      text "Signed _____________________________________ Trustee"
    end
  end

  def commander

    grid([28,0],[30,23]).bounding_box do
          text "#{Prawn::Text::NBSP * 5}This is to certify that the Office of the Quartermaster is Bonded with"+
          " <strong><u> #{@config.bond.name} </u></strong> "+
          "in the amount of <strong><u> $#{money(@config.bond.amount)} </u></strong> until <strong><u> #{@config.bond.to} </u></strong>, "+
          "and that this Audit is correctly made out to the best of my knowledge and belief.", inline_format:true
      end

    grid([30,11],[30,23]).bounding_box do
        text "Signed _____________________________________ Commander"
    end

  end

end
