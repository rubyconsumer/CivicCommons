class StaticPagesController < ApplicationController
  def about
  end

  def blog
    people = Person.find([9,11], order: 'id ASC')
    @people = {dan: people.first, noelle: people.last}
  end

  def faq
  end

  def principles
  end

  def team
  end

  def partners
  end

  def terms
  end

  def build_the_commons
  end

  def contact
  end

  def poster
    render layout: 'poster'
  end
end
