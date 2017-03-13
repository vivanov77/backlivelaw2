class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
      user ||= User.new # guest user (not logged in)
      if user.has_role? :admin
        can :manage, :all
      else
        # can :manage, User
        can :read, [Question, Comment]
        can [:read, :update], User, id: user.id
        can :read, User do |other_user|
           (user.has_role? :client) && ((other_user.has_role? :lawyer) || (other_user.has_role? :advocate))
        end

        can :create, Question if user.has_role? :client
        can :update, Question, user_id: user.id # if user.has_role? :client
        can :create, Comment if ((user.has_role? :lawyer) || (user.has_role? :advocate))
        can :update, Comment, user_id: user.id # if ((user.has_role? :lawyer) || (user.has_role? :advocate))        
        can :create, Comment do |comment|
           (user.has_role? :client) && (comment.try(:commentable).try(:user_id) == user.id)
        end
      end

    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
