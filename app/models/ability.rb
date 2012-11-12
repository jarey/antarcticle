class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, :all

    if user.present?
      can [:update, :destroy], Article, :user_id => user.id
      can :create, Article
      if user.admin?
        can :manage, :all
      end
    end
  end
end
