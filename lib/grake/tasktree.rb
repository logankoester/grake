require 'ostruct'

module Grake
  class Task < OpenStruct
  end

  class TaskTree
    attr_accessor :tree
    def initialize(name)
      @tree = Tree::TreeNode.new(name)
    end

    # Accepts either an array or a properly formatted string
    # (NOT a Task object), creates a Task object for it
    # and adds it to the tree.
    # Example: tree = TaskTree.new('rake tasks').add_task(['fruit', 'cake'])
    # ...or...
    # Example: tree = TaskTree.new('rake tasks').add_task('fruit:cake')
    def add_task(task, description = '', parent = @tree)
      task = task.split(':') if task.is_a? String
      current = task.shift
      content = Task.new
      content.command = current
      content.description = description if task.empty?
      if parent[current]
        t = parent[current]
      else
        t = parent << Tree::TreeNode.new(current, content)
      end
      task.empty? ? t : add_task(task, description, t)
    end

    alias << add_task
  end

end
