class Panda
  attr_accessor :name 
  attr_accessor :email
  attr_accessor :gender
  
  def initialize(name, email, gender)
    @name = name
    @email = email
    @gender = gender
  end

  def male?
    return true if @gender == "male"
    return false
  end

  def female?
    return true if @gender == "female"
    return false
  end

  def ==(other)
    if @name == other.name
      if @email == other.email
        if @gender == other.gender
          return true
        end
      end
    end

    return false
  end

  def to_s
    str = "#{@name}, #{email}, #{gender}"
  end

  def hash
    self.to_s.hash
  end
end

class PandaSocialNetwork

  attr_accessor :pandas 

  def initialize()
    @pandas = {}
  end

  def add_panda(panda)
    raise "Panda Already There" if has_panda?(panda)
    @pandas[panda] = []
  end

  def make_friends(panda1, panda2)
    raise "Panda Is not There" unless has_panda?(panda1) and has_panda?(panda2)
    @pandas[panda1] << panda2
    @pandas[panda2] << panda1
  end

  def has_panda?(other)
    return true if @pandas.keys.any? {|panda| panda == other}
    false
  end

  def are_friends?(panda1, panda2)
    return true if @pandas[panda1].any? { |panda| panda == panda2 }
    false    
  end

  def friends_of(panda)
    return @pandas[panda] if has_panda?(panda)
    false
  end

  def bfs(from, to)
    queue = Queue.new
    queue.push from
    visited = [from]
    #nodes, next_nodes = @panda[from], []

    while !queue.empty?
      el = queue.shift
      nodes, next_nodes = @pandas[el], []
      puts nodes
      nodes.each do |node|
        unless visited.any? { |e| e == node }
          queue << node
          visited << node
        end
      end
   end

   puts "Program end"
  end

  def connection_level(from, to)
    return false unless has_panda?(from) and has_panda?(to)
    queue, level, visited = Queue.new, 0, [from]
    queue.push Hash[from, level]

    while !queue.empty?
      el = queue.shift
      return el.values.first if el.keys.first == to

      nodes = @pandas[el.keys.first]
      nodes.each do |node|
        unless visited.any? { |e| e == node }
          queue << Hash[node,level+1]
          visited << node
        end
      end
      level += 1
   end

   -1
  end

  def get_nodes(panda)
    [].tap do |arr|
      panda.each do |node|
        arr << node
      end
    end
  end
end
