# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_and_belongs_to_many :projects
  has_many :time_logs, dependent: :destroy
  has_many :comments, foreign_key: 'commenter_id', dependent: :destroy

  validates :name, presence: true,
                   length: { maximum: 50 },
                   format: { with: /[a-zA-Z\s]*/, message: 'Only letters allowed' }
  validates_inclusion_of :role, in: %w[admin user manager]

  mount_uploader :image, ImageUploader

  enum role: { user: 'user', admin: 'admin', manager: 'manager' }

  def active_for_authentication?
    super && enabled?
  end

  def inactive_message
    'Your account has currently been disabled, please contact website administrator.'
  end

  def self.search(term, user_id)
    users = where.not(id: user_id)
    term.present? ? users.where('name LIKE ?', "%#{term}%").or(users.where('email LIKE ?', "%#{term}%")) : users
  end

  def toggle_message
    enabled? ? email + ' succesfully enabled' : email + ' succesfully disabled'
  end

  def self.employees
    where(role: 'user')
  end
end
