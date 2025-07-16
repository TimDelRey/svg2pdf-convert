# == Schema Information
#
# Table name: conversion_records
#
#  id            :bigint           not null, primary key
#  error_message :text
#  status        :string           default("pending")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
FactoryBot.define do
  factory :conversion_record do
    status { "MyString" }
    error_message { "MyText" }
  end
end
