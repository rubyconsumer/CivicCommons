class Ingester
  class Error < RuntimeError
    def initialize(message, wrapped_exception)
      @wrapped_exception = wrapped_exception
      super(message)
    end
  end

  def self.ingest(string)
    begin
      DSL.build(string)
    rescue => e
      friendly_exception_info = parse_exception(e)
      raise Error.new(friendly_exception_info, e)
    end
  end

  def self.parse_exception(exception)
    message = exception.message
    
    if exception.backtrace.detect{|l| l =~/IngesterTranscript:(\d+)/}
      line_info = "Error ingesting transcript around line #{$1}"
    else
      line_info = "Error ingesting transcript"
    end

    # example exception format:
    # NameError: undefined local variable or method `foo' for #<Ingester::DSL:0x000001032c6060>
    # Remove info regarding instance of DSL class
    line_info + "; " + message.gsub(/ for #<.*?>/, "")
  end

  class Dialog < Struct.new(:speaker, :time, :content)
    def partial_dialog?
      (speaker || time) && !content
    end
  end

  class DSL < BasicObject
    def self.build(string)
      builder = new
      builder.instance_eval(string, "IngesterTranscript", 1)
      if builder.current_dialog.partial_dialog?
        builder.raise_illegal_state "Expected a dialog."
      end
      builder.dialogs
    end
    
    attr_reader :current_dialog
    attr_reader :dialogs
    
    def initialize
      @dialogs = []
      @current_dialog = Dialog.new
    end

    def speaker(name=nil)
      if name.nil? || name.blank?
        raise_illegal_state "You must provide a speaker." 
      elsif @current_dialog.content || @current_dialog.speaker
        raise_illegal_state "Expected a dialog or time."
      end
      @current_dialog.speaker = name.strip
    end
    
    def time(_time=nil)
      if _time.nil? || _time.blank?
        raise_illegal_state "You must provide a time."
      elsif @current_dialog.time
        raise_illegal_state "Time has already been set."
      end
      @current_dialog.time = _time
    end
    
    def dialog(content=nil)
      if content.nil? || content.blank?
        raise_illegal_state "You must provide a dialog."
      elsif @current_dialog.speaker.nil? || @current_dialog.content
        raise_illegal_state "Expected a speaker before dialog."
      end
      @current_dialog.content = content.strip
      @dialogs << @current_dialog
      @current_dialog = Dialog.new
    end

    def raise_illegal_state(message)
      raise "illegal state. #{message}"
    end
    def raise(*args)
      ::Object.send(:raise, *args)
    end
  end
  
end
