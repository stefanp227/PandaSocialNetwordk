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

  require_relative 'Graph'
  def initialize()
    @pandas = Graph.new
    @source_node = @pandas.nodes.first
    @path_to = {}
    @distance_to = {}
    compute_shortest_path
  end

  def add_panda(panda)
    raise "Panda Already There" if has_panda?(panda)
    @pandas.add_node(Node.new(panda))
  end

  def make_friends(panda1, panda2)
    raise "Panda Is not There" unless has_panda?(panda1) and has_panda?(panda2)
    @pandas.add_edge(get_panda_node(panda1), get_panda_node(panda2),0)
  end

  def get_panda_node(panda)
    @pandas.nodes.select {|node| node.panda == panda}.first
  end

  def has_panda?(other)
    return true if @pandas.nodes.any? {|node| node.panda == other}
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

  #############################################

  def shortest_path_to(node, source = nil)
    @source_node = source unless source.nil?
    path = []
    while node != @source_node
      path.unshift(node)
      node = @path_to[node]
    end

    path.unshift(@source_node)
    path.length
  end 

  private
  def compute_shortest_path
    update_distance_of_all_edges_to(Float::INFINITY)
    @distance_to[@source_node] = 0

    @pandas.nodes.size.times do
      @pandas.edges.each do |edge|
        relax(edge)
      end
    end
  end

  def update_distance_of_all_edges_to(distance)
    @pandas.nodes.each do |node|
      @distance_to[node] = distance
    end
  end

  def relax(edge)
    if @distance_to[edge.to] > @distance_to[edge.from] + edge.weight
      @distance_to[edge.to] = @distance_to[edge.from] + edge.weight
      @path_to[edge.to] = edge.from
    end
  end
end
