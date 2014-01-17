module BeersHelper
      def pluralize(count, singular, plural = nil)
        "#{count || 0} " + ((count == 1 || count == '1') ? singular : (plural || singular.pluralize))
      end
end
