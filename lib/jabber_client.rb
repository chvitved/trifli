#!/usr/bin/env ruby

require File.expand_path("../../config/environment.rb", __FILE__)

require 'rubygems'
require 'builder'

require 'xmpp4r/xhtml'
require 'xmpp4r/xhtml/html.rb'

include Jabber

USERNAME = "trifli.trifork@gmail.com"
PASSWORD = "grovbolle"

$client = Client.new(USERNAME)
$client.connect
$client.auth(PASSWORD)
$client.send(Presence.new)

#jobs = Beanstalk::Pool.new(['127.0.0.1:11300'])

def send_message(to, message)
	msg = Message.new
	msg.type = :chat
	msg.to = to
	html = msg.add(XHTML::HTML.new(message))
	msg.body = message
	$client.send(msg)
end

$client.add_message_callback do |m|
  if m.type != :error
    m2 = Message.new(m.from, "You sent: #{m.body}")
    m2.type = m.type
    $client.send(m2)
  end
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
