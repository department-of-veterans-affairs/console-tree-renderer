# frozen_string_literal: true
require 'securerandom'

# A tree-like object for testing
class TreeLikeObject

  module RenderModule
    def treee(*atts, **kwargs)
      puts tree(*atts, **kwargs) # rubocop: disable Rails/Output
    end

    # :reek:FeatureEnvy
    def tree(*atts, **kwargs)
      #kwargs[:highlight_row] = Task.find(kwargs.delete(:highlight)) if kwargs[:highlight]
      renderer = kwargs.delete(:renderer) || global_renderer
      renderer.tree_str(self, *atts, **kwargs)
    end

    # for easy access to the global_renderer
    # :reek:UtilityFunction
    def global_renderer
      RenderModule.global_renderer
    end

    def self.global_renderer
      @global_renderer ||= new_renderer
    end

    def self.new_renderer # rubocop:disable all
      ConsoleTreeRenderer::ConsoleRenderer.new.tap do |ttr|
        ttr.config.default_atts = [:id, :name]
        ttr.config.heading_label_template = lambda { |holder|
          "#{holder.class.name} #{holder.id}"
        }
        ttr.config.custom["show_all_rows"] = true
      end
    end
  end

  class TreeHolder
    include RenderModule

    attr_reader :id, :root
    def initialize
      @id = "Holder-" + SecureRandom.uuid.to_s
      @root = TreeLikeObject.new(holder: self)
    end

    # called by config.heading_label_template
    def heading_object(_config)
      self
    end

    def row_objects(_config)
      self.root.row_objects(_config)
    end

    def rootlevel_rows(config)
      [self.root]
    end
  end

  attr_reader :holder, :parent, :children
  attr_reader :id

  def initialize(parent: nil, holder: nil)
    @id = SecureRandom.uuid
    @children = []
    @parent = parent
    @parent.add_child(self) if @parent
    @holder = @parent.holder if @parent
    @holder = holder
  end

   # called by config.heading_label_template
  def heading_object(_config)
    holder
  end

   # called by rows and used by config.value_funcs_hash
  def row_objects(_config)
    [self] + self.children.flat_map{ |c| c.row_objects(_config) }.compact
  end

  def row_label(_config)
    self.class.name
  end

  def row_children(_config)
    self.children
  end

   # returns root and root-level rows (which may not be under that root)
  def rootlevel_rows(config)
    [self.holder.root]
  end

  protected

  def add_child(child)
    @children << child
  end

end
