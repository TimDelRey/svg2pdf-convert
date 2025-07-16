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
class ConversionRecord < ApplicationRecord
  has_one_attached :svg_file
  has_one_attached :pdf_file

  validates :svg_file, presence: true
end
