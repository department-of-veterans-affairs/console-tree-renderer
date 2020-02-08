# console-tree-renderer
Renders tree-like objects and column-aligned attributes for each tree node

Inspect tree-like objects with fewer keystrokes.

Motivations:
* easier column-aligned printout for comparing attributes across rows,
* attribute dereference chaining and flexible transforms,
* customizable column headings,
* and visually appealing.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'console-tree-renderer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install console-tree-renderer


## Development

After checking out the repo, run `bin/setup` to install dependencies. 
Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt 
that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. 
To release a new version, update the version number in `version.rb`, and 
then run `bundle exec rake release`, which will create a git tag for the version, 
push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Usage

See spec file for example usage.

```ruby
> puts tree_holder.tree
# OR
> tree_holder.treee  # <-- avoids having to prepend `puts`
```
```
                                                                       ┌────────────────────────────────────────────────────┐
TreeLikeObject::TreeHolder Holder-c71a3481-c5ec-401f-9efc-2b1c144cdb09 │   │ ID                                   │ STATUS  │
TreeLikeObject                                                         │   │ ad4e104e-2f57-4e02-8adb-706c58f5d10a │ created │
├── TreeLikeObject                                                     │ * │ da076c2f-627f-4b40-9209-249f8f9a3820 │ created │
│   └── TreeLikeObject                                                 │   │ 14ec3168-cd31-4837-beb7-6386d01f2dab │ created │
└── TreeLikeObject                                                     │   │ c5dbb05b-20a7-4ccd-8163-029493f820cf │ created │
    ├── TreeLikeObject                                                 │   │ b9eae1f0-e5b4-4573-a708-4d0d4926b94b │ created │
    └── TreeLikeObject                                                 │   │ 1392f8e0-9cb6-4769-ae42-3e4030223e5f │ created │
                                                                       └────────────────────────────────────────────────────┘
```
Customize the heading label by changing `config.heading_label_template` -- search for instructions below.

Default attributes are shown as columns. 
Customize the default attributes by changing `config.default_atts` -- search for instructions below.

Specify columns to show:
```ruby
> tree_holder.treee(:id, %i[assigned_to type])
# OR
> tree_holder.treee :id, %i[assigned_to type]
```
```
                                                                       ┌──────────────────────────────────────────────────────────────────────────────────┐
TreeLikeObject::TreeHolder Holder-c71a3481-c5ec-401f-9efc-2b1c144cdb09 │ ID                                   │ [:ASSIGNED_TO, :TYPE]                     │
└── TreeLikeObject                                                     │ ad4e104e-2f57-4e02-8adb-706c58f5d10a │ type-e2af231d-3896-4ab7-ad53-cb6650e6c374 │
    ├── TreeLikeObject                                                 │ da076c2f-627f-4b40-9209-249f8f9a3820 │ type-87ed158a-8aa5-4705-a581-e647e1b4011e │
    │   └── TreeLikeObject                                             │ 14ec3168-cd31-4837-beb7-6386d01f2dab │ type-fb67f574-5d4d-4e25-9fba-8ffc06a26bc7 │
    └── TreeLikeObject                                                 │ c5dbb05b-20a7-4ccd-8163-029493f820cf │ type-9ce37381-7a00-4a5a-b3ae-822ea0bda6b0 │
        ├── TreeLikeObject                                             │ b9eae1f0-e5b4-4573-a708-4d0d4926b94b │ type-88a498bf-0a23-484e-ae8c-7287d815c419 │
        └── TreeLikeObject                                             │ 1392f8e0-9cb6-4769-ae42-3e4030223e5f │ type-babdd139-5366-4ac5-b50f-bdc9c51d6c5f │
                                                                       └──────────────────────────────────────────────────────────────────────────────────┘
```

## ASCII and Compact output
The default output is ANSI, which is more visually appealing.
For more compact output without vertical lines and borders:
```ruby
> tree_holder.global_renderer.compact_mode
> tree_holder.treee :id, :status
```
```
TreeLikeObject::TreeHolder Holder-b72a451c-00d7-40a5-a2c9-4f1de9c66088  ID                                   STATUS
└── TreeLikeObject                                                      4cf67a26-5891-4b75-a7e9-b4fe672dddb2 created
    ├── TreeLikeObject                                                  9821516e-9338-4a2c-bcdf-7746e0aa64e3 created
    │   └── TreeLikeObject                                              652a31c2-33e5-40f6-b7f8-3d9088bdffb2 created
    └── TreeLikeObject                                                  bec7b0bf-34d8-4a95-9ae7-32cc50af1a24 created
        ├── TreeLikeObject                                              ece05ddc-f9b0-47ce-8acc-45adbfb43703 created
        └── TreeLikeObject                                              7f214699-e09d-4095-8b4d-3d7af684c6fc created
```

