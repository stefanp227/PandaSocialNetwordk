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
end

class PandaSocialNetwork
  def initialize()
    @pandas = []
  end

  def add_panda(panda)
    @pandas << panda
  end

  def has_panda?(other)
    return true if @pandas.any? {|panda| panda == other}
    false
  end
