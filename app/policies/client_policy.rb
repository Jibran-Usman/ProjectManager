# frozen_string_literal: true

class ClientPolicy < ApplicationPolicy
  attr_reader :user, :client

  def initialize(user, client)
    @user = user
    @client = client
  end

  def index?
    user.manager? || user.admin?
  end

  def show?
    user.manager? || user.admin?
  end

  def create?
    user.manager? || user.admin?
  end

  def new?
    user.manager? || user.admin?
  end

  def update?
    user.manager? || user.admin?
  end

  def edit?
    user.manager? || user.admin?
  end

  def destroy?
    user.manager? || user.admin?
  end
end