For compatibility with text editors and other tools, change output to use `tree_holder.global_renderer.ansi_mode`:

Restore ANSI outlines by calling `tree_holder.global_renderer.ansi_mode`.

## Attribute Dereferencing and Custom Column Headers
Row attributes can be dereferenced by using an array representing a chain of methods to call.
For example, to show the `type` of the `assigned_to` object, use `[:assigned_to, :type]`.
By default the column heading will be `[:ASSIGNED_TO, :TYPE]`.
To manually set the column headings, use the `col_labels` named parameter as follows:
```ruby
> atts = [:id, :status, :assigned_to, %i[parent id], %i[assigned_to type]]
> col_labels = ["\#", 'Status', 'AssignedTo', 'P_ID', 'ASGN_TO']
> tree_holder.treee(*atts, col_labels: col_labels)
```
```
                                                                       ┌────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
TreeLikeObject::TreeHolder Holder-b72a451c-00d7-40a5-a2c9-4f1de9c66088 │ #                                    │ Status  │ AssignedTo                                     │ P_ID                                 │ ASGN_TO                                   │
└── TreeLikeObject                                                     │ 4cf67a26-5891-4b75-a7e9-b4fe672dddb2 │ created │ #<TreeLikeObject::SomeUser:0x00007fb215939da0> │                                      │ type-8a725f7e-f68a-495a-926b-814e2f0e5c13 │
    ├── TreeLikeObject                                                 │ 9821516e-9338-4a2c-bcdf-7746e0aa64e3 │ created │ #<TreeLikeObject::SomeUser:0x00007fb215939968> │ 4cf67a26-5891-4b75-a7e9-b4fe672dddb2 │ type-7abb60b4-e6cd-4651-9f64-5e7452f0f3c9 │
    │   └── TreeLikeObject                                             │ 652a31c2-33e5-40f6-b7f8-3d9088bdffb2 │ created │ #<TreeLikeObject::SomeUser:0x00007fb2159390f8> │ 9821516e-9338-4a2c-bcdf-7746e0aa64e3 │ type-b9f0a0a6-1a9a-48a1-8b68-3aaf53c79437 │
    └── TreeLikeObject                                                 │ bec7b0bf-34d8-4a95-9ae7-32cc50af1a24 │ created │ #<TreeLikeObject::SomeUser:0x00007fb215939530> │ 4cf67a26-5891-4b75-a7e9-b4fe672dddb2 │ type-17447873-c854-4c7c-b55e-6cae7beb9a7c │
        ├── TreeLikeObject                                             │ ece05ddc-f9b0-47ce-8acc-45adbfb43703 │ created │ #<TreeLikeObject::SomeUser:0x00007fb215938cc0> │ bec7b0bf-34d8-4a95-9ae7-32cc50af1a24 │ type-c1f5818f-0124-44a7-bc27-c6258765952b │
        └── TreeLikeObject                                             │ 7f214699-e09d-4095-8b4d-3d7af684c6fc │ created │ #<TreeLikeObject::SomeUser:0x00007fb215938888> │ bec7b0bf-34d8-4a95-9ae7-32cc50af1a24 │ type-f8d83657-e91f-425d-8a14-ef0bed4f020f │
                                                                       └────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

## Attribute Transforms (using Lambdas)
A more flexible alternative to attribute dereferencing is to use a Ruby lambda to derive values for a column.
In the example below, new columns with column headings `ASGN_TO.TYPE` and `:ASGN_TO_ID` will be included
when the columns are specified as parameters to `tree`.
Note that a string or symbol can be used for the new column.

Call `tree_holder.global_renderer.config.value_funcs_hash` to show a list of available attribute transforms.

For each row in the tree, the specified lambda is called to populate the values under the column.

```ruby
> tree_holder.global_renderer.config.value_funcs_hash['ASGN_TO.TYPE'] = ->(row) { row.assigned_to.type }
> tree_holder.global_renderer.config.value_funcs_hash[:ASGN_TO_ID] = ->(row) { row.assigned_to.id }
> tree_holder.global_renderer.ansi_mode
> tree_holder.treee(:id, :status, 'ASGN_TO.TYPE', :ASGN_TO_ID)
```
```
                                                                       ┌────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
