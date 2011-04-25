class Tos
  def self.send_violation_complaint(user, contribution, reason)
    resource = {:user => user, :contribution => contribution, :reason => reason}
    mail = Notifier.violation_complaint(resource)
    mail.deliver
  end
end

