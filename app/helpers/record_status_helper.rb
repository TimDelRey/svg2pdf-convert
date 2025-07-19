module RecordStatusHelper
  def form_status(record)
    content_tag :div, class: 'status' do
      if record.status == 'svg is loaded'
        content_tag(:p, '✅ Ready to convertation')
      else
        content_tag(:p, '⏱️ Waiting for SVG upload')
      end
    end
  end
end
