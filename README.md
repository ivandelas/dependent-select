# Dependent Select #

dependent-select is a Formtastic 2.0 compatible extension which provides a `select` where the available options depend on the current value of another field.  When the parent field's value is changed, the options of the `dependent_select` are updated via an AJAX request.  Much of the functionality is implemented in a [jQuery plugin](https://github.com/topsail/dependent-select/blob/master/lib/assets/javascripts/dependent-select.js) which could be used independenly of Formtastic.

## Simple Example ##

    <%= semantic_form_for @user do |f| %>
      <%= f.inputs do %>
        <%= f.input :department, :as => :select,
                                 :collection => Department.find(:all) %>
        <%= f.input :division,   :as => :dependent_select,
                                 :parent_method => :department,
                                 :collection => (@user.department ? @user.department.divisions : []) %>
      <% end %>
    <% end %>

In this example each `Department` has many `Divisions`.  Whenever the department field changes value, the division field is updated to contain only the `Divisions` of the selected `Department`.

## URL template ##

The URL used to request the updated option values is controlled by a simple template option, `url_template`, which defaults to:

    /{{plural_parent_resource_name}}/{{value}}/{{plural_resource_name}}.json

In the above example, assuming the selected department ID is 47, this would translate to `/departments/47/divisions.json`

The default URL template can also be overridden globally:

    DependentSelect.default_url_template = '/{{plural_resource_name}}.json?{{parent_resource_name}}={{value}}'

## Option template ##

The server must return JSON records.  The new `option` tags are then generated via the `option_template`, which defaults to:

    <option value="{{id}}">{{name}}</option>

If the returned objects do not have an `id` and `name` attribute, `option_template` must be overridden.

    <%= semantic_form_for @user do |f| %>
      <%= f.inputs do %>
        <%= f.input :department, :as => :select,
                                 :collection => Department.find(:all) %>
        <%= f.input :division,   :as => :dependent_select,
                                 :parent_method => :department,
                                 :option_template => '<option value="{{identifier}}">{{some_name}}</option>',
                                 :collection => (@user.department ? @user.department.divisions : []) %>
      <% end %>
    <% end %>

When you'd like to add a blank option before your returned options, you can set `include_blank` to `true`.

If you wish to change the display text of this blank option, the `blank_option_html` must be overridden and `include_blank` set to `true`.

    <%= semantic_form_for @user do |f| %>
      <%= f.inputs do %>
        <%= f.input :department, :as => :select,
                                 :collection => Department.find(:all) %>
        <%= f.input :division,   :as => :dependent_select,
                                 :parent_method => :department,
                                 :option_template => '<option value="{{identifier}}">{{some_name}}</option>',
                                 :include_blank => true
                                 :blank_option_html => '<option>{{some_text}}</option>'
                                 :collection => (@user.department ? @user.department.divisions : []) %>
      <% end %>
    <% end %>

#To Do:

- Publish to Rubygems

#Contributing

0. Fork it
0. Create your feature branch (git checkout -b my-new-feature)
0. Commit your changes (git commit -am 'Add some feature')
0. Push to the branch (git push origin my-new-feature)
0. Create new Pull Request
