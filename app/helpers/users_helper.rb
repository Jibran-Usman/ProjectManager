# frozen_string_literal: true

module UsersHelper
  def enable_or_disable(user)
    user.enabled? ? 'Disabled' : 'Enabled'
  end
end
