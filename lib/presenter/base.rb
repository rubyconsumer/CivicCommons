module Presenter


  class Base < Delegator
    attr_reader :request

    def initialize(object, request=nil)
      @object = object
      @request = request
    end


    def __getobj__; @object end

    def __setobj__(object); @object = object end

  end


  class Form < Base
    extend ActiveModel::Naming


    def to_model; self end


  end


end
