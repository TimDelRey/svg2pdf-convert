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
    cropping_fields { true }
    error_message { nil }
    status { "pending" }
    watermark { true }
  end
end
