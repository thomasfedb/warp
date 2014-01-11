module ModelHelpers
  def build_model(&blk)
    let(:model) do
      Class.new(ActiveRecord::Base) do
        def self.columns
          @columns ||= []
        end

        def self.column(name, sql_type = nil, default = nil, null = true)
          columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
        end

        instance_eval(&blk)
      end
    end
  end
end