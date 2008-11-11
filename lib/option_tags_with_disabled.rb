# OptionTagsWithDisabled
module ActionView
  module Helpers
    module FormOptionsHelper

      def select(object, method, choices, options = {}, html_options = {})
        InstanceTag.new(object, method, self, options.delete(:object)).to_select_tag(choices, options, html_options)
      end

      def collection_select(object, method, collection, value_method, text_method, options = {}, html_options = {})
        InstanceTag.new(object, method, self, options.delete(:object)).to_collection_select_tag(collection, value_method, text_method, options, html_options)
      end
      
      def options_for_select(container, selected = nil, disabled = [])
        container = container.to_a if Hash === container

        options_for_select = container.inject([]) do |options, element|
          text, value = option_text_and_value(element)
          selected_attribute = ' selected="selected"' if option_value_selected?(value, selected)
          disabled_attribute = ' disabled="disabled"' if option_value_selected?(value, disabled)
          options << %(<option value="#{html_escape(value.to_s)}"#{selected_attribute}#{disabled_attribute}>#{html_escape(text.to_s)}</option>)
        end

        options_for_select.join("\n")
      end
      
      def options_from_collection_for_select(collection, value_method, text_method, selected = nil, disabled = [])
        options = collection.map do |element|
          [element.send(text_method), element.send(value_method)]
        end
        options_for_select(options, selected, disabled)
      end
      
      def option_groups_from_collection_for_select(collection, group_method, group_label_method, option_key_method, option_value_method, selected_key = nil, disabled = [])
        collection.inject("") do |options_for_select, group|
          group_label_string = eval("group.#{group_label_method}")
          options_for_select += "<optgroup label=\"#{html_escape(group_label_string)}\">"
          options_for_select += options_from_collection_for_select(eval("group.#{group_method}"), option_key_method, option_value_method, selected_key, disabled)
          options_for_select += '</optgroup>'
        end
      end
      
      class InstanceTag #:nodoc:

        def to_select_tag(choices, options, html_options)
          html_options = html_options.stringify_keys
          add_default_name_and_id(html_options)
          value = value(object)
          selected_value = options.has_key?(:selected) ? options[:selected] : value
          disabled_value = options.has_key?(:disabled) ? options[:disabled] : []
          content_tag("select", add_options(options_for_select(choices, selected_value, disabled_value), options, selected_value), html_options)
        end

        def to_collection_select_tag(collection, value_method, text_method, options, html_options)
          html_options = html_options.stringify_keys
          add_default_name_and_id(html_options)
          value = value(object)
          disabled_value = options.has_key?(:disabled) ? options[:disabled] : []
          content_tag(
            "select", add_options(options_from_collection_for_select(collection, value_method, text_method, value, disabled_value), options, value), html_options
          )
        end
      end
      
    end
  end
end