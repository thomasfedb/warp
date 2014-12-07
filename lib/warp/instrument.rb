module Warp
  class Instrument
    class << self
      def for(klass, method)
        @@registry ||= {}
        @@registry[klass] ||= {}
        @@registry[klass][method] || new(klass, method)
      end

      private

      def register(instrument)
        @@registry ||= {}
        @@registry[instrument.klass] ||= {}
        @@registry[instrument.klass][instrument.method] = instrument        
      end
    end

    attr_accessor :klass, :method, :hook, :enabled, :calls

    def initialize(klass, method)
      self.klass = klass
      self.method = method
      self.enabled = false
      self.calls = []
      setup_hook

      self.class.send(:register, self)
    end

    def run
      enable
      yield
      disable
    end

    def enabled?
      enabled
    end

    def log(args)
      calls << args
    end

    private

    def enable
      self.enabled = true
    end

    def disable
      self.enabled = false
    end

    def setup_hook
      if Module.method_defined?(:prepend)
        self.hook = Module.new

        hook.send(:define_method, method) do |*args|
          if Warp::Instrument.for(self.class, __method__).enabled?
            Warp::Instrument.for(self.class, __method__).log(args)
          end

          super(*args)
        end

        klass.prepend(hook)
      else
        original_method = klass.instance_method(method)

        klass.send(:define_method, method) do |*args|
          if Warp::Instrument.for(self.class, __method__).enabled?
            Warp::Instrument.for(self.class, __method__).log(args)
          end

          original_method.bind(self).call(*args)
        end
      end
    end
  end
end