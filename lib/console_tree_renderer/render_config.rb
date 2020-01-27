
# renderer's configuration
class RendererConfig
  attr_accessor :highlight_char,
                :default_atts,
                :heading_transform, :heading_transform_funcs_hash,
                :heading_label_template,
                :value_funcs_hash,
                :include_border,
                :col_sep, :top_chars, :bottom_chars,
                :heading_fill_str, :cell_margin_char, :func_error_char

  attr_accessor :custom

  def initialize
    @highlight_char = '*'
    @func_error_char = '-'
    @heading_transform = :upcase_headings
    @default_atts = [:id, :created_at, :updated_at]
    @heading_label_template = ->(headingObj) { "#{headingObj.class.name} #{headingObj} " }
    @custom = {}

    # built-in functions that generate column values for each row
    @value_funcs_hash = {}

    # initialize build-in functions that format the column heading labels
    @heading_transform_funcs_hash = {
        nochange_headings: ->(key, _col_obj) { key },
        upcase_headings: ->(key, _col_obj) { key.upcase },
        symbol_headings: ->(key, _col_obj) { ":#{key}" },
        clipped_upcase_headings: ->(key, col_obj) { key[0..[0, col_obj[:width] - 1].max].upcase }
    }
  end
end
