module ControllerHelpers
  def build_controller(name = :controller)
    let(:controller_name) { name }

    let(:controller_class) do
      Class.new(ActionController::Metal).tap do |klass|
        klass.instance_eval do
          def helper_method(*_); end
        end

        klass.send :include, ActionController::Rendering
        klass.send :include, ActionController::Flash
        klass.send :include, AbstractController::Rendering
        klass.send :include, ActionController::Rendering

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

    let(name) do
      controller_class.new.tap do |controller|
        controller.instance_variable_set(:@_request, request)
      end
    end
  end

  def controller_action(&blk)
    before do
      controller_class.send :define_method, :index do
        instance_eval(&blk)
        render text: ""
      end

      send(controller_name).dispatch(:index, request)
    end
  end
end