TreeLikeObject::TreeHolder Holder-b72a451c-00d7-40a5-a2c9-4f1de9c66088 │ ID                                   │ STATUS  │ ASGN_TO.TYPE                              │ ASGN_TO_ID                                │
└── TreeLikeObject                                                     │ 4cf67a26-5891-4b75-a7e9-b4fe672dddb2 │ created │ type-8a725f7e-f68a-495a-926b-814e2f0e5c13 │ user-4cf67a26-5891-4b75-a7e9-b4fe672dddb2 │
    ├── TreeLikeObject                                                 │ 9821516e-9338-4a2c-bcdf-7746e0aa64e3 │ created │ type-7abb60b4-e6cd-4651-9f64-5e7452f0f3c9 │ user-9821516e-9338-4a2c-bcdf-7746e0aa64e3 │
    │   └── TreeLikeObject                                             │ 652a31c2-33e5-40f6-b7f8-3d9088bdffb2 │ created │ type-b9f0a0a6-1a9a-48a1-8b68-3aaf53c79437 │ user-652a31c2-33e5-40f6-b7f8-3d9088bdffb2 │
    └── TreeLikeObject                                                 │ bec7b0bf-34d8-4a95-9ae7-32cc50af1a24 │ created │ type-17447873-c854-4c7c-b55e-6cae7beb9a7c │ user-bec7b0bf-34d8-4a95-9ae7-32cc50af1a24 │
        ├── TreeLikeObject                                             │ ece05ddc-f9b0-47ce-8acc-45adbfb43703 │ created │ type-c1f5818f-0124-44a7-bc27-c6258765952b │ user-ece05ddc-f9b0-47ce-8acc-45adbfb43703 │
        └── TreeLikeObject                                             │ 7f214699-e09d-4095-8b4d-3d7af684c6fc │ created │ type-f8d83657-e91f-425d-8a14-ef0bed4f020f │ user-7f214699-e09d-4095-8b4d-3d7af684c6fc │
                                                                       └────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```
The `-` character is used to denote an error occurred when calling the lambda. 
Set `tree_holder.global_renderer.config.func_error_char` to change that character.

## Highlight Specific Row
To highlight a specific row with an asterisk `*`, add the `" "` attribute as follows:

```ruby
> row_to_highlight = @tree_holder.row_objects.sample
> row_to_highlight.treee " ", :id, :status
```
```
                                                                       ┌────────────────────────────────────────────────────┐
TreeLikeObject::TreeHolder Holder-b72a451c-00d7-40a5-a2c9-4f1de9c66088 │   │ ID                                   │ STATUS  │
TreeLikeObject                                                         │   │ 4cf67a26-5891-4b75-a7e9-b4fe672dddb2 │ created │
├── TreeLikeObject                                                     │   │ 9821516e-9338-4a2c-bcdf-7746e0aa64e3 │ created │
│   └── TreeLikeObject                                                 │ * │ 652a31c2-33e5-40f6-b7f8-3d9088bdffb2 │ created │
└── TreeLikeObject                                                     │   │ bec7b0bf-34d8-4a95-9ae7-32cc50af1a24 │ created │
    ├── TreeLikeObject                                                 │   │ ece05ddc-f9b0-47ce-8acc-45adbfb43703 │ created │
    └── TreeLikeObject                                                 │   │ 7f214699-e09d-4095-8b4d-3d7af684c6fc │ created │
                                                                       └────────────────────────────────────────────────────┘
```
By default, the calling row object is highlighted.

To highlight a different row, set the named parameter `highlight` with the row object id like so:
```ruby
> tree_holder.treee highlight: row_to_highlight.id
```

Change the default highlight character (`*`) by setting `tree_holder.global_renderer.config.highlight_char`.

## `global_renderer.config`

Calling `tree_holder.global_renderer` returns the default renderer,
a singleton which is used when the `renderer:` parameter is not provided.

### `:heading_label_template`

The `heading_label_template` is a lambda that generates the heading line.
The `heading_label_template` is evaluated with `self` being the `tree_holder.heading_object` object.

```ruby
> tree_holder.global_renderer.config.heading_label_template = ->(tree_holder){ "#{tree_holder.id}" }
> tree_holder.treee :id, :status
```
```
                                            ┌────────────────────────────────────────────────┐
Holder-752b74be-6160-4747-8d3b-5940743d1c3b │ ID                                   │ STATUS  │
└── TreeLikeObject                          │ 5adad29e-dc59-4518-a9e3-1c0abc71630e │ created │
    ├── TreeLikeObject                      │ 3ff16a04-9592-4cfb-b476-fcf69f4c30f4 │ created │
    │   └── TreeLikeObject                  │ f70cef9d-fcb4-415b-bdd6-8034012800db │ created │
    └── TreeLikeObject                      │ b83052a4-141d-4a2f-9355-558d2803be25 │ created │
        ├── TreeLikeObject                  │ cabfe8f7-c33f-409a-9648-6118902693cf │ created │
        └── TreeLikeObject                  │ 97f5c7f5-16ff-4df6-96af-c375959d3b7b │ created │
                                            └────────────────────────────────────────────────┘
