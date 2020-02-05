# frozen_string_literal: true

# interface for a tree-like object
class TreeLikeObject
   # called by config.heading_label_template
  def heading_object(_config)
    #is_a?(Task) ? appeal : self
  end

   # called by rows and used by config.value_funcs_hash
  def row_objects(_config)
    #is_a?(Task) ? appeal.tasks : tasks
  end

  def row_label(_config)
    self.class.name
  end

  def row_children(_config)
    #children.order(:id)
  end

   # returns RootTask and root-level tasks (which are not under that RootTask)
  def rootlevel_rows(config)
    #@rootlevel_rows ||= is_a?(Task) ? [self] : appeal_children(self, config)
  end
end