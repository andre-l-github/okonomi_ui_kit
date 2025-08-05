module OkonomiUiKit
  class TWMerge
    # ---- Public API -----------------------------------------------------------

    # Merge two Tailwind class strings with conflict resolution.
    def self.merge(a, b)
      tokens = "#{a} #{b}".split(/\s+/).reject(&:empty?)
      result = []
      index_by_key = {}

      tokens.each do |tok|
        variants, base = split_variants(tok)
        group = conflict_group_for(base)
        key = [ variants, group || "literal:#{base}" ]

        if index_by_key.key?(key)
          pos = index_by_key[key]
          result[pos] = tok
        else
          index_by_key[key] = result.length
          result << tok
        end
      end

      result.join(" ")
    end

    def self.merge_all(*args)
      args.compact.reduce do |merged, arg|
        merge(merged, arg)
      end
    end

    # Deep-merge two hashes; when both values are strings, merge as Tailwind classes.
    # For other types, the right-hand value wins unless it is nil.
    def self.deep_merge(a, b)
      if a.is_a?(Hash) && b.is_a?(Hash)
        (a.keys | b.keys).each_with_object({}) do |k, h|
          h[k] = deep_merge(a[k], b[k])
        end
      elsif a.is_a?(String) && b.is_a?(String)
        merge(a, b)
      else
        b.nil? ? a : b
      end
    end

    def self.deep_merge_all(*hashes)
      hashes.reduce({}) do |result, hash|
        if hash.is_a?(Hash)
          deep_merge(result, hash)
        else
          raise ArgumentError, "All arguments must be Hashes"
        end
      end
    end

    # ---- Implementation details ----------------------------------------------

    # Conflict groups (minimal, extensible). More specific patterns first.
    CONFLICT_RULES = [
      # Typography
      [ /^text-(?:xs|sm|base|lg|xl|\d+xl|\[\S+\])$/, :text_size ],
      [ /^text-(?:inherit|current|transparent|black|white|[a-z]+-\d{2,3}|[a-z]+-950|\[.+\])$/, :text_color ],
      [ /^font-(?:thin|extralight|light|normal|medium|semibold|bold|extrabold|black)$/, :font_weight ],
      [ /^leading-(?:none|tight|snug|normal|relaxed|loose|\d+|\[.+\])$/, :line_height ],
      [ /^tracking-(?:tighter|tight|normal|wide|widest|\[.+\])$/, :letter_spacing ],

      # Display & position
      [ /^(?:hidden|block|inline|inline-block|flex|inline-flex|grid|inline-grid|table|inline-table|flow-root)$/, :display ],
      [ /^(?:static|fixed|absolute|relative|sticky)$/, :position ],

      # Flexbox
      [ /^flex-(?:row|col|row-reverse|col-reverse)$/, :flex_direction ],
      [ /^flex-(?:wrap|nowrap|wrap-reverse)$/, :flex_wrap ],
      [ /^items-(?:start|end|center|baseline|stretch)$/, :align_items ],
      [ /^justify-(?:start|end|center|between|around|evenly)$/, :justify_content ],

      # Spacing - Padding
      [ /^p(?:-(?:\d+|px|\[\S+\]))?$/, :padding_all ],
      [ /^px(?:-(?:\d+|px|\[\S+\]))?$/, :padding_x ],
      [ /^py(?:-(?:\d+|px|\[\S+\]))?$/, :padding_y ],
      [ /^pl(?:-(?:\d+|px|\[\S+\]))?$/, :padding_left ],
      [ /^pr(?:-(?:\d+|px|\[\S+\]))?$/, :padding_right ],
      [ /^pt(?:-(?:\d+|px|\[\S+\]))?$/, :padding_top ],
      [ /^pb(?:-(?:\d+|px|\[\S+\]))?$/, :padding_bottom ],

      # Spacing - Margin (including negative margins)
      [ /^-?m(?:-(?:\d+|px|auto|\[\S+\]))?$/, :margin_all ],
      [ /^-?mx(?:-(?:\d+|px|auto|\[\S+\]))?$/, :margin_x ],
      [ /^-?my(?:-(?:\d+|px|auto|\[\S+\]))?$/, :margin_y ],
      [ /^-?ml(?:-(?:\d+|px|auto|\[\S+\]))?$/, :margin_left ],
      [ /^-?mr(?:-(?:\d+|px|auto|\[\S+\]))?$/, :margin_right ],
      [ /^-?mt(?:-(?:\d+|px|auto|\[\S+\]))?$/, :margin_top ],
      [ /^-?mb(?:-(?:\d+|px|auto|\[\S+\]))?$/, :margin_bottom ],

      # Gap
      [ /^gap(?:-(?:\d+|px|\[\S+\]))?$/, :gap_all ],
      [ /^gap-x(?:-(?:\d+|px|\[\S+\]))?$/, :gap_x ],
      [ /^gap-y(?:-(?:\d+|px|\[\S+\]))?$/, :gap_y ],

      # Space between children
      [ /^-?space-x(?:-(?:\d+|px|reverse|\[\S+\]))?$/, :space_x ],
      [ /^-?space-y(?:-(?:\d+|px|reverse|\[\S+\]))?$/, :space_y ],

      # Ring
      [ /^ring(?:-(?:\d+|inset|\[\S+\]))?$/, :ring_width ],
      [ /^ring-opacity-(?:\d{1,3}|\[.+\])$/, :ring_opacity ],
      [ /^ring-(?:inherit|current|transparent|black|white|[a-z]+-(?:\d{2,3}|950)|\[[^\]]+\])$/, :ring_color ],
      [ /^ring-offset(?:-(?:\d+|\[\S+\]))?$/, :ring_offset_width ],
      [ /^ring-offset-(?:inherit|current|transparent|black|white|[a-z]+-(?:\d{2,3}|950)|\[[^\]]+\])$/, :ring_offset_color ],

      # Borders
      [ /^(?:border|border-(?:\d+|\[\S+\]))$/, :border_width_overall ],
      [ /^border-[trblxy](?:-\d+|\[\S+\])?$/, :border_width_side ],
      [ /^border-(?:solid|dashed|dotted|double|none)$/, :border_style ],
      [ /^border-(?:inherit|current|transparent|black|white|[a-z]+-\d{2,3}|[a-z]+-950|\[.+\])$/, :border_color ],

      # Radius
      [ /^rounded(?:-(?:none|sm|md|lg|xl|2xl|3xl|full|\[.+\]))?$/, :rounded_overall ],
      [ /^rounded-(?:t|r|b|l|tl|tr|br|bl)-(?:none|sm|md|lg|xl|2xl|3xl|full|\[.+\])$/, :rounded_corner ],

      # Background
      [ /^bg-(?:inherit|current|transparent|black|white|[a-z]+-\d{2,3}|[a-z]+-950|\[.+\])$/, :bg_color ],

      # Overflow & opacity
      [ /^overflow-(?:auto|hidden|visible|scroll|clip)$/, :overflow ],
      [ /^overflow-[xy]-(?:auto|hidden|visible|scroll|clip)$/, :overflow_axis ],
      [ /^opacity-(?:\d{1,3}|\[.+\])$/, :opacity ]
    ].freeze

    class << self
      private

      # "sm:hover:text-lg" -> ["sm:hover", "text-lg"]
      def split_variants(token)
        parts = token.split(":")
        return [ "", token ] if parts.size == 1
        [ parts[0..-2].join(":"), parts[-1] ]
      end

      def conflict_group_for(base)
        rule = CONFLICT_RULES.find { |(rx, _)| base.match?(rx) }
        rule ? rule[1] : nil
      end
    end
  end
end
