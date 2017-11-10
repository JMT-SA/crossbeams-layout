# frozen_string_literal: true

module Crossbeams
  module Layout
    # A sortable list of items. Returns ids in a new sequence.
    class SortableList
      # include PageNode
      attr_reader :prefix, :items

      def initialize(page_config, prefix, items)
        raise ArgumentError, 'Prefix must be alphanumeric without spaces' unless valid_prefix?(prefix)
        @prefix      = prefix
        @page_config = page_config
        @items       = Array(items)
        @item_ids    = []
      end

      # Is this node invisible?
      #
      # @return [boolean] - true if it should not be rendered at all, else false.
      def invisible?
        false
      end

      # Is this node hidden?
      #
      # @return [boolean] - true if it should be rendered as hidden, else false.
      def hidden?
        false
      end

      # Render this node as HTML link.
      #
      # @return [string] - HTML representation of this node.
      def render
        <<-HTML
        <ol id="#{prefix}-sortable-items">
        #{item_renders}
        </ol>
        <input type="hidden" name="#{prefix}_sorted_ids" id="#{prefix}-sorted_ids" value="#{item_ids}" size="50"/>
        <script type="text/javascript">
          crossbeamsUtils.makeListSortable('#{prefix}');
        </script>
        HTML
      end

      private

      def valid_prefix?(prefix)
        return false if prefix.match(/\A\d/) # Cannot start with a digit.
        prefix.match?(/\A[a-z0-9]+\Z/i)      # Must be made up of letters and digits only.
      end

      def item_renders
        @item_ids = []
        @items.map do |text, id|
          @item_ids << id
          %(<li id="si_#{id}" class="crossbeams-draggable"><span class="crossbeams-drag-handle">&nbsp;&nbsp;&nbsp;&nbsp;</span>#{text}</li>)
        end.join("\n")
      end

      def item_ids
        @item_ids.join(',')
      end
    end
  end
end
