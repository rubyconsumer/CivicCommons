# Contributor:
#   * Irrevocable badge
#   * awarded for making one contribution to a conversation,
#   * +1 reputation
#
# Bricklayer:
#   * Irrevocable badge
#   * awarded for making 10 total contributions to any conversations,
#   * +5 reputation (in addition to the +1 for Contributor)
#
# Mason:
#   * Irrevocable badge
#   * awarded for making 50 total contributions to any conversations,
#   * +10 reputation (in addition to the +6 for Contributor and Bricklayer)
class ContributorAchievement < Achievements::Base
  cattr_accessor :stat_threshold

  class << self
    def stat_threshold
      @@stat_threshold ||= begin
        threshold = {}

        #@@contributor = AchievementMetadata.where(:title => 'Contributor').first
        @@contributor = AchievementMetadata.find(1)
        #@@bricklayer = AchievementMetadata.where(:title => 'Bricklayer').first
        @@bricklayer = AchievementMetadata.find(2)
        @@mason = AchievementMetadata.find(3)

        threshold.merge!(@@contributor.id => @@contributor)
        threshold.merge!(@@bricklayer.id => @@bricklayer)
        threshold.merge!(@@mason.id => @@mason)
        threshold
      end
    end

    # Use when AchievementsMeta information has been updated and the update should be made live.
    def refresh_threshold!
      @@stat_threshold = nil
      self.stat_threshold
    end

    def observers?
      :Contribution
    end

    def do_maintenance
      # list all users - users with the Persuasive Badge
      #   * Interate through the list
      #     * user.earn_badge?
      #       * Assign these users the Persuasive Badge
      #         * Details: Check thresholds...
      contribution_counts = Contribution.where("conversation_id > 0").group(:owner).size
      if contribution_counts.size > 0
        if valid_threshold?
          format_awards_results(contribution_counts)
        end
      else
        nil
      end
    end

    def get_metadata_ids
      [@@contributor.id, @@bricklayer.id, @@mason.id]
    end

    def get_thresholds
      [stat_threshold[@@contributor.id].threshold, stat_threshold[@@bricklayer.id].threshold, stat_threshold[@@mason.id].threshold]
    end

    def blank_threshold?
      get_thresholds.each{|threshold| return true if threshold.blank? }
      false
    end

    def numeric_threshold?
      get_thresholds.each{|threshold| return false if !threshold.is_a?(Numeric)}
      true
    end

    def valid_threshold?
      blank_threshold? || !numeric_threshold? ? false : true
    end

    def format_awards_results(contribution_counts)
      results = {}

      contributor_threshold, bricklayer_threshold, mason_threshold = get_thresholds

      # owner_count_array is an array with the values of [owner, count_of_contributions_for_this_particular_owner]
      results[@@contributor.id] = contribution_counts.find_all{|owner_count_array| owner_count_array[1] >= contributor_threshold && owner_count_array[1] < bricklayer_threshold}.collect{|owner_count_array| owner_count_array[0]}
      results[@@bricklayer.id] = contribution_counts.find_all{|owner_count_array| owner_count_array[1] > bricklayer_threshold && owner_count_array[1] < mason_threshold}.collect{|owner_count_array| owner_count_array[0]}
      results[@@mason.id] = contribution_counts.find_all{|owner_count_array| owner_count_array[1] > mason_threshold}.collect{|owner_count_array| owner_count_array[0]}

      results
    end

    # Check threshold values and award badges as approriate.
    # This allows us to check multiple badges in one DB look up.
    # With this one we can just check the owner of the contribution and get a query on them.  Then check against the threshold.
    def awards?(model_id)
      contribution_counts = Contribution.where("conversation_id > 0").group(:owner).size
      if contribution_counts.size > 0
        if valid_threshold?
          format_awards_results(contribution_counts)
        end
      else
        nil
      end
    end

  end
end

