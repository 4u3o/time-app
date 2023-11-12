require_relative 'time_formatter'
require 'set'

class App
  def call(env)
    request = Rack::Request.new(env)

    return response(404) unless time_request?(request)

    raw_format = request.params['format'] || DEFAULT_FORMAT
    unknown_flags = unknown_flags(raw_format)

    if unknown_flags.any?
      return response(400,
                      content_type: 'text/plain',
                      body: "Unknown time format #{unknown_flags}")
    end

    response(200,
             content_type: 'text/plain',
             body: TimeFormatter.new(raw_format).now)
  end

  private

  DEFAULT_FORMAT = 'year,day,month,hour,minute,second'
  TIME_PATH = '/time'
  VALID_FLAGS = Set['year', 'day', 'month', 'hour', 'minute', 'second']

  def current_flags(raw_format)
    raw_format.split(',').to_set
  end

  def response(status, content_type: '', **options)
    response = Rack::Response.new
    response.status = status
    response.content_type = content_type
    response.write(options[:body])
    response.finish
  end

  def time_request?(request)
    request.path == TIME_PATH && request.request_method == 'GET'
  end

  def unknown_flags(raw_format)
    return [] if raw_format.nil?

    (current_flags(raw_format) - VALID_FLAGS).to_a
  end
end
