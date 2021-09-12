module ReportsHelper

  def new_reports_link(post,kind)
    type,area = kind.split(".")
    link_to(area,new_report_path(kind:kind), class:'w3-button w3-block w3-green w3-small w3-left-align')
  end

  def program_options
    opt = []
    Report::ProgramOptions.each do |type,areas|
      areas.each do |a|
        opt << "#{type}.#{a}"
      end
    end
    opt 
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

  def cs_reports
    curr = Date.today.beginning_of_quarter
    dates = [curr]
    15.times do 
      dates << dates.last - 3.months
    end
    return dates
  end


end
