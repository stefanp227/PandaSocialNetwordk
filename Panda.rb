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

  require 'json'

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

  def how_many_gender(level, from, gender)
    queue = Queue.new
    queue.push from
    visited = [from]
    this_level, count = 0, 0
    while !queue.empty?

      return count if level == this_level

      el = queue.shift
      nodes, next_nodes = @pandas[el], []
      nodes.each do |node|
        unless visited.any? { |e| e == node }
          queue << node
          visited << node
          count += 1 if node.gender == gender
        end
      end
      this_level += 1
   end
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

  def save(file)
    File.open(file + ".json", "w") { |file| file.write(@pandas.to_json) }
  end

  def new_save(file)
    format = file.reverse.chars.take_while {|chr| chr != '.'}.join.reverse.to_sym
    name = file.reverse.chars.drop_while {|chr| chr != '.'}.drop(1).join.reverse
    #Save.new.public_send format, name, @pandas
    #a = Save.new.method(format).call(name, @pandas)
    CRUDOperations.new(format, :save, name, @pandas)
  end

  def self.load(file)
    
    new_hash = {}

    hash = JSON.parse(File.read(file + ".json"))
    hash.each do |key, values|
      val_pandas = values.map { |value| Panda.new(*value.split(', ')) }
      new_hash[Panda.new(*key.split(', '))] = val_pandas
    end
    PandaSocialNetwork.new.tap do |network|
      network.pandas = new_hash
    end
  end

  def self.new_load(file)
    format = file.reverse.chars.take_while {|chr| chr != '.'}.join.reverse.to_sym
    name = file.reverse.chars.drop_while {|chr| chr != '.'}.drop(1).join.reverse
    CRUDOperations.new(format, :load, name)
  end

end




class CRUDOperations
  def initialize(format, action, name, *args)
    @actions = {}.tap do |hash|
      hash[:save] = args << name
      hash[:load] = [name]
    end

    self.method((format.to_s + "_" + action.to_s).to_sym).call(*@actions[action])
  end

  def json_save(instance, name)
    File.open(name + ".json", "w") { |file| file.write(instance.to_json) }
  end

  def json_load(file)
    new_hash = {}

    hash = JSON.parse(File.read(file + ".json"))
    hash.each do |key, values|
      val_pandas = values.map { |value| Panda.new(*value.split(', ')) }
      new_hash[Panda.new(*key.split(', '))] = val_pandas
    end
    PandaSocialNetwork.new.tap do |network|
      network.pandas = new_hash
    end
  end

  def yaml_save(instance, name)
    File.open(name + ".yaml", "w") do |file|
      file.write instance.to_yaml
    end
  end
end