# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    assign_abilities(user) if user.present?
  end

  def assign_abilities(user)
    if user.user?
      user_abilities
    elsif user.manager?
      manager_abilities
    else
      can :manage, :all
    end
  end

  def user_abilities
    can :read, [User, Project] # , Attachment]
    can :update, [User] # , Attachment]
    # can :create, Attachment
    # can :manage, [TimeLog, Comment]
  end

  def manager_abilities
    can %i[read update destroy], User
    can :manage, [Client, Project] # , Payment, Attachment, TimeLog, Comment]
  end
end
