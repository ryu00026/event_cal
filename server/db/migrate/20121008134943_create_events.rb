# -*- coding: utf-8 -*-
class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :calendar_id, :null => false
      t.string :organizer_cn,:organizer_mailto,:contact, :location, :summary, :url
      t.string :transp, :null => false, :default => "OPAQUE"
      t.text   :description
      t.integer :sequence # 更新回数 カレンダーコンポーネントがはじめて作成された時に0、Organizerによる修正更新があるたびに増分。

      t.timestamp :dtend, :dtstart #, :notice_end, :notice_start # notice はオリジナルの拡張。告知したい時間帯を設定
      t.timestamp :dtstamp, :null => false, :default => Time.current
      t.string :uid, :null => false #なんらかのユニークなID RFC推奨値は hogehoge@example.com
      t.float :lon, :lat
      t.timestamps # last_modifiied , created
      t.timestamp :deleted_at
    end
    add_index(:events, :uid, :unique => true)
  end
end


  #  field :organizer
  #(RFC2445 4.8.4.3) カレンダー･コンポーネントのOrganizer（主催者）情報。グループのスケジュール・カレンダーをもつコンポーネントには必須。
  #ORGANIZER;CN=ryu00026 Mahito:MAILTO:ryu00026@gmail.com

  #field :contact
  #(RFC2445 4.8.4.2) カレンダー･コンポーネントに関連した情報のコンタクト先。

  #field :location
  #例: ↓これはこの特性に関するいくつかの例です:  #   LOCATION:Conference Room - F123, Bldg. 002
  #位置: 会議室--F123、ビルディング 002
  #   LOCATION;ALTREP="http://xyzcorp.com/conf-rooms/f123.vcf":
  #    Conference Room - F123, Bldg. 002

  #field :transp
  #(RFC2445 4.8.2.7) 設定した時間の状態。OPAQUE (デフォルト), TRANSPARENT が指定可能。
  #Outlook では「予定の公開方法」に反映される。これがなかったり TRANSP:OPAQUE だと「予定あり」、TRANSP:TRANSPARENT が指定されていると「空き時間」



#   field :summary, :type => String
#   field :description, :type => String
#   field :last_modified, :type => String
#   field :created, :type => String
#   field :url, :type => String
#   field :sequence, :type => Integer

#   field :created_at, :type => DateTime
#   field :updated_at, :type => DateTime

  # 更新回数 カレンダーコンポーネントがはじめて作成された時に0、Organizerによる修正更新があるたびに増分。


  # iCalの仕様では
  # 終日はDate
  # 通常のイベントはDateTime
  #field :dtend, :type => DateTime
  #field :dtstart, :type => DateTime

  #field :dtstamp, :type => DateTime, :default => DateTime.now
  # オブジェクトの作成日時, もしくはMashupコンテンツ側のcreate時間を入れる？
  #field :ip_class, :type => String
  #field :uid, :type => String
  #index :uid, :unique => true
  # なんらかのユニークなID RFC推奨値は hogehoge@example.com
  # #{api側のid}_#{self.calendar_type}@icalplus.net

  # 検索用にkeywordとか追加する
  #field :calendar_id, :type => Integer
  #field :calendar_type, :type => String
  #field :find_date_key, :type => Date

  # 取り込まれたユーザのカレンダーID
  #field :user_calendar_ids, :type => Array

  # 検索用index
  #field :keywords, :type => Array

  # カテゴリに紐づくID
  #field :category_ids, :type => Array

  # 住所から座標がひけるので共通フィールドとする
  #field :lon, :type => Float
  #field :lat, :type => Float
