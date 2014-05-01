module Formtastic
  module Inputs
    class DependentSelectInput < Formtastic::Inputs::SelectInput

      def to_html

        html = super()

        html_options = options.delete(:input_html) || {}
        html_options[:id] ||= input_html_id

        if options[:parent_method]

          options[:parent_id] ||=  parent_input_html_id

          child_reflection = reflection_for(method)
          parent_reflection = reflection_for(options[:parent_method])

          if child_reflection && parent_reflection && parent_reflection.macro == :belongs_to
            options[:url_template] ||= DependentSelect.default_url_template
              .gsub('${resource_name}', child_reflection.class_name.underscore)
              .gsub('${plural_resource_name}', child_reflection.class_name.underscore.pluralize)
              .gsub('${parent_resource_name}', parent_reflection.class_name.underscore)
              .gsub('${plural_parent_resource_name}', parent_reflection.class_name.underscore.pluralize)
              .gsub('${parent_parameter}', parent_reflection.foreign_key.to_s)
          end

        end

        unless options[:parent_id].blank? || options[:url_template].blank?

          # convert to camelcase keys, which is the convention in Javascript
          js_options = options.inject({}) do |hash, pair|
            hash[pair[0].to_s.camelize(:lower)] = pair[1]
            hash
          end

          html += "<script>$(document).ready(function() { $('##{html_options[:id]}').dependentSelect('#{options[:parent_id]}', '#{options[:url_template]}', #{js_options.to_json}) });</script>".html_safe

        end

        return html

      end

      def input_html_id
        "#{object_name}_#{input_name}"
      end

      def parent_input_html_id
        "#{object_name}_#{options[:parent_method]}_id"
      end
    end
  end
end
