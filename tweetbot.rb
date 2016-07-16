#!/usr/bin/env ruby

require 'rubygems'
require 'oauth'
require 'json'

# You will need to set your application type to
# read/write on dev.twitter.com and regenerate your access
# token.  Enter the new values here:
consumer_key = OAuth::Consumer.new(
  "rPFQdVfLZNAt6I1jcZf8JcKDO",
  "JwwUbm5kZoXg6dhZxIbj4MgD1mb8ZWjrT47cjsExuvAA6FuXJ1")
access_token = OAuth::Token.new(
  "3424185580-U0hpjQATtn22xLAqMZXecyWjOYuWaqIJW3d7tgL",
  "t8f3xueehDMT568h1YXwLvNOldPYsOIsueYbcrUf0iLjH")

# Note that the type of request has changed to POST.
# The request parameters have also moved to the body
# of the request instead of being put in the URL.
baseurl = "https://api.twitter.com"
path    = "/1.1/statuses/update.json"
address = URI("#{baseurl}#{path}")
request = Net::HTTP::Post.new address.request_uri
request.set_form_data(
  "status" => "If you're located in New York's Jefferson or Lewis counties, Call A&R Superior at 315-317-4107 for all your lawn care needs!")

# Set up HTTP.
http             = Net::HTTP.new address.host, address.port
http.use_ssl     = true
http.verify_mode = OpenSSL::SSL::VERIFY_PEER

# Issue the request.
request.oauth! http, consumer_key, access_token
http.start
response = http.request request

# Parse and print the Tweet if the response code was 200
tweet = nil
if response.code == '200' then
  tweet = JSON.parse(response.body)
  puts "Successfully sent #{tweet["text"]}"
else
  puts "Could not send the Tweet! " +
  "Code:#{response.code} Body:#{response.body}"
end
