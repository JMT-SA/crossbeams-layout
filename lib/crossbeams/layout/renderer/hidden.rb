# frozen_string_literal: true

module Crossbeams
  module Layout
    module Renderer
      # Render a hidden Field.
      class Hidden < Base
        def configure(field_name, field_config, page_config)
          @field_name   = field_name
          @field_config = field_config
          @page_config  = page_config
          @caption      = field_config[:caption] || present_field_as_label(field_name)
        end

        def render
          <<-HTML
            <input type="hidden" value="#{CGI.escapeHTML(value.to_s)}" #{name_attribute} #{field_id} />
          HTML
        end

        private

        # FIXME: allows for hard-coded value to be used from form_values
        #        when the ROM::Struct does not include the field.
        def value
          res = form_object_value
          res = override_with_form_value(res)
          res
        end
      end
    end
  end
end
