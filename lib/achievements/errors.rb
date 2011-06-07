module Achievements
  class AchievementsErrors < StandardError
  end
  class AchievementNotFoundError < StandardError
  end
  class MultipleAchievementsFoundError < StandardError
  end
end
