#!/usr/bin/env ruby

require File.expand_path("../../config/environment.rb", __FILE__)
require File.expand_path("../../app/models/attendee.rb", __FILE__)
require File.expand_path("../../app/models/attendance.rb", __FILE__)

require 'rubygems'
require 'builder'

require 'xmpp4r/roster/helper/roster'
require 'xmpp4r/xhtml'
require 'xmpp4r/xhtml/html.rb'

include Jabber

USERNAME = "trifli.trifork@gmail.com"
PASSWORD = "grovbolle"

$client = Client.new(USERNAME)
$client.connect
$client.auth(PASSWORD)
$client.send(Presence.new)

roster = Jabber::Roster::Helper.new($client)

#jobs = Beanstalk::Pool.new(['127.0.0.1:11300'])

def send_message(to, message)
	msg = Message.new
	msg.type = :chat
	msg.to = to
	html = msg.add(XHTML::HTML.new(message))
	msg.body = message
	$client.send(msg)
end

$client.add_presence_callback do |p|
  puts "presence #{p}"
  puts p.type.nil?.to_s

  if (p.type != :unavailable)


  end
end

$client.add_message_callback do |m|
  puts "got message from #{m.from}, state: #{m.chat_state}, body: #{m.body}"

end


loop do
#	job = jobs.reserve
	
#	builder = Builder::XmlMarkup.new
#	xml = builder.div do |b|
#		b.span(job.body); b.hr; b.br; b.br
#		b.a("Yes", :href => '#'); b.br
#		b.a("No", :href => '#')
#	end
#	
#	send_message("chvitved@gmail.com")
#	
#	job.delete
end
