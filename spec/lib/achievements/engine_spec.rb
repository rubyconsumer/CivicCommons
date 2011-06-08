require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")
Dir["#{File.dirname(__FILE__) + "/../../fixtures/achievements"}/**/*.rb"].each {|f| require f}

module Achievements
  describe Engine do
    context "start up" do
      it "will load achievements" do
        Achievements::Engine.should_receive(:load_achievements).once

        Achievements::Engine.startup
      end
    end
    context 'load achievements' do
      it "will read a directory for achievements and register them with the Achievements Directory." do
        Achievements::Directory.achievements = {}
        listing = Achievements::Engine.load_achievements("#{Rails.root}/spec/fixtures/achievements")

        listing.should == {:Blue=>{:default=>["BlueAchievement", "DarkBlueAchievement"]},
                           :Green=>{:default=>["GreenAchievement"]},
                           :Red=>{:default=>["RedAchievement"]},
                          }
      end
    end
    context "process_awards" do
      #before(:each) do
        #AchievementMetadata.create(:title => "some_achievement")
      #end
      let (:some_achievement) { AchievementMetadata.create(:title => "some_achievement") }

      it "will process in an array of users that recieve an award" do
        Achievements::Engine.should_receive(:award_achievements).once.with(some_achievement.id, [1, 2, 3, 4, 5])
        Achievements::Engine.process_awards(:some_achievement, [1, 2, 3, 4, 5])
      end

      it "will process in a hash of awards with users who recieve each award." do
        awards_hash = {1 => [1, 2, 3],
                       7 => [2, 5],
                       5 => [8]
                      }
        Achievements::Engine.should_receive(:award_achievements).once.with(1, [1, 2, 3])
        Achievements::Engine.should_receive(:award_achievements).once.with(7, [2, 5])
        Achievements::Engine.should_receive(:award_achievements).once.with(5, [8])
        Achievements::Engine.process_awards(:some_achievement, awards_hash)
      end
    end

    context "award_achievements" do
      let (:some_achievement) { AchievementMetadata.create(:title => "some_achievement") }
      let (:awarded_person) { Factory.create(:registered_user) }

      it "will log a RecordInvalid exception when trying to create a duplicate record" do
        Achievements::Engine.award_achievements(some_achievement.id, [awarded_person])
        AchievementEarned.should_receive(:create).and_raise(ActiveRecord::RecordInvalid)
        Achievements::Engine.award_achievements(some_achievement.id, [awarded_person])
      end
    end
  end
end

