# frozen_string_literal: true

describe 'TreeMetadata' do

  before do
    #obj = MyTree.new

    renderer = ConsoleTreeRenderer::ConsoleRenderer.new()
      #metadata = TreeMetadata.new(obj, renderer.config, func_hash, col_labels)
  end

  after do
  end

  context 'when condition' do
    it 'holds metadata' do
      expect(true).to eq(true)
    end
  end
end