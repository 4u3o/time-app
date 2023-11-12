class TimeFormatter
  def initialize(format)
    @raw_format = format
  end

  def now
    Time.now.strftime(format)
  end

  private

  attr_reader :raw_format

  FLAGS = {
    'year' => '%Y',
    'month' => '%m',
    'day' => '%d',
    'hour' => '%H',
    'minute' => '%M',
    'second' => '%S'
  }
  FORMAT = '%Y-%m-%d %H:%M:%S'

  def flags
    FLAGS.values_at(*raw_flags)
  end

  def format
    format = FORMAT.dup

    unnecessary_flags.each do |flag|
      format.sub!(/[-|:]{1}#{flag}|#{flag}[-|:]{1}|#{flag}/, '')
    end

    format.strip
  end

  def raw_flags
    raw_format.split(',')
  end

  def unnecessary_flags
    FLAGS.values - flags
  end
end
