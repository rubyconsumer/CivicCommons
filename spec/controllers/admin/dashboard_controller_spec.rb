require 'spec_helper'

describe Admin::DashboardController do

  before :each do
    @admin_person = Factory.create(:admin_person)
    @controller.stub(:current_person).and_return(@admin_person)
  end

  it "renders show action" do
    get :show
    response.should render_template('dashboard/show')    
  end

end
