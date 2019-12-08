class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  def trustee?
    user.present? && user.is_trustee?
  end

  def admin?
    user.present? && user.is_admin?
  end

  def super?
    user.present? && user.is_super?
  end

  def member?
    user.present? && user.is_member?
  end




  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end
end
