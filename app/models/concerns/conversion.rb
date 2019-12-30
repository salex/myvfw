class Conversion
  attr_accessor :deposits, :old_register, :post, :last5 #:inventories #monday following reporting week

  def initialize(post=nil)
    @deposits = {}
    @post = post
    Current.post = @post

  end

  def create_super
    user = User.find_by(email:'salex@mac.com')
    if user.blank?
      User.create(password:'crap',user_type: "PostUser", email: "salex@mac.com", username: "salex", full_name: "Steven V Alex", roles: ["super"], reset_token: "", post: 8600, district: 2, department: "Alabama")
      # User.create(email:'salex@mac.com',password:'crap',username:'salex',full_name:'Steve Alex',roles:['super'])
    end
  end

  def import_myvfw
    ImportDept.new
    Current.post = Post.find_by(numb:8600)
    @post = Current.post
    suser = create_super
    import_members
    import_officers
    import_markup
    import_reports
  end

  def fix_admin_user
    User.where(user_type:'PostUser').each do |u|
      if u.roles.blank?
        u.roles << 'admin'
        u.save
      end
    end
  end

  def fix_all_user
    User.all.each do |u|
      if u.roles.blank?
        u.roles << 'admin'
        u.save
      end
    end
  end


  # def import_vfw_post
  #   get_deposit_dates
  #   create_super
  #   # import stuff from development, not imported directly
  #   # import_register 
  #   import_inventory_item
  #   import_markup
  #   # now the files exportd from vfw-post
  #   import_inventories
  #   import_donations
  #   import_sales
  #   import_program_reports
  #   import_member_csv_files
  #   import_officers
  #   Deposit.all.each{|d| d.update_stuff}
  #   Donation.where(item:'Pull Tabs').update_all(item:'Canteen')
  #   Donation.where(item:'Yatzee').update_all(item:'Food')

  # end

  # def get_old_register
  #   @old_register = {
  #     "2"=>{:new_key=>"Beer_Special", :old_key=>"Beer_Special"}, 
  #     "1"=>{:new_key=>"Beer_Regular", :old_key=>"Beer_Reg"}, 
  #     "41"=>{:new_key=>"Beer_Regular_HH", :old_key=>"Beer_HH 1.50"}, 
  #     "42"=>{:new_key=>"Beer_Special_HH", :old_key=>"Beer_HH 2.00"}, 
  #     "3"=>{:new_key=>"Beer_Misc", :old_key=>"Beer_Misc Beer"}, 
  #     "4"=>{:new_key=>"Liquor_Bar", :old_key=>"Liquor_Bar"}, 
  #     "5"=>{:new_key=>"Liquor_Mid", :old_key=>"Liquor_Mid"}, 
  #     "6"=>{:new_key=>"Liquor_Top", :old_key=>"Liquor_Top"}, 
  #     "44"=>{:new_key=>"Liquor_Bar_HH", :old_key=>"Liquor_HHL 2.00"}, 
  #     "7"=>{:new_key=>"Liquor_Mid_HH", :old_key=>"Liquor_HHl 2.50"}, 
  #     "43"=>{:new_key=>"Liquor_Top_HH", :old_key=>"Liquor_HHL 3.00"}, 
  #     "8"=>{:new_key=>"Liquor_Pitcher", :old_key=>"Liquor_Pitcher"}, 
  #     "9"=>{:new_key=>"Liquor_Cup", :old_key=>"Liquor_Cup"}, 
  #     "10"=>{:new_key=>"Liquor_Misc", :old_key=>"Liquor_Misc"}, 
  #     "18"=>{:new_key=>"Misc_Snack", :old_key=>"Misc_Snacks"}, 
  #     "19"=>{:new_key=>"Misc_NuBreath", :old_key=>"Misc_Nubreath"}, 
  #     "20"=>{:new_key=>"Misc_Ice", :old_key=>"Misc_Ice"}, 
  #     "45"=>{:new_key=>"ML_Absolut", :old_key=>"Ml200_Absolut"}, 
  #     "11"=>{:new_key=>"ML_Mist", :old_key=>"Ml200_Mist"}, 
  #     "12"=>{:new_key=>"ML_Beam", :old_key=>"Ml200_Beam"}, 
  #     "13"=>{:new_key=>"ML_Rum", :old_key=>"Ml200_Rum"}, 
  #     "14"=>{:new_key=>"ML_Vodka", :old_key=>"Ml200_Vodka"}, 
  #     "15"=>{:new_key=>"ML_Jose", :old_key=>"Ml200_Jose"}, 
  #     "16"=>{:new_key=>"Soft_Coke", :old_key=>"Soft_Coke"}, 
  #     "17"=>{:new_key=>"Soft_Water", :old_key=>"Soft_Btl_water"},
  #     "21"=>{:new_key=>"Payout_Canteen", :old_key=>"Payout:Canteen"},
  #     "23"=>{:new_key=>"Payout_Canteen", :old_key=>"Payout:Canteen"}
  #   }
  #   @old_register.each do |okey,data|
  #     reg = Register.find_by(key:data[:new_key])
  #     if reg.present?
  #       data[:reg_id] = reg.id
  #     else
  #       p "CANT FIND #{data[:new_key]}"
  #     end
  #   end

  # end

  # def get_deposit_dates
  #   filepath = Rails.root.join("db/conversion","deposits.yaml")
  #   dates = YAML.load_file(filepath)

  #   dates.each do |i|
  #     from = Date.parse(i[0])
  #     to = Date.parse(i[1])
  #     deposit = Deposit.find_or_initialize_by(date_to:to)
  #     if deposit.new_record?
  #       deposit.date_from = from
  #       deposit.save
  #       deposits[to] = deposit.id
  #     else
  #       deposits[to] = deposit.id
  #     end
  #     deposits
  #   end
  # end

  # def export_register
  #   filepath = Rails.root.join("db/conversion","registers.yaml")
  #   register = Register.all.as_json(except:[:id,:created_at,:updated_at]).to_yaml
  #   File.write(filepath,register)
  # end

  # def import_register
  #   filepath = Rails.root.join("db/conversion","registers.yaml")
  #   registers = YAML.load_file(filepath)
  #   registers.each do |r|
  #     Register.create(r)
  #   end
  # end

  # def export_inventory_item
  #   filepath = Rails.root.join("db/conversion","inventory_items.yaml")
  #   inventory_item = InventoryItem.all.as_json(except:[:id,:created_at,:updated_at]).to_yaml
  #   File.write(filepath,inventory_item)
  # end

  # def import_inventory_item
  #   filepath = Rails.root.join("db/conversion","inventory_items.yaml")
  #   inventory_items = YAML.load_file(filepath)
  #   inventory_items.each do |r|
  #     InventoryItem.create(r)
  #   end
  # end

  # def import_program_reports
  #   filepath = Rails.root.join("db/conversion","program_reports.yaml")
  #   program_reports = YAML.load_file(filepath)
  #   program_reports.each do |r|
  #     nr = ProgramReport.find_or_initialize_by(type_report:r['type_report'],date:r['date'])
  #     if r['details'].blank?
  #       r['details'] = r['remarks']
  #       r['remarks'] = ''
  #       r['details'] = 'Missing' if r['details'].blank?
  #     end
  #     ok = nr.update(r)
  #     unless ok
  #       p nr.errors
  #     end
  #   end
  # end

  # def import_member_csv_files
  #   members = File.join(Rails.root,'db/conversion/members')
  #   files = Dir.foreach(members) do |f|
  #     if f.include?('.csv')
  #       fp = File.expand_path(f,members)
  #       afile = File.open(fp)
  #       Member.import(afile)
  #     end
  #   end
  # end

  def import_officers
    # this is create only Need to comment out before actions (set_current)
    # Might work now after setting Current.post in initializes
    @post.officers.all.destroy_all
    filepath = Rails.root.join("db/conversion","officers.yaml")
    officers = YAML.load_file(filepath)
    officers.each do |r|
      vfw_id = r.delete('vfw_id')
      m = Member.find_by(vfw_id:vfw_id)
      if m.present?
        r['member_id']= m.id
        @post.officers.create(r)
      end
    end
  end

  def export_members
    filepath = Rails.root.join("db/conversion","members.yaml")
    members = Member.order(:id).as_json(except:[:id,:created_at,:updated_at]).to_yaml
    File.write(filepath,members)
  end

  def import_members
    filepath = Rails.root.join("db/conversion","members.yaml")
    markups = YAML.load_file(filepath)
    markups.each do |r|
      @post.members.create(r)
    end
  end


  def export_program_reports
    filepath = Rails.root.join("db/conversion","program_reports.yaml")
    reports = ProgramReport.all.as_json(except:[:id,:created_at,:updated_at]).to_yaml
    File.write(filepath,reports)
  end

  def import_reports
    filepath = Rails.root.join("db/conversion","program_reports.yaml")
    markups = YAML.load_file(filepath)
    markups.each do |r|
      @post.reports.create(r)
    end
  end

  def import_markup
    filepath = Rails.root.join("db/conversion","markups.yaml")
    markups = YAML.load_file(filepath)
    markups.each do |r|
      @post.markups.create(r)
    end
  end

  def export_markup
    filepath = Rails.root.join("db/conversion","markups.yaml")
    markup = Markup.all.as_json(except:[:id,:created_at,:updated_at]).to_yaml
    File.write(filepath,markup)
  end


  # def import_inventories
  #   filepath = Rails.root.join("db/conversion","inventories.yaml")
  #   inventories = YAML.load_file(filepath)
  #   inventories.each do |i|
  #     date = i.delete('date')
  #     date -= 1.day
  #     i['inventory_type'] = 'ML' if i['inventory_type'] == 'Ml200'
  #     deposit_id = deposits[date]
  #     if deposit_id.present?
  #       inventory = Inventory.find_or_initialize_by(date:date,inventory_type:i['inventory_type'])
  #       if inventory.new_record?
  #         inventory.deposit_id = deposit_id
  #         inventory.update(i)
  #       else
  #         if inventory.deposit_id.blank?
  #           inventory.deposit_id = deposit_id
  #           inventory.save
  #         end
  #       end
  #     end
  #   end
  #   Inventory.where(inventory_type:'Ml200').update_all(inventory_type:'ML')
  # end

  # def import_donations
  #   filepath = Rails.root.join("db/conversion","donation.yaml")
  #   donations = YAML.load_file(filepath)
  #   donations.each do |d|
  #     date = d['date'] - 1.day
  #     deposit_id = deposits[date]
  #     if deposit_id.present?
  #       deposit = Deposit.find_by(id:deposit_id)
  #       if deposit.present? and deposit.donations.count.zero?
  #         d['data'].each do |donated|
  #           donated = donated.permit!.to_h if donated.is_a?(ActionController::Parameters)
  #           donated['fund'] = 'G+R' if donated['fund'] == "General+Relief"
  #           deposit.donations.create(donated)
  #         end
  #       end
  #     end
  #   end

  #   return nil
  # end

  # def import_sales
  #   filepath = Rails.root.join("db/conversion","ztape.yaml")
  #   isales = YAML.load_file(filepath)
  #   get_old_register
  #   isales.each do |h|
  #     date = h['date'].is_a?(Date) ? h['date'] : Date.parse(h['date'])
  #     dep =  Deposit.find_by(date_to: date.end_of_week)
  #     if dep.present?
  #       ds = dep.daily_sales.find_or_initialize_by(date:date)
  #       # if ds.new_record?
  #         # ds = dep.daily_sales.new(date:date)
  #         ds.reg_sales = h["normalize_object"][:totals]['sales'].to_f
  #         ds.over_under = h["normalize_object"][:totals]['over_under'].to_f
  #         ds.payouts = h["normalize_object"][:totals]['payouts'].to_f
  #         ds.sales_deposit = h["normalize_object"][:totals]['dept_totals'].to_f
  #         ds.save
  #       # end
  #       sales = h["normalize_object"][:sales]
  #       sales.each_pair do |dept,items|
  #         items.each_pair do |acct_id,data|
  #           unless data['qty'].zero?
  #             new_keys = old_register[acct_id]
  #             item = ds.sales_items.find_or_initialize_by(register_id:new_keys[:reg_id], date:ds.date)
  #             item.reg_key = new_keys[:new_key]
  #             item.amount = data['amt']
  #             item.quanity = data['qty']
  #             item.save
  #           end
  #         end
  #       end
  #       payout = h["normalize_object"][:other]['payout']
  #       amount = 0.0
  #       whom = ''
  #       what = ''
  #       eacct = ''
  #       new_keys = old_register['21']
  #       payout.each_pair do |acct_id,data|
  #         unless data['amt'].zero?
  #           amount += data['amt']
  #           whom += data['whom'].blank? ? data['whom'] : ", #{data['whom']}"
  #           what += data['what'].blank? ? data['for'] : ", #{data['for']}"
  #           eacct += data['item'].blank? ? data['item'] : ", #{data['item']}"
  #         end
  #       end
  #       unless amount.zero?
  #         item = ds.sales_items.find_or_initialize_by(register_id:new_keys[:reg_id], date:ds.date)
  #         item.reg_key = new_keys[:new_key]
  #         item.amount = amount
  #         item.remarks = "whom:#{whom}|what:#{what}|item:#{eacct}"
  #         item.save
  #       end
  #     end
  #   end
  #   return nil
  # end

  # def fix_beer
  #   sales_items = SalesItem.where(register_id:5)
  #   sales_items.each do |si|
  #     if si.amount / si.quanity = 2.00
  #       si.register_id = 10
  #       si.reg_key = 'Beer_Special_HH'
  #       si.save
  #     end
  #   end
  # end


end