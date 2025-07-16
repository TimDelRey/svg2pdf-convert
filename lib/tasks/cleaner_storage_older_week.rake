namespace :storage do
  desc "Удалить SVG и PDF файлы из Active Storage старше недели"
  task cleanup_old_files: :environment do
    cutoff_date = 1.week.ago

    attachments = ActiveStorage::Attachment
                    .joins(:blob)
                    .where("active_storage_blobs.created_at < ?", cutoff_date)
                    .where("active_storage_blobs.filename LIKE ? OR active_storage_blobs.filename LIKE ?", "%.svg", "%.pdf")

    puts "Найдено #{attachments.count} файлов для удаления..."

    attachments.find_each do |attachment|
      blob = attachment.blob
      puts "Удаляем файл: #{blob.filename} (создан: #{blob.created_at})"

      attachment.purge
    end

    puts "Очистка завершена."
  end
end
