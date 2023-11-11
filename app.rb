class App
  def call(env)
    request = Rack::Request.new(env)
    response = Rack::Response.new

    unless time_request?(request)
      response.status = 404
      return response.finish
    end

    response.content_type = 'text/plain'
    raw_format = request.params['format']

    if raw_format.nil?
      response.write(Time.now.strftime(FORMAT))
      return response.finish
    end

    raw_flags = raw_format.split(',')
    unknown_flags = raw_flags - FLAGS.keys

    if unknown_flags.any?
      response.status = 400
      response.write("Unknown time format #{unknown_flags}")
      return response.finish
    end

    format = create_format(raw_flags)
    response.status = 200
    response.write(Time.now.strftime(format))

    response.finish
  end

  private

  FORMAT = '%Y-%m-%d %H:%M:%S'
  FLAGS = {
    'year' => '%Y',
    'month' => '%m',
    'day' => '%d',
    'hour' => '%H',
    'minute' => '%M',
    'second' => '%S'
  }
  TIME_PATH = '/time'

  def time_request?(request)
    request.path == TIME_PATH && request.request_method == 'GET'
  end

  def create_format(raw_flags)
    format = FORMAT.dup
    flags = FLAGS.values_at(*raw_flags)
    unnecessary_flags = FLAGS.values - flags

    unnecessary_flags.each do |flag|
      format.sub!(/[-|:]{1}#{flag}|#{flag}[-|:]{1}|#{flag}/, '')
    end
    format.strip
  end
end
