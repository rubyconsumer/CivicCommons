# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)


# Create an admin person 
# Credentials - test@example.com:password

admin_person = Person.create! do |p|
  p.name = "Test Admin"
  p.password = "password"
  p.email = "admin@example.com"
  p.admin = true
end
admin_person.confirm!

# Create people used in test transcripts
[ "Neal Conan",
  "Andrew Welsh-Huggins",
  "Chris Hayes",
  "Debbie Stabenow",
  "Annie Lowery",
  "John Boehner",
  "Chris Van Hollen",
  "Xavier Becerra",
  "Barack Obama",
  "Brian Bilbray",
  "Ann Friedman",
  "Alex Wagner",
  "Roger Hickey",
  "Gary Rivlin",
  "John Kasich",
  "Bill O'Reilly",
  "John King",
  "Al Quincel",
  "Ted Strickland",
  "Alex Kuskin",
  "Amy Lozier",
  "Gloria Borger",
  "Unknown Male",
  "Unknown Female",
  "Dana Bash",
  "Joe Johns",
  "Richard Daley",
  "Jessica Yellin",
  "Rahm Emanuel",
  "Goria Borger",
  "Unknown Announcer",
  "Mary Jo Kilroy",
  "Steve Stivers",
  "John Boccieri",
  "Jim Renacci",
  "Tim Kaine",
  "Jeff Stahler",
  "Rick Sanchez",
  "Pete Dominick"
].each do |name|
  email = name.downcase.gsub(/[^a-z0-9]/, ".") + "@example.com"

  Person.create!(:name => name,
                 :email => email,
                 :password => "password")
end


# Create test issues
["Opportunity Corridor",
 "Port Authority",
 "Shrinkage",
 "LeBron James",
 "Youngstown's revival",
 "Bike path on the inner belt bridge",
 "Ohio Unemployment",
 "Ohio Gubernatorial Election",
 "Ohio Lethal Injection",
 "Ohio Politics",
 "Immigration Reform",
 "Water"].each do |issue|
  Issue.create!(:name => issue, :summary => "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin at velit lacus, vel lobortis quam. Duis eget odio lacus. Quisque ac.")
end
ohio_politics_issue = Issue.find_by_name("Ohio Politics")


def ingest(conversation, ingest_text_file_name)
  base_path = ENV['TRANSCRIPTS_PATH'] || File.expand_path("~/Dropbox/Civic Commons/db")
  full_path = File.join(base_path, ingest_text_file_name)
  IngestPresenter.new(conversation, File.open(full_path)).save!
end

conversation = Conversation.create!(:moderator => admin_person,
                                    :title => "Conversation regarding Ohio Unemployment",
                                    :summary => "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin at velit lacus, vel lobortis quam. Duis eget odio lacus. Quisque ac.",
                                    :started_at => 2.hours.ago,
                                    :finished_at => Time.now,
                                    :zip_code => "44301")
conversation.issues << Issue.find_by_name("Ohio Unemployment")
conversation.issues << ohio_politics_issue

ingest(conversation, "john_king.txt")

lethal_convo = Conversation.create!(:moderator => admin_person,
                                    :title => "Conversation regarding Lethal Injection",
                                    :summary => "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin at velit lacus, vel lobortis quam. Duis eget odio lacus. Quisque ac.",
                                    :started_at => 3.days.ago,
                                    :finished_at => 3.days.ago + 1.hours,
                                    :zip_code => 44301)
lethal_convo.issues << Issue.find_by_name("Ohio Lethal Injection")
lethal_convo.issues << ohio_politics_issue
ingest(lethal_convo, "lethal_injection.txt")


oreilly_convo = Conversation.create!(:moderator => admin_person,
                                     :title => "Oreilly Factor - Ohio Gubernatorial Race",
                                     :summary => "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin at velit lacus, vel lobortis quam. Duis eget odio lacus. Quisque ac.",
                                     :started_at => 3.days.ago,
                                     :finished_at => 3.days.ago + 1.hours,
                                     :zip_code => 44301)
oreilly_convo.issues << Issue.find_by_name("Ohio Unemployment")
oreilly_convo.issues << Issue.find_by_name("Ohio Gubernatorial Election")
oreilly_convo.issues << ohio_politics_issue

ingest(oreilly_convo, "oreilly_factor.txt")

