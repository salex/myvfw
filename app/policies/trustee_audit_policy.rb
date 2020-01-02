class TrusteeAuditPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.is_post_user? && user.is_admin?
        scope = Current.post.trustee_audits
      end
    end
  end
end
