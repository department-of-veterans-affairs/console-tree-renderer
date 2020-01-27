# frozen_string_literal: true

#require 'console_tree_renderer/version'

describe 'ConsoleRenderer' do
  it "has a version number" do
    expect(ConsoleTreeRenderer::VERSION).not_to be nil
  end

  it "does something useful" do
    renderer = ConsoleTreeRenderer::ConsoleRenderer.new()
    expect(renderer).not_to be_nil
    expect(true).to eq(true)
  end
end
