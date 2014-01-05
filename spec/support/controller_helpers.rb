module ControllerHelpers
  def controller_action(&blk)
    let(:controller_class) do
      Class.new(ActionController::Metal).tap do |klass|
        klass.include ActionController::Rendering
        klass.send :cattr_accessor, :spec
        klass.spec = self

        klass.send :define_method, :index do
          instance_eval(&blk)
          render nothing: true
        end
      end
    end

    let(:controller) { controller_class.new }
    let(:request) { ActionDispatch::Request.new(ActionDispatch::TestRequest::DEFAULT_ENV.dup) }

    before { controller.dispatch(:index, request) }
  end
end