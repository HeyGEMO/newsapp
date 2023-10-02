//NewsData class
class NewsData {
  String? title;
  String? author;
  String? content;
  String? urlToImage;
  String? date;
  String? url;

  //constructor
  NewsData({
    this.title="news title",
    this.author="news author",
    this.content="news description",
    this.date="news date",
    this.urlToImage="image url",
    this.url="news url"
});

 factory NewsData.fromMap(Map news)
  {
    return NewsData(
        title: news["title"],
        author: news["author"],
        content: news["description"],
        date: news["date"],
        urlToImage: news["urlToImage"],
        url: news["url"]
    );
  } 
}
