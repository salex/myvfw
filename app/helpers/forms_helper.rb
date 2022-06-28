module FormsHelper

  def hash_to_struct(ahash)
    struct = ahash.to_struct
    struct.members.each do |m|
      add_hash(struct,m) if struct[m].is_a? Hash
      add_array(struct,m) if struct[m].is_a? Array 
    end
    struct 
  end

  def add_hash(struct,member)
    struct[member] = hash_to_struct(struct[member])
  end

  def add_array(struct,array)
    struct[array].each_with_index do |elem,i|
      struct[array][i] = hash_to_struct(elem) if elem.is_a? Hash
      struct[array][i] = add_array(struct[array][i],elem) if elem.is_a? Array 
    end
  end

end
