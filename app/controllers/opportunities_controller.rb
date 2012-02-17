class OpportunitiesController < ApplicationController
  layout 'category_index'

  def index
    render text: <<EOT, layout: nil
    Text
EOT
  end

end

