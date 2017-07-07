# spec/support/vcr_setup.rb
VCR.configure do |c|
  #the directory where your cassettes will be saved
  c.cassette_library_dir = Rails.root.join("spec","support","vcr")
  # your HTTP request service. You can also use fakeweb, webmock, and more
  c.hook_into :faraday
	c.configure_rspec_metadata!
  c.default_cassette_options = {
    :match_requests_on => [:method,
                           VCR.request_matchers.uri_without_param(:departure_time)]}
end



