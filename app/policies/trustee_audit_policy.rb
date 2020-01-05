class TrusteeAuditPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user && user.is_post_user? && user.is_admin?
        scope = Current.post.trustee_audits
      else
        []
      end
    end
  end
end
