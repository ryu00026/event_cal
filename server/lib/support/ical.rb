module Ical

  def generate_ical(calendar, events,name)
    cal = Icalendar::Calendar.new
     # タイムゾーン (VTIMEZONE) を作成
     cal.timezone do
       tzid 'Asia/Tokyo'
       standard do
         tzoffsetfrom '+0900'
         tzoffsetto   '+0900'
         dtstart      '19700101T000000'
         tzname       'JST'
       end
     end

    cal.prodid("-//iCalPlus 1.0//EN")
    cal.custom_property("X-WR-CALNAME",name)
    cal.custom_property("X-WR-CALDESC",name)
    cal.custom_property("X-WR-TIMEZONE","Asia/Tokyo")

    events.each do |vevent|
      s  = vevent.dtstart
      e  = vevent.dtend
      event = Icalendar::Event.new
      # 終日だとhour,minは不要
      # 終日だと開始日の次の日
      if vevent.all_day?
        event.dtstart = Date.new(s.year, s.month, s.day)
        event.dtend = Date.new(e.year, e.month, e.day)
      else
        event.dtstart = DateTime.new(s.year, s.month, s.day, s.hour, s.min)
        event.dtend = DateTime.new(e.year, e.month, e.day, e.hour, e.min)
#        event.dtstart = s
#        event.dtend = e
      end


      event.summary = vevent.summary
      event.description = vevent.converted_description.html_safe

      #organaizer =  User.find_by_id(schedule.user_id)
      #event.organizer("CN='#{organaizer.name}':mailto:#{organaizer.email}") unless organaizer.blank?
      event.url = vevent.url
      #ORGANIZER;CN=XXXX XXXX:MAILTO:XXXXXXXX@gmail.com → 作成者および連絡先
      #organaizer =  User.find_by_id(schedule.updated_user_id) # 更新者の方がいいのかな？
#      event.created = vevent.created_at.strftime("%Y%m%dT%H%M%SZ")
#      event.last_modified = vevent.updated_at.strftime("%Y%m%dT%H%M%SZ")
      event.uid = vevent.uid
#      event.klass = "PUBLIC"

      # 参加者
      # ATTENDEE;CN="加藤 龍一";CUTYPE=INDIVIDUAL;PARTSTAT=ACCEPTED:mailto:kato@s-gw.co.jp
      # ATTENDEE;CN="山田 太郎";CUTYPE=INDIVIDUAL;ROLE=REQ-PARTICIPANT:mailto:yamada@s-gw.co.jp
      # ATTENDEE;CN="鈴木一朗";CUTYPE=INDIVIDUAL;ROLE=REQ-PARTICIPANT:invalid:nomail
      # ATTENDEE;CN="高橋大輔";CUTYPE=INDIVIDUAL;ROLE=REQ-PARTICIPANT:invalid:nomail

      # 設定値を見る
#      if !user.ical_setting.blank?

#        if user.ical_setting.alerm_flag
#          setting = user.ical_setting
          # アラーム (VALARM) を作成 (複数作成可能)
#          event.alarm do
#            action      "DISPLAY"  # 表示で知らせる
#            trigger     "-PT#{setting.time_number}#{setting.time_section}"    # -PT5M=5分前に, -PT3H=3時間前, -P1D=1日前
            #description "もうすぐだよ。".toutf8  # Googleカレンダでは無視される

            #attendees     %w(mailto:me@my-domain.com mailto:me-too@my-domain.com) # one or more email recipients (required)
            #add_attendee "CN='#{user.full_name}'mailto:#{user.email}"
            #add_attendee "CN='#{user.full_name}';CUTYPE=INDIVIDUAL;ROLE=REQ-PARTICIPANT:invalid:nomail"
            #schedule.members.each do |m|
            #add_attendee "CN='#{m.full_name}',mailto:#{m.email}"
            #  add_attendee "CN='#{m.full_name}';CUTYPE=INDIVIDUAL;ROLE=REQ-PARTICIPANT:invalid:nomail"
            #end
            #add_attendee  "mailto:me-three@my-domain.com"
            #remove_attendee "mailto:me@my-domain.com"

