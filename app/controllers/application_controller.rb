class ApplicationController < ActionController::Base
  before_action :clear_expired_session_tokens
  before_action :set_trace_id
  around_action :log_with_trace_id

  def current_user
    @current_user ||= User.with_active_session.find_by(user_sessions: {token: session[:session_token]})
  end

  attr_reader :trace_id
  # makes these attributes available in views
  helper_method :current_user, :trace_id

  def code_cache_key
    "#{@trace_id}_CODE"
  end

  def clear_code_cache
    session.delete(:trace_id)
    Rails.cache.delete(code_cache_key)
  end

  def cast_boolean(value)
    ActiveRecord::Type::Boolean.new.cast(value)
  end

  private

  def set_trace_id
    session[:trace_id] ||= SecureRandom.uuid

    @trace_id = session[:trace_id]
  end

  def clear_expired_session_tokens
    return unless session[:session_token].present?

    user_session = UserSession.find_by(token: session[:session_token])

    if user_session&.expired?
      user_session.destroy
      session.delete(:session_token)
    end
  end

  def log_with_trace_id
    Rails.logger.tagged("trace_id=#{session[:trace_id].first(8)}") do
      yield
    end
  end
end
