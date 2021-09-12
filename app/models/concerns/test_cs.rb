class TestCs < Prawn::Document
  attr_accessor :reports,:categories, :headers, :summary
  include  ActionView::Helpers::NumberHelper

  def initialize(report,boq,eoq)
    @reports = report
    @categories = old_to_new
    @headers = report_headers
    @summary = {}
    @categories.keys.each do |k|
      summary[k] = {count:0,volunteers:0,total_hours:0.0,total_miles:0.0,expenses:0.0,total_cost:0.0}
    end
    @boq = boq
    @eoq = eoq
    super(page_layout: :portrait, top_margin:6)
    @layout = {top:bounds.height.to_i,right:bounds.width.to_i,left:0,bottom:0,cursor:cursor}
    make_pdf
  end

  def make_pdf
    title
    @starting_line = 4
    draw_report(@reports.where(area: categories[:community]),headers[:community],:community)
    draw_report(@reports.where(area: categories[:americanism]),headers[:americanism], :americanism)
    draw_report(@reports.where(area: categories[:aid]),headers[:aid], :aid)
    draw_report(@reports.where(area: categories[:youth]),headers[:youth], :youth)
    draw_report(@reports.where(area: categories[:safety]),headers[:safety], :safety)
    draw_summary
  end

  def title
    text_box  "District: #{2}   Post:  #{8600}  From: #{@boq}   To: #{@eoq}",style: :bold, size:12, align: :center, at:[20,700]
    text_box "Department of Alabama, VFW
      Community Service Report",style: :bold, size:14, align: :center, at: [20,740]
    move_down 70
  end

  def draw_report(report,header,key)
    details = report.pluck(:details)
    @inc = 0
    dr_size = report.size > 0 ? report.size : 1
    details.each do |d|
      @inc += (d.size / 130.0).to_i
    end
    dr_raw = (2.5 + ((dr_size - @inc) * 0.95)+ (@inc * 1.2 + 0.5)) + 0.25

    if cursor < dr_raw * 17
      @starting_line = 1
      start_new_page
      move_down 30
    end

    font_size 7
    rows = [
        [{content:header[:title],align: :center,colspan:5,size:10}],
        [header[:desc], "HoursE/T", "Exp",'MilesE/T','Memb']
      ]

    if report.size > 0
      summary[key][:count] = report.size
      summary[key][:volunteers] = report.sum(:volunteers)
      summary[key][:total_hours] = report.sum(:total_hours)
      summary[key][:total_miles] = report.sum(:total_miles)
      summary[key][:expenses] = report.sum(:expenses)
      summary[key][:total_cost] = (summary[key][:total_hours] * 27.20)  + (summary[key][:total_miles] * 0.14) + summary[key][:expenses]
      report.each do |r|
        @inc += r.details.size / 120.0
        rows <<  ["#{r.date} - #{r.details}", "#{r.hours_each}/#{r.total_hours}",r.expenses,"#{r.miles_each}/#{r.total_miles}",r.volunteers]
      end
    else 
      rows << [{content:"<i>There are no reports for this area</i>",align: :center,colspan:5}]
    end
    e = make_table rows,width:540,column_widths: {0 => 400},cell_style: { :inline_format => true,:padding => [3,3,3,3]}do
        row(1).font_style = :bold
      end
    e.draw
    @inc = 0.0
    move_down 10
  end

  def draw_summary
    if cursor < 100.0
      @starting_line = 2
      start_new_page
      move_down 30
    end
    totals = {count:0,volunteers:0,total_hours:0.0,total_miles:0.0,expenses:0.0,total_cost:0.0}

    rows = [
        [{content:"AUDIT Summary",align: :center,colspan:7,size:10}],
        ["Category", "Reports","Members","Hours","Miles", "Exp","TotalCost"]
      ]
    summary.each do |k,v|
      totals[:count] += v[:count]
      totals[:volunteers] += v[:volunteers]
      totals[:total_hours] += v[:total_hours]
      totals[:total_miles] += v[:total_miles]
      totals[:expenses] += v[:expenses]
      totals[:total_cost] += v[:total_cost]
      rows << [k.to_s.capitalize,v[:count],v[:volunteers],v[:total_hours].round(2),v[:total_miles].round(2),number_to_currency(v[:expenses]),number_to_currency(v[:total_cost])]
    end
    rows << ["Totals",totals[:count],totals[:volunteers],totals[:total_hours].round(2),totals[:total_miles].round(2),number_to_currency(totals[:expenses]),number_to_currency(totals[:total_cost])]

    e = make_table rows,width:540, cell_style: { :inline_format => true,:padding => [3,3,3,3]} do 
      row(1).font_style = :bold
      row(-1).font_style = :bold
      column(1..6).align = :right
    end
    e.draw
  end

  def old_to_new
    new_reports = {}
    new_reports[:community] = ["Involvment", "Cooperation","Americanism","Monthly Report"]
    new_reports[:americanism] = ["Legislative","Local Activities", "State Activities", "National Activities","POW/MIA Activities", "Buddy Poppies","Gold Metal","Adopt a Unit"]
    new_reports[:aid] = ["Aid to Others","Finacial Assistance to Vet", "Military Support Events","Hospital Report"]
    new_reports[:youth] = ["Education","VOD/PP", "Scout","Teacher"]
    new_reports[:safety] = [ "Law/Fire/EMT", "Safety"]
    return new_reports
  end

  def report_headers
    header = {}
    header[:community] = {title:"<b>COMMUNITY SERVICE</b>",desc:"<i><b>Please list any activities within your community provided by Post & Auxiliary which helps to benefit the community, church, school, parks, neighborhood cleanups, etc.</b></i>"}
    header[:americanism] = {title:"<b>CITIZENSHIP EDUCATION / AMERICANISM</b>",desc:"<i><b>Please list any Parades, Public Ceremonies, Flag Presentations, Educational Materials, Loyalty Day, POW/MIA activity, Legislative. etc.</b></i>"}
    header[:aid] = {title:"<b>AID TO OTHERS</b>",desc:"<i><b>Please list all Hospital, Nursing Homes, Senior Citizens, Blood Drives Cancer, Rehab, Memorials, March of Dimes, Operation Uplink, etc.</b></i>"}
    header[:youth] = {title:"<b>YOUTH ACTIVITIES</b>",desc:"<i><b>Please list: Post and Auxiliary are encouraged to provide Youth Programs within your community.  Sports, Scouting, Contests, Education, Recognition, including VOD/PP/YOUTH ESSAY’S</b></i>"}
    header[:safety] = {title:"<b>SAFETY</b>",desc:"<i><b>Please list: Pedestrian, Drug Awareness, Recreational, Highway, Fire, Home, Gun, etc.</b></i>"}
    return header
  end

end