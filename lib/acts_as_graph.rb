module ActsAsGraph

  def self.included base
    base.extend ClassMethods
  end

  module ClassMethods

    def acts_as_graph children: nil
      @children_method_name = children

      define_method "descendant_#{children}" do
        descendant_vertices
      end
    end

    def children_method_name
      @children_method_name
    end

  end

  def descendant_vertices
    vertices_found = []
    collect_child_vertices vertices_found, starting_vertice: self
    vertices_found
  end

  def collect_child_vertices vertices_found, starting_vertice: nil
    child_vertices.each do |child_vertice|
      next if vertices_found.include?(child_vertice) || child_vertice == starting_vertice
      vertices_found << child_vertice
      child_vertice.collect_child_vertices vertices_found, starting_vertice: starting_vertice
    end
  end

  private

  def children_method_name
    self.class.children_method_name
  end

  def child_vertices
    self.send children_method_name
  end

end
