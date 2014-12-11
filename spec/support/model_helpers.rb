module ModelHelpers
  def build_model(&blk)
    let(:model) do
      Class.new(ActiveRecord::Base) do
        attr_accessor :id
        
        def self.name
          "TestModel"
        end

        def self.primary_key
          "id"
        end

        def self.columns
          @columns ||= []
        end

        def self.attribute_names
          @columns.map(&:name)
        end

        def self.attribute_method?(method)
          method = method.to_s.sub("=", "")
          columns.any? {|c| c.name == method }
        end

        def self.column(name, sql_type = "varchar(255)", default = nil, null = true)
          if ActiveRecord::ConnectionAdapters::AbstractAdapter.method_defined?(:lookup_cast_type)
            cast_type = ActiveRecord::ConnectionAdapters::AbstractAdapter.new(nil, nil, nil).lookup_cast_type(sql_type)
            columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, cast_type, sql_type.to_s, null)
          else
            columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
          end
        end

        instance_eval(&blk) if blk
      end
    end
  end
end