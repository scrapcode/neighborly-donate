class DropWebhooksTables < ActiveRecord::Migration
  def change
    drop_table :webhook_events do |t|
      t.hstore :serialized_record
      t.string :kind

      t.timestamps
    end
  end
end
