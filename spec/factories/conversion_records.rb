# == Schema Information
#
# Table name: conversion_records
#
#  id              :bigint           not null, primary key
#  cropping_fields :boolean          not null
#  error_message   :text
#  status          :string           default("pending")
#  watermark       :boolean          not null
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
