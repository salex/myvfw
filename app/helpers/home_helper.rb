module HomeHelper

  def get_col_size(cnt,columns)
    return 1 if cnt.zero?
    col_size = cnt / columns
    col_size += 1 unless cnt % columns == 0
    return col_size
  end

  def map_count_to_columns(cnt,columns)
    col_size = get_col_size(cnt,columns)
    all_cnts = (0..(cnt-1)).to_a  # 0.upto(cnt-1).map{|i| i}
    mapping = []
    columns.times do |c|
      mapping << all_cnts.shift(col_size)
    end
    mapping
  end
  alias_method :get_col_mapping, :map_count_to_columns

  def get_row_mapping(cnt,columns)
    col_size = get_col_size(cnt,columns)
    all_cnts = (0..(cnt-1)).to_a 
    if col_size <= columns
      mapping = [all_cnts]
    else
      mapping = []
      columns.times do |c|
        mapping << all_cnts.shift(col_size)
      end
    end
    mapping
  end


  def show_table_row(label,data)
    content_tag :tr do
      concat(show_label(label) + show_data(data))
    end
  end

  def show_label(label)
    content_tag :th, label
  end

  def show_data(data)
    content_tag :td, data
  end

  def show_table(resource,instance_var)
    keys = resource.attributes.except("id","created_at","updated_at").keys
    rows = ".show-table.small-12.medium-6.columns\n  table\n"

    keys.each do |key|
      rows += "    = show_table_row('#{key.capitalize}',#{instance_var+'.'+key})\n"
    end
    rows
  end


end
