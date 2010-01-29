require 'active_support'

module ActiveRecord
  module ConnectionAdapters

    class TableDefinition

      def istring(*args)
        options = args.extract_options!
        column_names = args
        
        column_names.each { |name| column(name, 'istring', options) }
      end
    end

    class PostgreSQLAdapter < AbstractAdapter
      

      def native_database_types_with_istring
        native_database_types_without_istring.merge(
          {
            :istring    => { :name => "citext"},
          }
        )
      end
      alias_method_chain :native_database_types, :istring
      
      class PostgreSQLColumn < Column
        private

          # Maps PostgreSQL's citext to Ruby's string
          def simplified_type_with_istring(field_type)
            return :string if field_type =~ /citext/i
            simplified_type_without_istring(field_type)
          end
          alias_method_chain :simplified_type, :istring
      end

    end

  end
end
