class Event < ActiveRecord::Base
  acts_as_paranoid
  attr_accessible :calendar_id, :organizer_cn,:organizer_mailto,:contact, :location, :summary, :url, :transp
  :description, :sequence, :dtend, :dtstart, :dtstamp, :uid, :lon, :lat


  class Atnd
    include Support::Xml
    def self.get
      src = parse
      doc = REXML::Document.new(src)
      events = []
      doc.elements.each('/hash/events/event') do |event|
        uid_localpart = to_ruby_type(event.elements["event_id"])
        events << {
          :price =>  to_ruby_type(event.elements["prace"]),
          :accepted => to_ruby_type(event.elements["accepted"]),
          #:event_id => event[7].to_i, #event_id
          :uid => "#{uid_localpart}@atnd.icalplus.net",
          #:updated_at => event[9].to_datetime, #updated_at
          :last_modified => to_ruby_type(event.elements["updated_at"]),
          :owner_twitter_id => to_ruby_type(event.elements["owner_twitter_id"]),
          #:title => event[13], #title
          :summary => to_ruby_type(event.elements["title"]),
          #:ended_at => event[15].to_datetime, #ended_at
          :dtend => to_ruby_type(event.elements["ended_at"]),
          :waiting => to_ruby_type(event.elements["waiting"]),
          :event_url => to_ruby_type(event.elements["event_url"]),
          :url => to_ruby_type(event.elements["url"]),
          :owner_twitter_img => to_ruby_type(event.elements["owner_twitter_img"]),
          :owner_nickname => to_ruby_type(event.elements["owner_nickname"]),
          :catch => to_ruby_type(event.elements["catch"]),
          :description => to_ruby_type(event.elements["description"]),
          :owner_id => to_ruby_type(event.elements["owner_id"]),
          :join_limit => to_ruby_type(event.elements["limit"]),
          #             :lon => to_ruby_type(event.elements["lon"]),
          #             :lat => to_ruby_type(event.elements["lat"]),
          :lon => event.elements["lon"].text,
          :lat => event.elements["lat"].text,
          :location => to_ruby_type(event.elements["address"]),
          #:started_at => event[39].to_datetime #started_at
          :dtstart => to_ruby_type(event.elements["started_at"])
        }
      end # doc.elements.each


      #Icalendar::parse()
      # TODO
      # calendarにatnd専用のレコードを定義
      # そのカレンダーIDを持つデータとしてmongodbに保存？
      # 最初はDBに保存して、最後にmongodbに入れる？
      calendar = Calendar.where(:key => "ATND").first
      events.each do |event|
        uid = Event.where(:uid => "#{event[:uid]}")
        begin
          unless uid
            properties = event.merge({:calendar_id => calendar.id})
            Event.create(properties)
          else
            # 更新されてるか？
            if atnd_event.last_modified != event[:last_modified]
              atnd_event.update_attributes!(event)
            end
          end
        rescue => e
          Rails.logger.error <<-ERROR
AtndEvent save error.
#{(event || []).to_yaml}
==========
#{e}
ERROR
        end
      end # events.each
    end # class Atnd

  end
end
