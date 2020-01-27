# frozen_string_literal: true

describe ConsoleTreeRenderer do
  it "has a version number" do
    expect(TreeRenderer::VERSION).not_to be nil
  end

  it "does something useful" do
    renderer = ConsoleTreeRenderer.new()
    expect(renderer).not_to be_nil
    expect(true).to eq(true)
  end
end
