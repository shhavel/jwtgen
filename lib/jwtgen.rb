require 'jwt'
require 'jwtgen/version'

class Jwtgen
  EMAIL_REGEXP = /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/

  def initialize(opts)
    @payload = opts[:payload]
    raise ArgumentError, 'Option `payload` is required' unless @payload && @payload.is_a?(Hash)
    raise ArgumentError, 'Payload key `user_id` is required' unless @payload[:user_id] && @payload[:user_id] != ''
    raise ArgumentError, 'Payload key `email` is required' unless @payload[:email] && @payload[:email] != ''
    raise ArgumentError, 'Email is invalid' unless @payload[:email] =~ EMAIL_REGEXP
    @key = opts[:key]
    @algorithm = opts.fetch(:algorithm, 'none')
  end

  def encode
    JWT.encode(@payload, @key, @algorithm)
  end
end
