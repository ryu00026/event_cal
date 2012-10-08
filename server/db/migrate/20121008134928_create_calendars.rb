class CreateCalendars < ActiveRecord::Migration
  def change
    create_table :calendars do |t|
      t.text :url, :limit => 1000
      t.string :title, :type, :null => false, :limit => 255
      t.text :description
      t.string :key, :limit => 100, :null => false
      t.timestamps
      t.timestamp :deleted_at
    end
    add_index(:calendars, :key, :unique => true)
  end
end
