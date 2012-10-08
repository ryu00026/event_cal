# -*- coding: utf-8; compile-command: "ruby -rrails -rsocket -ractive_support/all app_config.rb" -*-
#
# 固定値のデフォルト
#
# ・アプリのデフォルト値をこのファイルに記述する
# ・環境毎の差分は config/environments/* でオーバーライドする
#
AppConfig = {
  # ----------------------------------------
  # Redis
  # ----------------------------------------
  :redis_uri => "127.0.0.1:6379",

}


