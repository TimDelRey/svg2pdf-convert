class CreateConversionRecords < ActiveRecord::Migration[8.0]
  def change
    create_table :conversion_records do |t|
      t.string :status
      t.text :error_message

      t.timestamps
    end
  end
end
