module WithContextsHelpers
  class WithContextsBuilder
    attr_accessor :contexts, :examples, :group

    def initialize(group)
      @contexts = {}
      @group = group
    end

    def context(name, &blk)
      self.contexts[name] = blk
    end

    def describe(name, &blk)
      self.contexts[name] = blk
    end

    def behaviour(&blk)
      self.examples = blk
    end

    def let(*args, &blk)
      group.let(*args, &blk)
    end

    def before(*args, &blk)
      group.before(*args, &blk)
    end

    def after(*args, &blk)
      group.after(*args, &blk)
    end

    def execute
      contexts.each do |name, blk|
        context = group.context(name)
        context.instance_eval(&blk)
        context.instance_eval(&examples)
      end
    end
  end

  def with_contexts(&blk)
    builder = WithContextsBuilder.new(self)
    builder.instance_eval(&blk)
    builder.execute
  end
end