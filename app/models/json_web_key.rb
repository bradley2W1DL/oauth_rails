class JsonWebKey < ApplicationRecord
  encrypts :full_key

  after_create :deactivate_previous_keys

  scope :active, -> { where(active: true) }

  def self.get_active
    active.order(created_at: :desc).limit(1)
  end

  private

  def deactivate_previous_keys
    active.where.not(id:).update_all(active: false)
  end
end
