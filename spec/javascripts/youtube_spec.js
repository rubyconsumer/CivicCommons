describe("YouTube", function() {

  it("can parse a standard youtube urls", function() {
     expect(youtube.getYoutubeId("http://www.youtube.com/watch?v=blah")).toEqual("blah");
     expect(youtube.getYoutubeId("http://www.youtube.com/watch?v=qzUuAIPPrGQ&feature=topvideos")).toEqual("qzUuAIPPrGQ");
  });

  it("parses youtube short urls", function() {
    expect(youtube.getYoutubeId("http://youtu.be/blah")).toEqual("blah");
    expect(youtube.getYoutubeId("http://youtu.be/oh?hd=1")).toEqual("oh");
  });
});
