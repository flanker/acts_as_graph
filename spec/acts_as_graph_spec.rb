require 'spec_helper'

RSpec.describe ActsAsGraph do

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

  class Job

    attr_reader :title

    def initialize title
      @title = title
    end
  end

  context '#descendant_depended_tasks' do

    it 'should get all descendant tasks' do
      task_1 = Task.new 'task_1'
      task_2 = Task.new 'task_2'
      task_3 = Task.new 'task_3', [task_1, task_2]

      descendant_depended_tasks = task_3.descendant_depended_tasks
      expect(descendant_depended_tasks.length).to eq(2)
      expect(descendant_depended_tasks).to match_array([task_1, task_2])
    end

    it 'should handle the circular reference' do
      task_1 = Task.new 'task_1'
      task_2 = Task.new 'task_2', [task_1]
      task_3 = Task.new 'task_3', [task_2]
      task_1.depended_tasks = [task_3]

      descendant_depended_tasks = task_3.descendant_depended_tasks
      expect(descendant_depended_tasks.length).to eq(2)
      expect(descendant_depended_tasks).to match_array([task_1, task_2])
    end

    it 'should handle a more complex case' do
      task_1 = Task.new 'task_1'
      task_2 = Task.new 'task_2'
      task_3 = Task.new 'task_3'
      task_4 = Task.new 'task_4'
      task_5 = Task.new 'task_5'
      task_6 = Task.new 'task_6'
      task_1.depended_tasks = [task_2]
      task_2.depended_tasks = [task_3, task_4]
      task_3.depended_tasks = [task_1, task_5, task_6]
      task_4.depended_tasks = [task_5]

      descendant_depended_tasks = task_1.descendant_depended_tasks
      expect(descendant_depended_tasks.length).to eq(5)
      expect(descendant_depended_tasks).to match_array([task_2, task_3, task_4, task_5, task_6])
    end

    it 'supports other type of object as a child' do
      task_1 = Task.new 'task_1'
      task_2 = Task.new 'task_2'
      job_1 = Job.new 'job_1'
      task_1.depended_tasks = [task_2, job_1]

      descendant_depended_tasks = task_1.descendant_depended_tasks
      expect(descendant_depended_tasks.length).to eq(2)
      expect(descendant_depended_tasks).to match_array([task_2, job_1])
    end
  end

  context '#has_circular_reference?' do

    it 'works if there is no circular reference' do
      task_1 = Task.new 'task_1'
      task_2 = Task.new 'task_2', [task_1]
      task_3 = Task.new 'task_3', [task_1, task_2]

      expect(task_3.has_circular_reference?).to be false
    end

    it 'works if there is a child vertice references the starting vertice' do
      task_1 = Task.new 'task_1'
      task_2 = Task.new 'task_2'
      task_3 = Task.new 'task_3'

      task_1.depended_tasks = [task_2]
      task_2.depended_tasks = [task_3]
      task_3.depended_tasks = [task_1]

      expect(task_1.has_circular_reference?).to be true
      expect(task_2.has_circular_reference?).to be true
      expect(task_3.has_circular_reference?).to be true
    end

    it 'works if the circular reference has longer path' do
      task_1 = Task.new 'task_1'
      task_2 = Task.new 'task_2'
      task_3 = Task.new 'task_3'
      task_4 = Task.new 'task_4'

      task_1.depended_tasks = [task_2]
      task_2.depended_tasks = [task_3]
      task_3.depended_tasks = [task_4]
      task_4.depended_tasks = [task_1]

      expect(task_1.has_circular_reference?).to be true
      expect(task_2.has_circular_reference?).to be true
      expect(task_3.has_circular_reference?).to be true
      expect(task_4.has_circular_reference?).to be true
    end

    it 'works if there are two vertices reference with each other' do
      task_1 = Task.new 'task_1'
      task_2 = Task.new 'task_2'
      task_3 = Task.new 'task_3'

      task_1.depended_tasks = [task_2]
      task_2.depended_tasks = [task_3]
      task_3.depended_tasks = [task_2]

      expect(task_1.has_circular_reference?).to be true
      expect(task_2.has_circular_reference?).to be true
      expect(task_3.has_circular_reference?).to be true
    end

    it 'works in complex case' do
      task_1 = Task.new 'task_1'
      task_2 = Task.new 'task_2'
      task_3 = Task.new 'task_3'
      task_4 = Task.new 'task_4'

      task_2.depended_tasks = [task_1]
      task_3.depended_tasks = [task_1, task_2]
      task_4.depended_tasks = [task_2, task_3]

      # expect(task_2.has_circular_reference?).to be false
      # expect(task_3.has_circular_reference?).to be false
      expect(task_4.has_circular_reference?).to be false
    end

    it 'supports other type of object as a child' do
      task_1 = Task.new 'task_1'
      job_1 = Job.new 'job_1'
      task_1.depended_tasks = [job_1]

      expect(task_1.has_circular_reference?).to be false
    end
  end

end
