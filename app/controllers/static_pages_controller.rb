class StaticPagesController < ApplicationController
  def about
  end

  def blog
    people = Person.where('email like "%@theciviccommons.com" or email like "%@futurefundneo.org"')
    @people = Hash[people.map { |p| [p.first_name.downcase.to_sym, p] }] 
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
