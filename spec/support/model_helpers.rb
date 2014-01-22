module ModelHelpers
  def build_model(&blk)
    let(:model) do
      Class.new(ActiveRecord::Base) do
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

        def self.column(name, sql_type = nil, default = nil, null = true)
          columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
        end

        instance_eval(&blk)
      end
    end
  end
end