class HashToStruct
  attr_accessor :struct
  def initialize(h)
    @struct = new_struct(h)
  end

  def to_struct(h)
    Struct.new(*h.keys.map(&:to_sym)).new(*h.values)
  end

  def new_struct(ahash)
    struct = to_struct(ahash)
    puts struct
    struct.members.each do |m|
      add_hash(struct,m) if struct[m].is_a? Hash
      add_array(struct,m) if struct[m].is_a? Array 
    end
    struct 
  end

  def new_struct(ahash)
    struct = ahash.to_struct
    puts struct
    struct.members.each do |m|
      struct[m] = struct[m].to_struct if struct[m].is_a? Hash
    end
    struct 
  end


  def add_hash(struct,member)
    struct[member] = new_struct(struct[member])
  end

  def add_array(struct,array)
    struct[array].each_with_index do |elem,i|
      struct[array][i] = new_struct(elem) if elem.is_a? Hash
      struct[array][i] = add_array(struct[array][i],elem) if elem.is_a? Array 
    end
  end

end