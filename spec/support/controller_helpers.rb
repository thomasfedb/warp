module ControllerHelpers
  def build_controller
    let(:controller_class) do
      return super() if defined?(super)
      Class.new(ActionController::Metal).tap do |klass|
        klass.include ActionController::Rendering
        klass.send :cattr_accessor, :spec
        klass.spec = self
      end
    end

    let(:controller) { controller_class.new }
  end

  def controller_action(&blk)
    build_controller

    before do
      controller_class.send :define_method, :index do
        instance_eval(&blk)
        render nothing: true
      end
    end

    let(:request) { ActionDispatch::Request.new(ActionDispatch::TestRequest::DEFAULT_ENV.dup) }

    before { controller.dispatch(:index, request) }
  end
end