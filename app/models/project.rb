# frozen_string_literal: true

class Project < ApplicationRecord
  belongs_to :clients, class_name: 'Client', optional: true
end