ed_show_convo = Conversation.create!(:moderator => admin_person,
                                     :title => "Ed Show - Immigration Reform",
                                     :summary => "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin at velit lacus, vel lobortis quam. Duis eget odio lacus. Quisque ac.",
                                     :started_at => 3.days.ago,
                                     :finished_at => 3.days.ago + 1.hours,
                                     :zip_code => 44301)
ed_show_convo.issues << Issue.find_by_name("Immigration Reform")
ed_show_convo.issues << ohio_politics_issue

ingest(ed_show_convo, "transcript.txt")



Person.limit(15).each do |p|
  p.update_attribute(:organization, true)
end


lorems = ["Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean euismod iaculis bibendum. Integer in diam sem, non pulvinar sapien. Nunc luctus, magna sed tempus sodales, metus erat sollicitudin velit, vel congue tortor nunc quis erat. Cras venenatis commodo felis a fringilla. Morbi porttitor tellus magna, sollicitudin auctor lorem. Cras lacus erat, rutrum eget adipiscing vel, adipiscing ac urna. Nam feugiat consectetur erat in aliquet. Vivamus eu metus nulla. Vivamus vestibulum sapien ullamcorper ligula pretium id convallis elit tristique. Aenean nec quam eu mi fringilla pulvinar a nec purus. In ullamcorper felis et elit tempus hendrerit. Morbi bibendum, ante vitae ornare tincidunt, leo metus mattis diam, a fringilla urna sem a nunc. Aenean quis erat eget neque porttitor vehicula vitae vel erat.",
"Vestibulum nec mi viverra urna tempus congue at ut orci. Praesent suscipit massa sit amet elit blandit elementum. Maecenas adipiscing faucibus augue ac commodo. Cras condimentum ultrices euismod. Pellentesque et metus ac lectus venenatis aliquet a non erat. Proin sit amet turpis enim, ac vehicula tortor. Integer non urna sapien, sed gravida ligula. Curabitur pulvinar egestas porta. Maecenas ut velit et arcu tincidunt pharetra volutpat ut augue. Cras ligula turpis, placerat sit amet malesuada sed, accumsan faucibus nibh. Aenean at sagittis nunc. Mauris ac leo quis dui vulputate gravida sed eu massa. Aenean semper metus sed velit aliquam pellentesque. Aenean luctus consectetur tincidunt. Nullam eget elementum orci. Proin molestie pulvinar purus ut bibendum. Curabitur porta fringilla ipsum, vitae porttitor nibh placerat sit amet.",
"Phasellus accumsan hendrerit mattis. Sed ipsum diam, euismod non posuere id, cursus consequat turpis. Aenean sed lacus sed urna molestie volutpat sit amet at lorem. Duis adipiscing euismod venenatis. Aenean pellentesque odio a massa congue et tincidunt mi aliquet. Nulla tortor orci, sagittis ac condimentum et, feugiat id justo. Nam id massa ipsum, et fermentum est. Aenean ligula dolor, ultricies vitae porttitor a, porta eget nibh. Morbi a quam leo. In scelerisque semper leo, eget ultrices lorem condimentum at.",
"Quisque dictum quam sed eros consectetur dignissim. Donec eget quam et enim malesuada pretium et cursus augue. Nulla non leo est, eget tristique augue. Nam pulvinar, nibh id congue venenatis, sapien mi pharetra purus, at vulputate orci nibh non odio. Nam rhoncus mauris nec dui viverra sodales. Nulla rutrum, lorem auctor pharetra hendrerit, ipsum ante sagittis erat, eu facilisis nibh mauris vel turpis. Vivamus vel orci in nisl auctor volutpat. Praesent at purus sed nunc tempor egestas non eget neque. Proin pulvinar gravida fermentum. Morbi sit amet quam justo, faucibus laoreet mi. Nulla facilisi. Cras sodales tempor augue, nec interdum diam venenatis non. Cras sit amet mi est, sed feugiat ante.",
"Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Suspendisse ac urna vitae nisl dapibus malesuada. Vivamus sed augue nec nunc placerat mattis. Morbi ligula arcu, blandit quis lobortis nec, suscipit in justo. Praesent auctor consequat diam, eget commodo turpis lobortis at. Cras tincidunt, sem at pulvinar condimentum, mauris leo hendrerit enim, commodo commodo purus ligula vitae nunc. Nunc sagittis lacus vel turpis laoreet non varius orci vehicula. Sed vel enim eget ligula semper ullamcorper nec in nisl. Sed ornare, libero vitae auctor dictum, libero magna posuere enim, ut lobortis orci tellus vel nunc. Proin nisl elit, lobortis quis varius pharetra, condimentum nec est. Aenean enim quam, interdum at malesuada sed, elementum eget neque.",
"Nulla dapibus nulla eget ante dictum in pulvinar lorem volutpat. Mauris dui purus, posuere in tristique vitae, posuere sed eros. Ut sit amet lectus odio, et euismod nulla. Sed cursus tortor ac sapien aliquet cursus. Phasellus eget magna justo. Maecenas sollicitudin, massa volutpat venenatis feugiat, felis velit fringilla sem, eget molestie nulla nisl et odio. Sed vitae ipsum sit amet lacus venenatis placerat. Aenean blandit, quam sed facilisis venenatis, orci tortor tempor dolor, et iaculis metus odio id erat. Phasellus quis condimentum risus. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Ut eget dui arcu, ac suscipit neque. Aliquam cursus aliquet auctor. Ut vel lorem vitae massa laoreet malesuada placerat quis nulla. Vivamus feugiat vehicula quam a lobortis. In gravida dictum porta. Etiam tristique placerat nunc nec tempus. Phasellus pharetra metus dignissim sapien tristique non bibendum libero sollicitudin. Suspendisse potenti. Sed non orci vitae quam semper sollicitudin nec ut massa. Vivamus facilisis diam eu nisl facilisis ullamcorper sed vel nibh.",
"Duis feugiat euismod est at eleifend. Nullam non lacinia turpis. Suspendisse potenti. In tempus, eros ac venenatis condimentum, justo quam eleifend nulla, vel tempus erat ipsum quis dui. Duis et augue ac neque fermentum elementum non ut turpis. Fusce tempus lacus gravida nulla vestibulum a fermentum ligula vulputate. Aenean nunc sem, pharetra consequat eleifend et, lobortis quis nisi. Quisque accumsan sapien sed arcu bibendum vitae viverra tellus vehicula. Vivamus dolor leo, luctus sit amet adipiscing sed, pellentesque fringilla diam. Sed tortor turpis, tincidunt ut blandit vitae, dignissim in quam. Aenean eget dui nisl. Aenean quis nisl augue, molestie condimentum libero. Cras ut massa magna, nec placerat mi. Morbi porttitor sapien massa, eget elementum lorem.",
"Vivamus aliquam dolor in quam semper eleifend. Nam sit amet leo diam, vitae sollicitudin sapien. Duis pulvinar ornare viverra. Pellentesque facilisis imperdiet posuere. Morbi quis elementum purus. Sed facilisis eros eu justo lobortis fermentum ultrices lectus blandit. Phasellus molestie tincidunt turpis a accumsan. Cras sit amet leo vitae dui interdum pharetra sed nec massa. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nunc et magna sem, sed condimentum dui. Praesent laoreet mollis ultricies. Mauris vel enim tortor, in convallis ante. Etiam quis mauris quam, ut consequat nulla. Curabitur tristique dolor tristique libero volutpat porta.",
"Maecenas vitae felis mauris, id scelerisque massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Duis at nisl magna, at laoreet mauris. Mauris vel sapien id purus condimentum placerat at ut dolor. Vestibulum eleifend molestie nisi volutpat commodo. Vestibulum a ante mattis nunc eleifend vestibulum a non enim. Vestibulum risus mauris, malesuada eget consequat suscipit, consectetur eget quam. Morbi volutpat scelerisque justo, vitae egestas est euismod at. Nulla lacinia elit vel erat tempus sed pellentesque enim egestas. Nullam ipsum mi, egestas ac semper id, interdum vel nulla. Pellentesque et erat in risus iaculis hendrerit sit amet sed ante. Integer interdum aliquam consequat. Donec enim massa, fermentum nec varius nec, euismod vel mi.",
"Nunc vitae metus nunc, non aliquet ante. Nulla facilisi. Cras blandit, magna ut faucibus faucibus, tellus lacus mattis ipsum, id scelerisque sem nibh in nisi. Quisque mattis metus sit amet eros sagittis sollicitudin. Curabitur quis luctus eros. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec non fermentum risus. Aliquam vitae urna lacus, sit amet congue felis. Etiam ut tortor suscipit sapien facilisis lacinia. Donec ac pulvinar elit. Proin nec porttitor enim. Nam bibendum dui dolor, blandit congue justo.",
"Nam mattis tortor diam. Integer suscipit porta aliquam. Etiam vehicula diam a dui adipiscing vitae luctus velit sollicitudin. Aenean est massa, aliquet vel tempor in, cursus vel diam. Duis augue libero, feugiat id condimentum quis, cursus elementum odio. Cras tincidunt facilisis dui, ut malesuada libero volutpat congue. Maecenas sapien elit, luctus at egestas ut, commodo non elit. Aliquam aliquam risus sed quam tempor pulvinar. Nunc leo neque, volutpat vitae molestie a, posuere sit amet erat. Donec a sem a ante ornare consequat. Donec diam quam, aliquam iaculis aliquam ac, scelerisque non velit. Morbi nulla dui, condimentum id consectetur eu, rutrum non velit. Nam ut tempus orci. Sed massa lorem, placerat at aliquam ac, laoreet vel neque. Vivamus dictum, lacus at vehicula rutrum, ante felis gravida massa, vel porta sem metus in diam. Aliquam erat volutpat. Phasellus feugiat, ante quis convallis posuere, quam enim sodales metus, eu facilisis eros enim et erat.",
"Duis rhoncus velit non diam tempor lacinia. Morbi ultricies, sem et ornare faucibus, velit nisi tempor eros, eu vestibulum tortor purus sit amet ligula. Morbi eleifend fermentum fermentum. Aenean fringilla sem a tellus bibendum vulputate. Aliquam urna purus, lacinia eget vestibulum vel, adipiscing a metus. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Aenean odio arcu, egestas quis vehicula non, varius ut neque. Sed eu sem enim, vel laoreet libero. Praesent feugiat pulvinar risus, sed consectetur mi facilisis quis. Vivamus ultrices laoreet rutrum.",
"Cras rhoncus neque at elit varius sed ultrices metus faucibus. Proin consectetur sapien in est commodo facilisis. Aenean dignissim viverra accumsan. Sed pretium, velit eu pulvinar scelerisque, metus purus ultrices velit, vitae vestibulum lectus sem ut elit. Cras porttitor gravida risus, non semper magna facilisis fringilla. Integer leo lectus, euismod sed sodales nec, tincidunt a dui. Fusce pulvinar urna quis augue lobortis nec faucibus lectus auctor. In hac habitasse platea dictumst. Donec varius tellus vel elit commodo vulputate. Donec elementum bibendum sapien, vel cursus erat tincidunt et. Proin sed fermentum arcu. Cras suscipit tempus nunc eget rutrum. Donec feugiat leo scelerisque enim eleifend vitae ultricies dui commodo. Duis placerat, nibh vel gravida dictum, diam est vulputate nisi, eget suscipit elit erat non enim. Vestibulum vitae fringilla erat. Nulla commodo mauris commodo urna ornare fringilla. In hac habitasse platea dictumst. Suspendisse potenti. Maecenas tristique diam vitae tellus varius luctus. Praesent pharetra ante at neque sodales porta vel a ante.",
"In enim est, imperdiet et dapibus sed, vehicula sed odio. Suspendisse luctus erat sed quam gravida tempus. In dignissim posuere ante eget pretium. Praesent ut magna at risus vehicula fringilla. Sed varius lacus eu neque ullamcorper eget tristique neque sodales. Nulla auctor, nulla id faucibus condimentum, odio tellus dictum leo, ut tincidunt mauris orci eu arcu. Nunc ac felis augue. Pellentesque at mi sed tellus luctus cursus. Proin eget blandit ante. Integer bibendum tristique placerat. Mauris adipiscing purus quis libero congue iaculis. Fusce in mauris dui. Aenean tortor felis, dictum ut aliquet posuere, viverra ac sem. Praesent a magna euismod mauris euismod tempor id sit amet dui. Suspendisse lacinia vestibulum dui, in feugiat purus laoreet vitae. Nullam porta rhoncus sodales. Fusce pulvinar felis et augue commodo iaculis. Phasellus rutrum justo ut lacus euismod suscipit. Mauris mattis libero et massa rhoncus vel pulvinar mauris gravida.",
"Fusce ut sem quis mauris posuere bibendum. Integer volutpat pellentesque ipsum in commodo. Nulla facilisi. Suspendisse potenti. Sed posuere dictum velit, et aliquet augue aliquam quis. Phasellus ut dignissim leo. Etiam cursus feugiat cursus. Mauris scelerisque massa eget tellus aliquam tincidunt. Phasellus velit neque, pretium ut condimentum sit amet, sodales ac dui. Sed consectetur sodales lobortis. Etiam nunc lorem, fringilla ut adipiscing a, interdum nec quam.",
"Suspendisse potenti. Suspendisse lobortis, erat at rutrum consequat, augue turpis fringilla erat, a posuere felis erat eu turpis. Vestibulum gravida, justo at tristique venenatis, erat eros blandit nibh, ut vehicula leo nunc vel dui. In dictum aliquet euismod. Vestibulum eget fringilla tellus. In sed eros id leo facilisis dignissim id sit amet magna. Sed eu lacus sodales ligula volutpat semper a eu risus. Quisque et nunc sed dui congue tristique. Phasellus lobortis, sapien eu iaculis blandit, ligula justo posuere nulla, sed tempor erat risus sed lacus. Cras in dolor elit, vitae iaculis ante.",
"Pellentesque eu neque a nisi scelerisque ornare. Curabitur ornare, orci non facilisis malesuada, nisi quam pharetra lorem, sed tincidunt nunc enim sed quam. Donec nec nibh orci. Sed consequat leo a justo egestas et semper arcu interdum. Proin mauris nulla, semper vitae adipiscing quis, ornare sit amet eros. Duis eget odio massa, a sagittis justo. Donec congue mauris ac ante laoreet elementum. Ut nec tortor est. Pellentesque convallis ligula ac dolor cursus interdum. Vivamus accumsan magna a orci tincidunt viverra. Nullam dapibus sagittis ante, non vulputate mauris luctus ac. Ut tempus gravida elit, non bibendum sem varius in. Cras et risus ipsum. Cras suscipit dolor quis sapien accumsan et egestas augue vehicula. Fusce tempus adipiscing nisi at scelerisque.",
"Mauris gravida neque a dui vestibulum pharetra. Mauris eros urna, euismod eu vulputate in, lacinia a ipsum. Praesent ut ligula mauris. Integer vel porttitor urna. Maecenas vitae ligula nec purus ullamcorper vulputate. Vestibulum venenatis venenatis ipsum, et ultrices eros ultricies ut. Integer urna eros, interdum id volutpat vel, consequat in enim. Nunc rhoncus justo non erat tristique id interdum sem dapibus. Quisque varius aliquet pretium. Sed convallis varius hendrerit. Donec mattis ultrices risus, egestas feugiat dolor mollis in. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae;",
"Curabitur vehicula purus sed dolor commodo scelerisque. Donec ut rutrum mauris. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Proin adipiscing ornare fringilla. Pellentesque ullamcorper tellus et neque luctus facilisis. Suspendisse potenti. Sed in urna et nisi feugiat dictum eget non velit. Duis eleifend urna eget mi placerat mollis. Praesent condimentum purus sit amet justo tincidunt dignissim. Donec a tristique purus. Aenean odio lectus, luctus eu vulputate sit amet, tincidunt quis enim. Proin tincidunt feugiat diam, et elementum odio mollis a. Pellentesque volutpat commodo pulvinar. Sed posuere gravida faucibus. Nam lorem quam, iaculis ac pharetra et, tristique semper dui. Curabitur sit amet molestie elit.",
"Nunc feugiat neque in ipsum fringilla eget ultricies arcu tempor. Pellentesque et dignissim felis. Quisque pharetra, augue id ullamcorper interdum, velit orci porttitor orci, quis placerat risus dolor sed dui. Donec bibendum, nulla a iaculis ullamcorper, ante lacus porta nisi, ut pretium dolor diam eu neque. Praesent mollis ultrices tellus, eu convallis nisl rutrum quis. Donec sit amet dui urna, vel rutrum turpis. Ut ut urna id elit varius accumsan bibendum vitae neque. Sed vel mauris nec dui hendrerit dapibus. Maecenas mollis libero vitae lectus venenatis nec volutpat libero consequat. Pellentesque in justo nisl, ut pharetra odio. In luctus nibh nec arcu mollis eget venenatis dolor faucibus. Nullam accumsan adipiscing nunc id adipiscing. Fusce accumsan vehicula nibh, nec mollis nibh vehicula quis. Aliquam varius sollicitudin erat vitae cursus. Nullam eleifend tristique facilisis. Vestibulum magna risus, pharetra vitae tristique sed, euismod at velit."]


Issue.all.each_with_index do |issue, index|
  Person.all.sort_by{ rand }.first(index).each_with_index do |person, p_index|
  contributions = (p_index % 5) + 1
    contributions.times do
      TopLevelContribution.create!(:person => person,
                                   :issue => issue,
                                   :content => lorems[rand(lorems.size)])
    end
  end
end


