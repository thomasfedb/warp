module ControllerHelpers
  def build_controller
    let(:controller_class) do
      return super() if defined?(super)
      Class.new(ActionController::Metal).tap do |klass|
        klass.instance_eval do
          def helper_method(*_); end
        end

        klass.include ActionController::Rendering
        klass.include ActionController::Flash

        klass.send :cattr_accessor, :spec
        klass.spec = self
      end
    end

    let(:request) do
      ActionDispatch::TestRequest.new(ActionDispatch::TestRequest::DEFAULT_ENV.dup).tap do |request|
        request.class_eval do
          def flash
            @env[ActionDispatch::Flash::KEY] ||= ActionDispatch::Flash::FlashHash.new
          end
        end
      end
    end

    let(:controller) do
      controller_class.new.tap do |controller|
        controller.instance_variable_set(:@_request, request)
      end
    end
  end

  def controller_action(&blk)
    build_controller

    before do
      controller_class.send :define_method, :index do
        instance_eval(&blk)
        render nothing: true
      end
    end

    before { controller.dispatch(:index, request) }
  end
end