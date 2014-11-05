Neighborly::Application.config.session_store(
  :cookie_store,
  domain: '.' + Configuration[:base_domain].split('.').last(2).join('.'),
  key:    Configuration[:secret_token],
)
