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
class ConversionRecord < ApplicationRecord
  has_one_attached :svg_file, dependent: :purge_later
  has_one_attached :pdf_file, dependent: :purge_later

  validates :svg_file, presence: true
end
