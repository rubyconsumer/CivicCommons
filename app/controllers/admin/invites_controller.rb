class Admin::InvitesController < Admin::DashboardController

  def index
    @invite_summary = Invite.summary_report
  end

end
