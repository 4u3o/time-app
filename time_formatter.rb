require 'set'

class TimeFormatter
  attr_reader :unknown_flags

  def initialize(format)
    @raw_format = format
    @raw_flags = format.split(',')
    @unknown_flags = []
  end

  def now
    Time.now.strftime(format)
  end

  def valid?
    @unknown_flags = (raw_flags.to_set - FLAGS.keys.to_set).to_a

    unknown_flags.empty?
  end

  private

  attr_reader :raw_format, :raw_flags

  FLAGS = {
    'year' => '%Y',
    'month' => '%m',
    'day' => '%d',
    'hour' => '%H',
    'minute' => '%M',
    'second' => '%S'
  }

  def format
    FLAGS.values_at(*raw_flags).join('-')
  end
end
