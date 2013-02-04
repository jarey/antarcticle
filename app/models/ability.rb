class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, :all

    if user.present?
      can [:update, :destroy], Article, :user_id => user.id
      can [:update, :destroy], Comment, :user_id => user.id
      can :create, Article
      can :create, Comment
      if user.admin?
        can :manage, :all
      end
    end
  end
end
