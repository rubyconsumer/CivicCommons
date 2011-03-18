class UnsubscribeDigestController < ApplicationController

  def unsubscribe_me
    @person = Person.find(params[:id])
  end

  def remove_from_digest
    @person = Person.find(params[:id])
    @person.update_attributes(daily_digest: false)
    redirect_to root_path
  end

end