```


### Column Headings Transforms
If named parameter `col_labels` is not specified when calling `tree`, 
a column heading transform is used to create column labels. To see predefined heading transforms, 
run `tree_holder.global_renderer.config.heading_transform_funcs_hash`.

Add your own heading transform like this:
```ruby
> tree_holder.global_renderer.config.heading_transform_funcs_hash[:downcase_headings] = ->(key, _col_obj) { key.downcase };
> tree_holder.global_renderer.config.heading_transform = :downcase_headings
> tree_holder.treee
```
```
                                            ┌────────────────────────────────────────────────────┐
Holder-752b74be-6160-4747-8d3b-5940743d1c3b │   │ id                                   │ status  │
└── TreeLikeObject                          │   │ 5adad29e-dc59-4518-a9e3-1c0abc71630e │ created │
    ├── TreeLikeObject                      │   │ 3ff16a04-9592-4cfb-b476-fcf69f4c30f4 │ created │
    │   └── TreeLikeObject                  │   │ f70cef9d-fcb4-415b-bdd6-8034012800db │ created │
    └── TreeLikeObject                      │   │ b83052a4-141d-4a2f-9355-558d2803be25 │ created │
        ├── TreeLikeObject                  │   │ cabfe8f7-c33f-409a-9648-6118902693cf │ created │
        └── TreeLikeObject                  │   │ 97f5c7f5-16ff-4df6-96af-c375959d3b7b │ created │
                                            └────────────────────────────────────────────────────┘
```

### `:heading_fill_str`

A `heading_fill_str` is used in the top line between the tree_holder label and the column headings.
Change it by setting `tree_holder.global_renderer.config.heading_fill_str` like so:

```ruby
> tree_holder.global_renderer.config.heading_label_template = ->(tree_holder){ "Tree" }
> tree_holder.global_renderer.config.heading_fill_str = ". "
> tree_holder.treee :id, :status
```
```
                           ┌────────────────────────────────────────────────┐
Tree. . . . . . . . . . .  │ id                                   │ status  │
└── TreeLikeObject         │ 5adad29e-dc59-4518-a9e3-1c0abc71630e │ created │
    ├── TreeLikeObject     │ 3ff16a04-9592-4cfb-b476-fcf69f4c30f4 │ created │
    │   └── TreeLikeObject │ f70cef9d-fcb4-415b-bdd6-8034012800db │ created │
    └── TreeLikeObject     │ b83052a4-141d-4a2f-9355-558d2803be25 │ created │
        ├── TreeLikeObject │ cabfe8f7-c33f-409a-9648-6118902693cf │ created │
        └── TreeLikeObject │ 97f5c7f5-16ff-4df6-96af-c375959d3b7b │ created │
                           └────────────────────────────────────────────────┘
```

### Customize Drawing Characters

To customize column separators, internal margins, and customize borders modify other `config` keys.
* Change the column separator by setting `:col_sep`.
* Adjust internal margins by setting `:cell_margin_char` to `""` (empty string) or `"  "` (a longer string).
* Exclude top and bottom borders by setting `:include_border` to false.
* The `:top_chars` and `:bottom_chars` settings are used for the top and bottom borders respectively.
  * The first and fourth characters are used for the corners.
  * The second character is used to draw horizontal lines.
  * The third character is used at the column separator locations.
  * (See `ConsoleTreeRenderer::ConsoleRenderer.write_border` for details).
* Change the highlight character by setting `:highlight_char`.

```ruby
TreeHolder.global_renderer.config.tap do |conf|
  conf.col_sep = " "
  conf.cell_margin_char = ""
  conf.include_border = true
  conf.top_chars = "+-++"
  conf.bottom_chars = "+-++"
  conf.highlight_char = "#"
end
```

See the `RendererConfig.ansi` and `RendererConfig.ascii` functions for reference.

## Customize default renderer in .pryrc

You can customize settings by modifying `TreeHolder.global_renderer.config` in your `.pryrc`
so that it is loaded each time the Rails console is run.
For example, if your `.pryrc` file in the Caseflow top-level directory contains the following:
```ruby
TreeHolder.global_renderer.config.tap do |conf|
  conf.default_atts = [:id, :status, :updated_at, :assigned_to_type, :ASGN_TO]
  conf.heading_fill_str = ". "
end
puts "Tree renderer customized"
```

Then in a Rails console, running `treee` will use your customizations.

## Create your own renderer

You can define your own functions in `.pryrc` that use customized renderers.

The `tree1` method creates a renderer instance, customizes it, and
pass it as part of `kwargs` to the `treee` function.

The `tree2` method creates a renderer instance, customizes it, and
*uses it directly* to call the `tree_str` function.

```ruby
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

```
Then use it like so:
```ruby
> tree1 tree_holder
> tree2 tree_holder
```

## Byebug

Within `byebug`, run `load ".pryrc"` to load the customizations into the current `byebug` environment.
