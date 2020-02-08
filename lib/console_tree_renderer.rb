# frozen_string_literal: true

#Gem.loaded_specs['caseflow'].runtime_dependencies.each do |d|
#  require d.name
#end

module ConsoleTreeRenderer
  # made available for use in lambdas in value_funcs_hash
  def self.send_chain(initial_obj, methods)
    methods.inject(initial_obj) do |obj, method|
      obj.respond_to?(method) ? obj.send(method) : nil
    end
  end
end

require 'console_tree_renderer/console_renderer'
