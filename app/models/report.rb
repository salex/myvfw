class Report < ApplicationRecord
  belongs_to :post
  validates :date, presence:true
  validates :volunteers, presence:true
  validates :details, presence:true
  validates :type_report, presence:true
  validates :area, presence:true
  validates :total_hours, presence:true

  HourRate = 27.20
  MilageRate = 0.14
  ProgramTypes =['Community Service','Hospital','Legislative','National Military Service',
    'Service Officer','Programs','Membership']
  ProgramOptions = {
    "Community Service"=>["Involvment", "Cooperation", "Education", "Aid to Others", "Americanism", "Safety", "Youth Activities", "POW/MIA Activities"],
    "Hospital"=>["Hospital Report"], 
    "Legislative"=>["Local Activities", "State Activities", "National Activities"], 
    "National Military Service"=>["Adopt a Unit", "Application/Activiy Report", "Finacial Assistance to Vet", "Military Support Events", "Donations"], 
    "Programs"=>["VOD/PP", "Gold Metal", "Teacher", "Scout", "Law/Fire/EMT", "Community Service Workbook", "Media Awards", "Buddy Poppies"], 
    "Service Officer"=>["Monthly Report"], 
    "Membership"=>["Membership Drive", "Contact Continuous/Reinstates"]
  }

  def self.old_to_new

    new_reports = {}
    new_reports[:community] = ["Involvment", "Cooperation"]
    new_reports[:americanism] = ["Legislative","Local Activities", "State Activities","Legislative","Local", "State", 
      "National","POW/MIA Activities", "Buddy Poppies","Adopt a Unit","Americanism"]
    new_reports[:aid] = ["Aid to Others","Finacial Assistance to Vet", "Military Support Events","Hospital Report","Monthly Report"]
    new_reports[:youth] = ["Education","VOD/PP", "Scout","Teacher"]
    new_reports[:safety] = [ "Law/Fire/EMT", "Safety","Gold Metal"]
    return new_reports
  end

  def self.new_report_summary(date=nil)
    range = Report.report_range(date)
    summary = {}
    totals = {count:0,volunteers:0,total_hours:0.0,total_miles:0.0,expenses:0.0,total_cost:0.0}
    categories = Report.old_to_new
    header = {}
    header[:community] = "Community Service"
    header[:americanism] = "Citizenship/Education/Americanism" 
    header[:aid] = "Aid to Others"
    header[:youth] = "Youth Activities"    
    header[:safety] = "Safety"

    keys = categories.keys
    keys.each do |t|
      summary[t] = {}
      prg = Report.where(area: categories[t],date:range)
      summary[t][:count] = prg.count
      totals[:count] += prg.count
      if prg.present?
        summary[t][:title] = header[t]
        summary[t][:volunteers] = prg.sum(:volunteers)
        summary[t][:total_hours] = prg.sum(:total_hours)
        summary[t][:total_miles] = prg.sum(:total_miles)
        summary[t][:expenses] = prg.sum(:expenses)
        summary[t][:total_cost] = (summary[t][:total_hours] * HourRate) + (summary[t][:total_miles] * MilageRate) + summary[t][:expenses]
        totals[:volunteers]  += summary[t][:volunteers] 
        totals[:total_hours] += summary[t][:total_hours]
        totals[:total_miles] += summary[t][:total_miles]
        totals[:expenses]    += summary[t][:expenses]    
        totals[:total_cost]  += summary[t][:total_cost]
      else
        summary[t][:title] = header[t]
      end
    end
    return summary,totals,range
  end


  def self.report_summary(date=nil)
    range = Report.report_range(date)
    summary = {}
    totals = {count:0,volunteers:0,total_hours:0.0,total_miles:0.0,expenses:0.0,total_cost:0.0}
    ProgramTypes.each do |t|
      summary[t] = {}
      prg = Report.where(type_report:t, date:range)
      summary[t][:count] = prg.count
      totals[:count] += prg.count
      if prg.present?
        summary[t][:volunteers] = prg.sum(:volunteers)
        summary[t][:total_hours] = prg.sum(:total_hours)
        summary[t][:total_miles] = prg.sum(:total_miles)
        summary[t][:expenses] = prg.sum(:expenses)
        summary[t][:total_cost] = (summary[t][:total_hours] * HourRate) + (summary[t][:total_miles] * MilageRate) + summary[t][:expenses]
        totals[:volunteers]  += summary[t][:volunteers] 
        totals[:total_hours] += summary[t][:total_hours]
        totals[:total_miles] += summary[t][:total_miles]
        totals[:expenses]    += summary[t][:expenses]    
        totals[:total_cost]  += summary[t][:total_cost] 
      end
    end
    return summary,totals,range
  end

  def self.audit_summary(audit)
    range = Report.audit_report_range[audit.to_i]
    summary = {}
    totals = {count:0,volunteers:0,total_hours:0.0,total_miles:0.0,expenses:0.0,total_cost:0.0}
    ProgramTypes.each do |t|
      summary[t] = {}
      prg = Report.where(type_report:t, date:range)
      summary[t][:count] = prg.count
      totals[:count] += prg.count
      if prg.present?
        summary[t][:volunteers] = prg.sum(:volunteers)
        summary[t][:total_hours] = prg.sum(:total_hours)
        summary[t][:total_miles] = prg.sum(:total_miles)
        summary[t][:expenses] = prg.sum(:expenses)
        summary[t][:total_cost] = (summary[t][:total_hours] * HourRate) + (summary[t][:total_miles] * MilageRate) + summary[t][:expenses]
        totals[:volunteers]  += summary[t][:volunteers] 
        totals[:total_hours] += summary[t][:total_hours]
        totals[:total_miles] += summary[t][:total_miles]
        totals[:expenses]    += summary[t][:expenses]    
        totals[:total_cost]  += summary[t][:total_cost] 
      end
    end
    return summary,totals,range
  end


  def self.quarter_summary(date = nil)
    range = Report.audit_report_range(date)
    results = []
    range.each do |q|
      # from = range.first + (q*3).months
      # to = from + 3.months - 1.day
      summary = {}
      totals = {count:0,volunteers:0,total_hours:0.0,total_miles:0.0,expenses:0.0,total_cost:0.0}
      ProgramTypes.each do |t|
        summary[t] = {}
        prg = Report.where(type_report:t, date:q)
        summary[t][:count] = prg.count
        totals[:count] += prg.count
        if prg.present?
          summary[t][:volunteers] = prg.sum(:volunteers)
          summary[t][:total_hours] = prg.sum(:total_hours)
          summary[t][:total_miles] = prg.sum(:total_miles)
          summary[t][:expenses] = prg.sum(:expenses)
          summary[t][:total_cost] = (summary[t][:total_hours] * HourRate) + (summary[t][:total_miles] * MilageRate) + summary[t][:expenses]
          totals[:volunteers]  += summary[t][:volunteers] 
          totals[:total_hours] += summary[t][:total_hours]
          totals[:total_miles] += summary[t][:total_miles]
          totals[:expenses]    += summary[t][:expenses]    
          totals[:total_cost]  += summary[t][:total_cost] 
        end
      end
      prg = Report.where(date:q).order(:date)
      details = prg.as_json(except:[:id,:created_at,:updated_at],methods:[:total_cost])

      results << {summary:summary,totals:totals,details:details, range:q}
    end
    return results
  end

  def self.current
     Report.where(date: Report.report_range)
  end

  # def self.report_range(for_date=nil)
  #   for_date = Date.parse(for_date) unless for_date.nil? || for_date.class == Date
  #   today = for_date ||= Date.today
  #   if today.month < 6
  #     from = Date.new((today.year) - 1,5,1)
  #   else
  #     from = Date.new(today.year,5,1)
  #   end
  #   return from..(from + 1.year - 1.day)
  # end

  def self.audit_report_range(date=nil)
    periods = [3,3,3,3]
    reports = []
    range = Report.report_range(date)
    start = range.first
    periods.each do |m|
      from = start
      start = start + m.months
      to = start - 1.day
      # p "From #{from} To #{to}"
      report_range = from..to
      reports << report_range
    end
    reports
  end



  def self.report_range(for_date=nil)
    date = Report.set_date(for_date)
    # for_date = Date.parse(for_date) unless for_date.nil? || for_date.class == Date
    # today = for_date ||= Date.today
    if date.month > 6
      from = Date.new(date.year ,7,1)
    else
      from = Date.new((date.year - 1),7,1)
    end
    return from..(from + 1.year - 1.day)
  end

  # def self.post_summary(for_date=nil)
  #   range = Report.report_range(for_date)
  #   totals = {numb:post.numb,city:post.city,count:0,volunteers:0,total_hours:0.0,total_miles:0.0,expenses:0.0,total_cost:0.0}
  #   prg = post.reports.where(date:range)
  #   if prg.present?
  #     totals[:count] = prg.count
  #     totals[:volunteers] = prg.sum(:volunteers)
  #     totals[:total_hours] = prg.sum(:total_hours)
  #     totals[:total_miles] = prg.sum(:total_miles)
  #     totals[:expenses] = prg.sum(:expenses)
  #     totals[:total_cost] = (totals[:total_hours] * 7.25)+ (totals[:total_miles] * 0.14) + totals[:expenses]
  #   end
  #   totals
  # end
 
  def hour_cost
    self.total_hours = default_volunteers * hours_each if hours_each.present?
    tot = default_hours *  HourRate
    return tot.round(2)
  end

  def milage_cost
    self.total_miles =  default_volunteers * miles_each if miles_each.present?
    tot = default_miles * MilageRate
    return tot.round(2)
  end
  
  def default_expenses
    self.expenses ||= 0.0
  end

  def default_miles
    self.total_miles || 0.0
  end

  def default_hours
    self.total_hours || 0.0
  end

  def default_volunteers
    self.volunteers || 1
  end

  
  def total_cost
    (milage_cost + hour_cost + default_expenses).round(2)
  end

  def set_defaults
    self.default_volunteers
    self.hour_cost
    self.milage_cost
    self.default_expenses
  end

  def self.set_date(date=nil)
   return date if date.class == Date
   return Date.today if date.blank?
   date = Date.parse(date) rescue Date.today
  end


end
