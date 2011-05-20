module RedirectHelper

  def self.valid?(redirect_link)
    !redirect_link.nil? && !self.matches_devise_routes?(redirect_link)
  end

  private

  def self.matches_devise_routes?(redirect_link)
    # only set the previous page url if it is not a devise route
    match = false
    Devise.mappings.each_key do |mapping|
      scoped_path = Devise.mappings[mapping].scoped_path
      Devise.mappings[mapping].path_names.each_pair do |path_key, path_name|
        path = scoped_path + '/' + path_name
        if redirect_link.match("#{path}")
          match = true
        end
      end
    end
    match
  end
end