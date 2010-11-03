class Api::PeopleController < ActionController::Base
  respond_to :json

  # Updates a person via their people aggregator ID
  #
  # Example test via curl:
  # curl --header "Content-type: application/json" -X PUT \
  # http://localhost:8080/api/people-aggregator/person/1 \
  # -d "{'person': { 'name': 'John Foo'}}"
  # 
  def update
    person = Person.find_by_people_aggregator_id(params[:people_aggregator_id])
    if person.nil?
      render :json => "Not Found", :status => 404
    else
      person.api_update(params[:person])

      if person.save
        render :json => "OK", :status => 200
      else
        render :json => person.errors, :status => :unprocessable_entity
      end
    end
  end
end


