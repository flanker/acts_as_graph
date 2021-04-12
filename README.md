# acts_as_graph

A very simple acts as graph for your model

## How to use

If you have a model like this code below:

rubygems.org link: https://rubygems.org/gems/acts_as_graph

```ruby
class Task

  attr_reader :title
  attr_accessor :depended_tasks

  def initialize title, depended_tasks = []
    @title = title
    @depended_tasks = depended_tasks
  end

end
```

Then you could use `acts_as_graph`

```ruby
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
```

And Then:

```ruby
task.descendant_depended_tasks    # returns all the descendant

task.has_circular_reference?    # check if descendant has circular reference
```
