require_relative 'time_formatter'

class App
  def call(env)
    request = Rack::Request.new(env)

    if time_request?(request)
      time_request_handler(request)
    else
      response(404)
    end
  end

  private

  TIME_PATH = '/time'

  def response(status, content_type: '', **options)
    response = Rack::Response.new
    response.status = status
    response.content_type = content_type
    response.write(options[:body])
    response.finish
  end

  def time_request?(request)
    request.path == TIME_PATH &&
      request.request_method == 'GET' &&
      request.params['format']
  end

  def time_request_handler(request)
    formatter = TimeFormatter.new(request.params['format'])

    if formatter.valid?
      response(200, content_type: 'text/plain', body: formatter.now)
    else
      response(400, content_type: 'text/plain',
               body: "Unknown time format #{formatter.unknown_flags}")
    end
  end
end
