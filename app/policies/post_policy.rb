class PostPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.is_super?
        scope.all
      else
        if user.is_post_user? && user.is_admin?
          scope.where(numb:Current.post.numb)
        elsif user.is_district_user? && user.is_admin?
          scope.where(district_id:user.district,department:user.department)
        elsif user.is_department_user? && user.is_admin?
          scope.where(department:user.department)
        else
          scope.where(numb:Current.post.numb)
          #bug if not admin
        end
      end
    end
  end
end
