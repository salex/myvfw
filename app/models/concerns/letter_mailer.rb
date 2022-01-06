class LetterMailer < Prawn::Document

  def initialize(members,err=nil)
    super( top_margin:0 , left_margin:0, right_margin:0, bottom_margin:0)
    @members = members
    @err = err
    # stroke_axis
    stroke_color "aaaaaa"

    make_pdf
  end

  def make_pdf
    font_size 11
    @members.each do |member|
      draw_ticks
      draw_address(member)
      draw_content(member)
      start_new_page
    end
    
  end

  def draw_ticks
    move_down 264 
    stroke_line [0,cursor],[20,cursor]
    stroke_line [592,cursor],[612,cursor]

    move_down 264
    # make_pdf
    stroke_line [0,cursor],[20,cursor]
    stroke_line [592,cursor],[612,cursor]

  end

  def draw_address(member)
    bounding_box [50,780], width:500 do
      image(Rails.root.join('app/assets/images/vfw_logo2.jpg'),width:100 ) 
      text "VFW Wilson-Parris Post 8600"
      text "817 Rainbow Dr"
      text "Gadsden AL, 35901"
    end

    bounding_box [100,620], width:300 do
      font_size 13
      text "#{member.first_name} #{member.mi} #{member.last_name}"
      text member.address
      text "#{member.city}, #{member.state}  #{member.zip}"
    end
    font_size 11
  end

  def draw_content(member)
    days_remaining = nil
    bounding_box [50,550], width:500 do
      text "The purpose of the letter is twofold:"
      indent 8 do
        text "* Distribute a letter from the Commander of VFW Post 8600 to all members that includes important information on our current status and plans. The letter is on the back of this page"
        text "* Request that you validate your basic contact and status information and provide any changed or missing information."
      end
      move_down 10
      text "Your current information:"
      rows = []
      rows << ["Member Status:",member.status]
      rows << ["Pay Status:",member.pay_status]
      if  member.status != 'Life' && member.paid_thru.present?
        rows << [ "Paid thru:",member.paid_thru]
        days_remaining = (Chronic.parse(member.paid_thru).to_date - Date.today).to_i
        rows <<["Days Remaining:",days_remaining]
      end
      rows << ["Phone:",member.phone.present? ? member.phone : "Missing"]
      rows << ["eMail:",member.email.present? ? member.email : "Missing"]
      rows << ["Address", "#{member.address}
        #{member.city}, #{member.state} #{member.zip}"]
      e = make_table rows,:cell_style => {:padding => [2, 5, 2, 5] ,border_color:"cccccc"}, 
        :column_widths => [100, 200] do

          column(0).align = :right
          # row(-1).align = :right
      end
      e.draw
      if @err.present?
        move_down 11
        text "We attempted to contact you by your eMail address: <b>#{member.email}</b> but the eMail address was not found", inline_format: true
      end
      move_down 11
      text "If any of the information is wrong or you have missing information, please contact the Post to make corrections. You've received this letter because you do not have an eMail address. We seldom contact all members but providing an eMail would reduce the costs."
      move_down 11 
      text "You can eMail the post at <b>vfwpost8600@gmail.com</b> and identify changes or corrections.", inline_format: true
      move_down 11 
      text "You can call the post at <b>256-546-2440</b> and identify changes/corrections or leave a voice mail. We have very limited open hours but we've added a 'Voice Attendant'. You can press '2' during the voice attendant message and leave a voice mail. ", inline_format: true
      move_down 11
      if days_remaining.present? && days_remaining < 0
        text "Your VFW membership has expired. Please contact the Post and we may be able to help you with your membership dues."
        move_down 11
      end

    end
  end

end