require "smarter_csv"


class ImportDept
  def initialize
    p 'Hello CSV'
    Dir.glob(Rails.root.join('db/csv_files','*.csv')) do |rb_file|
    # do work on files ending in .rb in the desired directory
      import_csv(rb_file)
    end
    # tfile = "/Users/salex/work/myvfw/db/csv/Arizona_memstats.csv"
    # import_csv(tfile)
    
  end

  def import_csv(file)
    @state_abrev = {"Alabama"=>"AL", "Alaska"=>"AK", "Arizona"=>"AZ", "Arkansas"=>"AR", "California"=>"CA", "Colorado"=>"CO", "Connecticut"=>"CT", "Delaware"=>"DE", "Florida"=>"FL", "Georgia"=>"GA", "Hawaii"=>"HI", "Idaho"=>"ID", "Illinois"=>"IL", "Indiana"=>"IN", "Iowa"=>"IA", "Kansas"=>"KS", "Kentucky"=>"KY", "Louisiana"=>"LA", "Maine"=>"ME", "Maryland"=>"MD", "Massachusetts"=>"MA", "Michigan"=>"MI", "Minnesota"=>"MN", "Mississippi"=>"MS", "Missouri"=>"MO", "Montana"=>"MT", "Nebraska"=>"NE", "Nevada"=>"NV", "New Hampshire"=>"NH", "New Jersey"=>"NJ", "New Mexico"=>"NM", "New York"=>"NY", "North Carolina"=>"NC", "North Dakota"=>"ND", "Ohio"=>"OH", "Oklahoma"=>"OK", "Oregon"=>"OR", "Pennsylvania"=>"PA", "Rhode Island"=>"RI", "South Carolina"=>"SC", "South Dakota"=>"SD", "Tennessee"=>"TN", "Texas"=>"TX", "Utah"=>"UT", "Vermont"=>"VT", "Virginia"=>"VA", "Washington"=>"WA", "West Virginia"=>"WV", "Wisconsin"=>"WI", "Wyoming"=>"WY"}

    aa = SmarterCSV.process(file,strip_chars_from_headers: /[^A-Za-z0-1_,]/) #, 
    @dept = aa[0][:dept]
    state = aa[0][:state]
    @abrev = @state_abrev[state].downcase
    aa.each do |row|
      @post_numb = row[:post].to_i
      @dist = row[:dst].to_i
      @dept = row[:state]
      if @post_numb.zero? && @dist == 99
        create_dept_user(row)
        next
      end
      if @post_numb.zero? && @dist < 99
        create_dist_user(row)
        next
      end
      next if @post_numb >=15000 || @dist > 99
      @post = Post.find_or_initialize_by(numb:@post_numb)
      @post.name = "VFW Post #{@post_numb}" if @post.name.blank?
      @post.district_id = @dist
      @post.state = row[:state]
      @post.department =  row[:state]
      @post.city = row[:city].titlecase
      create_post_user(row)
      @post.save
    end
  end

  def create_post_user(row)
    username = "post#{@post_numb}"
    u = User.find_or_initialize_by(username:username)
    u.username = username
    u.email = "#{u.username}@alvfw.org"
    u.post = @post_numb
    u.password = "#{u.username}_qm"
    u.user_type = 'PostUser'
    u.save
  end

  def create_dist_user(row)
    username = "#{@abrev}dist#{@dist}"
    u = User.find_or_initialize_by(username:username)
    u.email = "#{u.username}@#{@abrev}vfw.org"
    u.username = username
    u.district = @dist
    u.department = @dept
    u.password = "#{u.username}_qm"
    u.user_type = 'DistrictUser'
    u.save
  end

  def create_dept_user(row)
    username = "#{@abrev}dept"
    u = User.find_or_initialize_by(username:username)
    u.email = "#{u.username}@#{@abrev}vfw.org"
    u.username = username
    u.department = @dept
    u.password = "#{u.username}_qm"
    u.user_type = 'DepartmentUser'
    u.save
  end

end
