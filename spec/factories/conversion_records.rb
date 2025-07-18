# == Schema Information
#
# Table name: conversion_records
#
#  id              :bigint           not null, primary key
#  cropping_fields :boolean          default(FALSE), not null
#  status          :string           default("svg is not loaded")
#  watermark       :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
FactoryBot.define do
  factory :conversion_record do
    cropping_fields { false }
    status { 'svg is not loaded' }
    watermark { false }

    after(:build) do |record|
      record.svg_file.attach(
        io: File.open(Rails.root.join('spec/fixtures/files/valid.svg')),
        filename: 'valid.svg',
        content_type: 'image/svg+xml'
      )
    end
  end
end
