# frozen_string_literal: true

require 'console_tree_renderer/tree_like_object'

describe 'ConsoleRenderer' do
  it "has a version number" do
    expect(ConsoleTreeRenderer::VERSION).not_to be nil
    expect(ConsoleTreeRenderer::VERSION).to be_a String
    expect(ConsoleTreeRenderer::VERSION.count('.')).to eq 2
  end

  context "given TreeLikeObject" do
    before(:all) do
      @tholder = TreeLikeObject::TreeHolder.new
      root = @tholder.root
      child1 = TreeLikeObject.new(parent: root)
      child2 = TreeLikeObject.new(parent: root)
      TreeLikeObject.new(parent: child1)
      TreeLikeObject.new(parent: child2)
      TreeLikeObject.new(parent: child2)
    end

    it "does something useful" do
      renderer = ConsoleTreeRenderer::ConsoleRenderer.new()
      expect(renderer).not_to be_nil
      expect(true).to eq(true)
      pp @tholder.row_objects(nil) #.map(&:id)
      @tholder.treee
    end
  end
end
