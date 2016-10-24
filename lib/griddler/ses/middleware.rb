module Griddler
  module Ses
    class Middleware
      def initialize(app)
        @app = app
      end

      def call(env)
        # a bug on the AWS side doesn't set the content type to application/json type properly,
        # so we have to intercept and do this in order for Griddler's controller to correctly
        # parse the parameters (see https://forums.aws.amazon.com/thread.jspa?messageID=418160)
        if is_aws_sns_request?(env)
          env['CONTENT_TYPE'] = 'application/json; charset=UTF-8'
        end

        @app.call(env)
      end

      private
      def is_aws_sns_request?(request)
        request['HTTP_X_AMZ_SNS_MESSAGE_TYPE'].present?
      end
    end
  end
end
