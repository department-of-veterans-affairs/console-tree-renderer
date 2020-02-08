# frozen_string_literal: true

require 'console_tree_renderer/tree_like_object'

# rubocop: disable Metrics/BlockLength
describe 'ConsoleRenderer' do
  it 'has a version number' do
    expect(ConsoleTreeRenderer::VERSION).not_to be nil
    expect(ConsoleTreeRenderer::VERSION).to be_a String
    expect(ConsoleTreeRenderer::VERSION.count('.')).to eq 2
  end

  context 'given TreeLikeObject' do
    before(:all) do
      @tree_holder = TreeLikeObject::TreeHolder.new
      root = @tree_holder.root
      child1 = TreeLikeObject.new(parent: root)
      child2 = TreeLikeObject.new(parent: root)
      TreeLikeObject.new(parent: child1)
      TreeLikeObject.new(parent: child2)
      TreeLikeObject.new(parent: child2)
    end

    it 'returns a renderer' do
      expect(@tree_holder.global_renderer).not_to be_nil
    end

    context '#tree is called on an tree_holder' do
      it 'returns all row_objects for the tree_holder' do
        rows_hash, metadata = @tree_holder.tree_hash
        expect(rows_hash.count).to eq 1
        expect(metadata.rows.count).to eq @tree_holder.row_objects.count
        expect(@tree_holder.tree.lines.count).to eq @tree_holder.row_objects.count + 3
      end

      it 'returns only specified attributes' do
        _rows_hash, metadata = @tree_holder.tree_hash(:id, :status)
        expect(metadata.col_metadata.values.map{ |v| v[:label]}).to eq %w[ID STATUS]
      end

      it "returns dereferenced column chain '[:assigned_to, :type]'" do
        @tree_holder.treee(:id, %i[assigned_to type])
        _rows_hash, metadata = @tree_holder.tree_hash(:id, %i[assigned_to type])
        expect(metadata.col_metadata.values.map{ |v| v[:label]}).to eq ['ID', '[:ASSIGNED_TO, :TYPE]']
        @tree_holder.row_objects.each do |row|
          expect(metadata.rows[row]['[:assigned_to, :type]']).to eq row.assigned_to.type
        end
      end

      it 'uses specified column labels' do
        atts = [:id, :status, :assigned_to, %i[parent id], %i[assigned_to type]]
        col_labels = ["\#", 'Status', 'AssignedTo', 'P_ID', 'ASGN_TO']
        @tree_holder.treee(*atts, col_labels: col_labels)
        _rows_hash, metadata = @tree_holder.tree_hash(*atts, col_labels: col_labels)

        expect(metadata.col_metadata.values.map{ |v| v[:label]}).to eq col_labels
      end

      it 'returns column values that result from calling the specified lambda' do
        @tree_holder.global_renderer.config.value_funcs_hash['ASGN_TO.TYPE'] = ->(row) { row.assigned_to.type }
        @tree_holder.global_renderer.config.value_funcs_hash[:ASGN_TO_ID] = ->(row) { row.assigned_to.id }

        error_char = @tree_holder.global_renderer.config.func_error_char
        @tree_holder.treee(:id, :status, 'ASGN_TO.TYPE', :ASGN_TO_ID)
        _rows_hash, metadata = @tree_holder.tree_hash(:id, :status, :assigned_to_type, 'ASGN_TO.TYPE', :ASGN_TO_ID)
        @tree_holder.row_objects.each do |row|
          expect(metadata.rows[row]['ASGN_TO.TYPE']).to eq row.assigned_to&.type
          # expect(metadata.rows[row]['ASGN_TO.TYPE']).to eq error_char
        end
      end

      context '#tree is called on a row' do
        def check_for_highlight(calling_obj, metadata, row_to_highlight)
          highlight_char = @tree_holder.global_renderer.config.highlight_char
          expect(metadata.rows[row_to_highlight][' ']).to eq highlight_char

          calling_obj.row_objects.each do |row|
            expect(metadata.rows[row][' ']).to eq ' ' unless row == row_to_highlight
          end
        end

        it 'highlights self row with an asterisk' do
          row_to_highlight = @tree_holder.row_objects.sample
          row_to_highlight.treee(' ', :id, :status)
          _rows_hash, metadata = row_to_highlight.tree_hash(' ', :id, :status)
          check_for_highlight(row_to_highlight, metadata, row_to_highlight)
        end

        it 'highlights specified row with an asterisk, even if no columns are specified' do
          row_to_highlight = @tree_holder.row_objects.sample
          @tree_holder.root.treee(highlight: row_to_highlight.id)
          _rows_hash, metadata = @tree_holder.root.tree_hash(highlight: row_to_highlight.id)
          check_for_highlight(@tree_holder.root, metadata, row_to_highlight)
        end

        it 'highlights specified row with an asterisk, even if highlight column is not specified' do
          row_to_highlight = @tree_holder.row_objects.sample
          @tree_holder.global_renderer.config.default_atts = %i[id status]
          @tree_holder.root.treee(highlight: row_to_highlight.id)
          _rows_hash, metadata = @tree_holder.root.tree_hash(highlight: row_to_highlight.id)
          check_for_highlight(@tree_holder.root, metadata, row_to_highlight)
        end
      end

      context 'custom renderer is used in functions' do
        def tree1(obj, *atts, **kwargs)
          kwargs[:renderer] ||= TreeLikeObject::RenderModule.new_renderer
          kwargs[:renderer].tap do |r|
            r.compact_mode
            r.config.default_atts = %i[id status]
          end
          obj.tree(*atts, **kwargs)
        end

        def tree2(obj, *atts, **kwargs)
          kwargs.delete(:renderer) && raise("Use `tree1` method to allow 'renderer' named parameter!")
          renderer = TreeLikeObject::RenderModule.new_renderer.tap do |r|
            r.compact_mode
            r.config.default_atts = %i[id status]
          end
          renderer.tree_str(obj, *atts, **kwargs)
        end

        it 'prints all row_objects' do
          num_lines = @tree_holder.row_objects.count + 1
          puts tree1 @tree_holder
          puts tree2 @tree_holder, :id, :status
          expect((tree1 @tree_holder).lines.count).to eq num_lines
          expect((tree2 @tree_holder, :id, :status).lines.count).to eq num_lines
        end
        it 'should raise error' do
          expect { tree2 @tree_holder, :id, :status, renderer: 'any value' }.to raise_error(RuntimeError)
        end
      end
    end
  end
end
