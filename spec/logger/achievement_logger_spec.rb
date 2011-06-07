require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe AchievementLogger do

  let (:al) { AchievementLogger }

  it "have a default log location of the Rails log directory and a name of achievement.log" do
    al.logfile.path.should == "#{Rails.root}/log/achievement.log"
  end

  it "log file can be changed directly" do
    x = al.logfile = "/tmp/overthere"
    al.logfile.path.should == "/tmp/overthere"
  end

  it "logger_file is set to achievement log" do
    al.reset
    al.logfile.path.should == "#{Rails.root}/log/achievement.log"
    al.al_logger.is_a?(AchievementLogger).should be_true
  end

end
