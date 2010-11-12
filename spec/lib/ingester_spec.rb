require 'spec_helper'

describe Ingester do
  include IngesterExampleHelperMethods
  
  it "handles simple transcript" do
    script = read_fixture("simple.txt")

    dialogs = Ingester.ingest(script)
    dialogs.size.should == 1
    dialog = dialogs.first
    dialog.speaker.should == "John Foo"
    dialog.time.should == "04:42"
    dialog.content.should == "Hello World"
  end

  it "escapes slash r correctly (converts dos files to unix)" do
    script = read_fixture("carriage_returns.txt")
    lambda{
      dialogs = Ingester.ingest(script)
    }.should_not raise_error
  end

  it "replaces left and right double quotes with simple quotes" do
    script = read_fixture("smart_quotes.txt")
    
    lambda {
      Ingester.ingest(script)
    }.should_not raise_error

  end

  it "handles full transcript" do
    script = read_fixture("full_transcript.txt")

    dialogs = Ingester.ingest(script)
    dialogs.size.should == 2
    chris_dialog = dialogs.first
    chris_dialog.speaker.should == "Chris Hayes"
    chris_dialog.time.should == "03:15"
    chris_dialog.content.should == "blah blah blah - lots of blah blah blah"

    debbie_dialog = dialogs.last
    debbie_dialog.speaker.should == "Debbie Stabenow"
    debbie_dialog.time.should be_nil
    debbie_dialog.content.should == "even more blah blah blah - tons of blah 
more blah"
    
  end
  
  it "embeds code in transcript" do
    script = read_fixture("embedded_video.txt")
    
    dialogs = Ingester.ingest(script)
    video_dialog = dialogs.first
    embedded_video = <<-EOF
<object type="application/x-shockwave-flash" align="middle" classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" width="320" height="205" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=10,0,0,0" pluginspage="http://www.adobe.com/go/getflashplayer" id="WetokuPlayer" name="WetokuPlayer"><param name="movie" value="http://wetoku.com/player/vod/10246" /><param name="allowScriptAccess" value="always" /><param name="menu" value="false"/><param name="allowFullScreen" value="true" /><param name="wmode" value="transparent" /><param name="flashvars" value="vid=danmoulthrop.2Fg/8a4db83c01981a704993b691010feb3cce74ee4a" /><embed src="http://wetoku.com/player/vod/10246" width="320" height="205" flashvars="vid=danmoulthrop.2Fg/8a4db83c01981a704993b691010feb3cce74ee4a" allowScriptAccess="always" type="application/x-shockwave-flash" allowFullScreen="true" wmode="transparent" menu="false"></embed></object>
EOF
    embedded_video.strip!
    video_dialog.should include embedded_video
  end
end

describe Ingester, "generic error handling" do
  include IngesterExampleHelperMethods

  it "errors on undefined DSL method" do
    expects_exception(:script => "exit()",
                      :line_number => 1,
                      :message => "undefined method `exit'")
  end
  
  it "errors when last dialog is missing content" do
    expects_exception(:script => "time '04:22'",
                      :message => "illegal state. Expected a dialog.")
  end

  it "errors when last dialog is missing content" do
    expects_exception(:script => "speaker 'John Foo'",
                      :message => "illegal state. Expected a dialog.")
  end

  it "errors when more than 1 speaker in a row" do
    script = %Q{speaker "John Foo"
      speaker "Bill Foo"
    }
    expects_exception(:script => script,
                      :line_number => 3,
                      :message => "illegal state. Expected a dialog or time.")
  end

  it "errors when dialog is before speaker" do
    script = 'dialog "hello"'
    expects_exception(:script => script,
                      :line_number => 1,
                      :message => "illegal state. Expected a speaker before dialog.")
  end

  it "errors when more than 1 dialog in a row" do
    script = %Q{ speaker "John Foo"
                 dialog "hello"
                 dialog "hello"
    }
    expects_exception(:script => script,
                      :line_number => 4,
                      :message => "illegal state. Expected a speaker before dialog.")
  end

  it "errors when more than 1 time" do
    script = %Q{ time "04:02"
                 speaker "John Foo"
                 time "04:05"
    }
    expects_exception(:script => script,
                      :line_number => 4,
                      :message => "illegal state. Time has already been set.")
                      
  end
end

shared_examples_for "expects value" do
  include IngesterExampleHelperMethods
  it "errors when called without arg" do
    expects_exception(:script => @missing_arg_script,
                      :line_number => @line_number,
                      :message => "illegal state. You must provide a #{@method}.")
  end

  it "errors when called with blank value" do
    expects_exception(:script => @blank_script,
                      :line_number => @line_number,
                      :message => "illegal state. You must provide a #{@method}.")
  end

  it "errors when called with nil value" do
    expects_exception(:script => @nil_script,
                      :line_number => @line_number,
                      :message => "illegal state. You must provide a #{@method}.")
  end
end

describe Ingester, "speaker method" do
  before(:each) do
    @missing_arg_script = "speaker"
    @blank_script = "speaker ''"
    @nil_script = "speaker nil"
    @line_number = 1
    @method = "speaker"
  end

  it_should_behave_like "expects value"

  it "should strip speaker" do
    dialogs = Ingester.ingest(%Q{speaker '  john foo \n'
     dialog "hello"
    })
    dialogs.first.speaker.should == "john foo"
  end
end

describe Ingester, "time method" do
  before(:each) do
    @missing_arg_script = "time"
    @blank_script = "time ''"
    @nil_script = "time nil"
    @line_number = 1
    @method = "time"
  end

  it_should_behave_like "expects value"
end

describe Ingester, "dialog method" do
  before(:each) do
    @missing_arg_script = %Q{speaker "John Foo"
                             dialog }
    
    @blank_script = %Q{speaker "John Foo"
                             dialog ' '  }
    @nil_script = %Q{speaker "John Foo"
                             dialog nil }
    @line_number = 2
    @method = "dialog"
  end

  it_should_behave_like "expects value"

  it "should strip trailing white space" do
    dialogs = Ingester.ingest(%Q{speaker "John Foo"
                                 dialog "Hello \n\n "})
    dialogs.first.content.should == "Hello"
  end
end
