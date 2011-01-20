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

username = "trifli.trifork@gmail.com/bot"
PASSWORD = "grovbolle"

$client  = Client.new(username)
$client.connect
$client.auth(PASSWORD)
$client.send(Presence.new)

#jobs = Beanstalk::Pool.new(['127.0.0.1:11300'])

def send_message(to, message)
  msg      = Message.new
  msg.type = :chat
  msg.to   = to
  html     = msg.add(XHTML::HTML.new(message))
  msg.body = message
  $client.send(msg)
end

def to_email(jid)
  "#{jid.node}@#{jid.domain}"
end

$client.add_presence_callback do |p|
  begin
    return if p.from.nil?

    from = to_email(p.from)

    if p.type != :unavailable

      attendee = Attendee.find_or_create_by_jabber_id(from)

      unless attendee.has_answered_for_tomorrow?
        send_message(from, "kommer du til frokost i morgen?");
      end

    end
  rescue => e
    puts e.message
    puts e.backtrace
  end
end

$client.add_message_callback do |m|
  begin
    puts "got message from #{m.from}, state: #{m.chat_state}, body: #{m.body}"

    from = to_email(m.from)

    if !m.body.nil? && (m.body.include?("ja") || m.body.include?("nej"))

      is_attending = m.body.include?("ja")

      attendee = Attendee.find_by_jabber_id(from)

      unless attendee.nil?
        attendance = Attendance.where("attendee_id = ? and date = ?", attendee.id, Date.tomorrow).first
        attendance ||= attendee.attendances.build(:date => Date.tomorrow)

        attendance.is_attending = is_attending
        attendance.save
        puts "#{m.from} is attending -> #{is_attending} #{Date.tomorrow}"
      end
    end
  rescue => e
    puts e.message
    puts e.backtrace
  end
end

loop do

end


