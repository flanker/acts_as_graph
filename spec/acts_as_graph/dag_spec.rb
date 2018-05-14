require 'spec_helper'

module ActsAsGraph
  RSpec.describe Dag do

    class Task

      include ActsAsGraph

      acts_as_graph children: :depended_tasks

      attr_reader :title
      attr_accessor :depended_tasks

      def initialize title, depended_tasks = []
        @title = title
        @depended_tasks = depended_tasks
      end

    end

    it 'sorts as topological order' do
      task_1 = Task.new 'task_1'
      task_2 = Task.new 'task_2'
      task_3 = Task.new 'task_3'
      task_4 = Task.new 'task_4'
      task_5 = Task.new 'task_5'
      task_6 = Task.new 'task_6'
      task_7 = Task.new 'task_7'
      task_8 = Task.new 'task_8'

      task_2.depended_tasks = [task_1]
      task_3.depended_tasks = [task_2]
      task_4.depended_tasks = [task_2]
      task_6.depended_tasks = [task_5]
      task_7.depended_tasks = [task_3, task_4]
      task_8.depended_tasks = [task_2, task_3]

      dag = Dag.new [task_8, task_7, task_6, task_5, task_4, task_3, task_2, task_1]

      result = dag.topological_sort
      expect(result.length).to eq(8)
      expect(result).to match_array([task_1, task_2, task_3, task_8, task_4, task_7, task_5, task_6])
    end

  end
end
