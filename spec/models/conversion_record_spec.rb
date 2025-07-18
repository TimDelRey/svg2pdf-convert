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
require 'rails_helper'

RSpec.describe ConversionRecord, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
