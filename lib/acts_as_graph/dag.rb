module ActsAsGraph
  class Dag

    attr_reader :vertices

    def initialize vertices
      @vertices = vertices
    end

    def topological_sort
      visited = []
      post_order = []
      vertices.each do |vertice|
        dfs(vertice, visited, post_order) unless visited.include?(vertice)
      end
      post_order
    end

    private

    def dfs vertice, visited, post_order
      visited << vertice
      vertice.child_vertices.each do |child_vertice|
        dfs(child_vertice, visited, post_order) unless visited.include?(child_vertice)
      end if vertice.respond_to?(:child_vertices)
      post_order << vertice
    end

  end
end
