# frozen_string_literal: true

require 'securerandom'

# A tree-like object for testing
class TreeLikeObject
  # interface for rendering
  module RenderModule
    def treee(*atts, **kwargs)
      puts tree(*atts, **kwargs)
    end

    # :reek:FeatureEnvy
    def tree(*atts, **kwargs)
      kwargs[:highlight_row] = find_row(kwargs.delete(:highlight)) if kwargs[:highlight]
      renderer = kwargs.delete(:renderer) || global_renderer
      renderer.tree_str(self, *atts, **kwargs)
    end

    # :reek:FeatureEnvy
    def tree_hash(*atts, **kwargs)
      kwargs[:highlight_row] = find_row(kwargs.delete(:highlight)) if kwargs[:highlight]
      renderer = kwargs.delete(:renderer) || global_renderer
      renderer.tree_hash(self, *atts, **kwargs)
    end

    def find_row(id)
      row_objects.find { |r| r.id == id }
    end

    # for easy access to the global_renderer
    # :reek:UtilityFunction
    def global_renderer
      RenderModule.global_renderer
    end

    def self.global_renderer
      @global_renderer ||= new_renderer
    end

    def self.new_renderer
      ConsoleTreeRenderer::ConsoleRenderer.new.tap do |ttr|
        ttr.config.default_atts = %i[id status]
        ttr.config.heading_label_template = lambda { |holder|
          "#{holder.class.name} #{holder.id}"
        }
        ttr.config.custom['show_all_rows'] = true
      end
    end
  end

  class SomeUser
    attr_reader :id, :type
    def initialize(id: nil, type: nil)
      @id = id
      @type = type
    end
  end

  class TreeHolder
    include RenderModule

    attr_reader :id, :root
    def initialize
      @id = 'Holder-' + SecureRandom.uuid.to_s
      @root = TreeLikeObject.new(holder: self)
    end

    # called by config.heading_label_template
    def heading_object(_config = nil)
      self
    end

    def row_objects(_config = nil)
      root.row_objects(_config)
    end

    def rootlevel_rows(_config)
      [root]
    end
  end

  include RenderModule

  attr_reader :holder, :parent, :children
  attr_reader :id, :status, :assigned_to

  def initialize(parent: nil, holder: nil)
    @id = SecureRandom.uuid
    @status = 'created'
    @assigned_to = SomeUser.new(id: "user-#{@id}", type: "type-#{SecureRandom.uuid}")
    @children = []
    @parent = parent
    @parent&.add_child(self)
    @holder = @parent.holder if @parent
    @holder = holder if holder
  end

  # called by config.heading_label_template
  def heading_object(_config = nil)
    holder
  end

  # called by rows and used by config.value_funcs_hash
  def row_objects(_config = nil)
    [self] + children.flat_map { |c| c.row_objects(_config) }.compact
  end

  def row_label(_config)
    self.class.name
  end

  def row_children(_config)
    children
  end

  # returns root and root-level rows (which may not be under that root)
  def rootlevel_rows(_config)
    [holder.root]
  end

  protected

  def add_child(child)
    @children << child
  end
end
