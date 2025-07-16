class CreateConversionRecords < ActiveRecord::Migration[8.0]
  def change
    create_table :conversion_records do |t|
      t.string :status, default: "pending"
      t.text :error_message
      t.boolean :cropping_fields, null: false
      t.boolean :watermark, null: false

      t.timestamps
    end
  end
end
