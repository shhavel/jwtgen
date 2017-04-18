require 'jwt'
require 'jwtgen/version'

class Jwtgen
  EMAIL_REGEXP = /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/

  def initialize(opts)
    raise ArgumentError, 'Option `payload` is required' unless opts[:payload] && opts[:payload].is_a?(Array)
    normalize_and_assign_payload(opts)
    raise ArgumentError, 'Payload key `user_id` is required' unless @payload[:user_id] && @payload[:user_id] != ''
    raise ArgumentError, 'Payload key `email` is required' unless @payload[:email] && @payload[:email] != ''
    raise ArgumentError, 'Email is invalid' unless @payload[:email] =~ EMAIL_REGEXP
    @key = opts[:key]
    @algorithm = opts.fetch(:algorithm, 'none')
  end

  def encode
    JWT.encode(@payload, @key, @algorithm)
  end

  private
  def normalize_and_assign_payload(opts)
    sep = opts.fetch(:separator, '=')
    @payload = opts[:payload].reduce({}) do |acc, kv|
      k, v = kv.split(sep)
      acc[k.to_sym] = v
      acc
    end
  end
end
