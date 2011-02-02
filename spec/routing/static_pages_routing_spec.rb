require "spec_helper"

describe StaticPagesController do

  describe "routing" do

    it "recognizes and generates #about" do
      { get: "/about" }.should route_to(controller: "static_pages", action: "about")
    end

    it "recognizes and generates #blog" do
      { get: "/blog" }.should route_to(controller: "static_pages", action: "blog")
    end

    it "recognizes and generates #buld_the_commons" do
      { get: "/build-the-commons" }.should route_to(controller: "static_pages", action: "build_the_commons")
    end

    it "recognizes and generates #contact" do
      { get: "/contact-us" }.should route_to(controller: "static_pages", action: "contact")
    end

    it "recognizes and generates #faq" do
      { get: "/faq" }.should route_to(controller: "static_pages", action: "faq")
    end

    it "recognizes and generates #partners" do
      { get: "/partners" }.should route_to(controller: "static_pages", action: "partners")
    end

    it "recognizes and generates #poster" do
      { get: "/poster" }.should route_to(controller: "static_pages", action: "poster")
    end

    it "recognizes and generates #posters" do
      { get: "/posters" }.should route_to(controller: "static_pages", action: "poster")
    end

    it "recognizes and generates #in_the_news" do
      { get: "/press" }.should route_to(controller: "static_pages", action: "in_the_news")
    end

    it "recognizes and generates #principles" do
      { get: "/principles" }.should route_to(controller: "static_pages", action: "principles")
    end

    it "recognizes and generates #team" do
      { get: "/team" }.should route_to(controller: "static_pages", action: "team")
    end

    it "recognizes and generates #terms" do
      { get: "/terms" }.should route_to(controller: "static_pages", action: "terms")
    end

  end

end