#          end
#        end
#      end
      #event.alarm do
      #  action      "EMAIL"   # メールで知らせる
      #  trigger     "-P1D"    # 1日前に
        #add_attendee "MAILTO:user@example.com"   # Googleカレンダでは無視
        #summary     "明日のインストア".toutf8    # Googleカレンダでは無視
        #description "16:00～ HMV渋谷".toutf8     # Googleカレンダでは無視
      #end

      #event.alarm do
      #  action      "AUDIO"  # 音で知らせる (Googleカレンダでは未サポート)
      #  trigger     "-PT5M"  # 5分前に
      #  repeat      2        # 2回繰り返す
      #  duration    "PT2M"   # 2分間隔で
      #end

      # iCalデータのフォーマットは、
      # BEGIN:VCALENDAR
      # からカレンダー全体の情報（カレンダーの名称、タイムゾーン等）が書かれていて、
      # その後、
      # BEGIN:VEVENT
      # と
      # END:VEVENT
      # に挟まれて、1つのイベントの情報が書かれている。

      # フォーマットとしては、
      # ID;データ内容
      # という形になっている。

      # イベントの情報としては、
      # DTSTART;VALUE=DATE:20061130 → 開始日
      # DTEND;VALUE=DATE:20061201 → 終了日（終日一日の予定の場合、ここには開始日の次の日が入る）
      # （DTEND が無く、代わりに「DURATION:PT5400S」のように継続時間が指定されることがある。）
      # RRULE:FREQ=WEEKLY;BYDAY=MO,TH,FR;WKST=SU → 繰り返し情報
      # DTSTAMP:20061125T004336Z → 入力日?
      # ORGANIZER;CN=XXXX XXXX:MAILTO:XXXXXXXX@gmail.com → 作成者および連絡先
      # UID:XXXXXXXXXXXXXXXX@google.com → ユーザID?
      # CLASS:PRIVATE → 種別?
      # CREATED:20061125T004126Z → 作成日?
      # DESCRIPTION: → 説明
      # LAST-MODIFIED:20061125T004126Z → 最終
      # LOCATION: → 場所
      # SEQUENCE:0 → ?
      # STATUS:CONFIRMED → ?
      # SUMMARY:イベントの題名
      # TRANSP:OPAQUE → ?
      # RECURRENCE-ID:20061128T003000Z → ?

      cal.add event
    end

    cal.publish
    cal
  end

  # 数値文字参照
  # Numerical Character Reference converter
  def num_char_ref(str)
    return str.unpack('U*').collect {|c| c >= 255 ? '&#' + c.to_s + ';' : c.chr }.join
    #NKF.nkf("-w", str).split(//u).collect{|c|
    #  if /[[:alnum:][:space:][:punct:]]/.match(c) then
    #    c
    #  else
    #    "&#" + c.unpack("U*")[0].to_s + ";" ;
    #  end
    #}.join.display
  end


 # 挙動が怪しい
  def generate_text(calendar, events,name)
    str = "BEGIN:VCALENDAR
X-WR-CALNAME:#{name}
CALSCALE:GREGORIAN
METHOD:PUBLISH
PRODID:-//iCalPlus 1.0//EN
VERSION:2.0\n"

    events.each do |vevent|
      str << "BEGIN:VEVENT\n"
      s  = vevent.dtstart
      e  = vevent.dtend
      # 終日だとhour,minは不要
      # 終日だと開始日の次の日
      if vevent.all_day?
        start_date = s.strftime("%Y%m%d")
        end_date = e.strftime("%Y%m%d")
      else
        start_date = s.strftime("%Y%m%dT%H%M%S")
        end_date = e.strftime("%Y%m%dT%H%M%S")
      end

      str << "DTSTART;TZID=Japan:#{start_date}\n"
      str << "DTEND;TZID=Japan:#{end_date}\n"
      str << "URL:#{vevent.url}\n"
      str << "SUMMARY:#{vevent.summary}\n"
      str << "DESCRIPTION:#{vevent.converted_description.html_safe}\n"
      str << "UID:#{vevent.uid}\n"
      #      str << "CLASS:PRIVATE\n"
      str << "END:VEVENT\n"
    end
    str << "BEGIN:VTIMEZONE
TZID:Japan
BEGIN:STANDARD
DTSTART:19390101T000000
TZOFFSETFROM:+0900
TZOFFSETTO:+0900
TZNAME:JST
END:STANDARD
END:VTIMEZONE
END:VCALENDAR"
    str
  end



  def set_timezone
    "cal.timezone do
      tzid 'Asia/Tokyo'
      standard do
        tzoffsetfrom '+0900'
        tzoffsetto   '+0900'
        dtstart      '19700101T000000'
        tzname       'JST'
      end
    end"
  end




  module ExtractTimeFormat
    # 時間のフォーマット
    # 2010/(0)7/(0)7
    # 2010-(0)7-(0)7
    # 2010年(0)7月(0)7日
    def self.parse(str)

    end
  end


  module ItemExtentions
    def self.to_vevent(item)
      event = Icalendar::Event.new
      event.summary = item.title
      event.description = item.description
      event.url = item.link

      event
    end
  end



  # 全日イベントかどうか
  def full_day(event)
    s = event.start
    e = event.end
    s != e && s.hour == 0 && s.min == 0 && e.hour == 0 && e.min == 0
  end

  # 複数日イベントかどうか
  def multi_day(event)
    full_day(event) && (event.start + 1 != event.end)
  end

  def date_str(d)
    wday = $wdays[d.wday]
    "#{d.month}/#{d.day}(#{wday})"
  end

  def time_str(d)
    min = sprintf("%02d", d.min)
    "#{d.hour}:#{min}"
  end


end
