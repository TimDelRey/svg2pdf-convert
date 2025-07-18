class CreateConversionRecords < ActiveRecord::Migration[8.0]
  def change
    create_table :conversion_records do |t|
      t.string :status, default: "svg is not loaded"
      t.boolean :cropping_fields, null: false, default: false
      t.boolean :watermark, null: false, default: false

      t.timestamps
    end
  end
end
