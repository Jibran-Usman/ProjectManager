# frozen_string_literal: true

class Client < ApplicationRecord
  has_many :projects
  validates :name, presence: true,
                   length: { minimum: 2 }
end
