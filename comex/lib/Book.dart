class Book{
  final String id,name,author,image,listedBy,description;final int price,pages;
  Book({this.id,this.name,this.author,this.price,this.listedBy,this.image,this.description,this.pages});
}

class BookAPIQuery{
  final String title,description,infoLink,image,authors; final int pages;final dynamic rating;
  BookAPIQuery({this.title,this.description,this.image,this.infoLink,this.pages,this.rating,this.authors});

  factory BookAPIQuery.fromJson(Map<String, dynamic> map){
    final jsonList = (map['items'] as List);
    var books =  jsonList.map((jsonBook) => BookAPIQuery(
            title: jsonBook['volumeInfo']['title'],
            authors: (jsonBook['volumeInfo']['authors'] as List).join(', ').replaceAll('Authors', ''),
            image: jsonBook['volumeInfo']['imageLinks']['smallThumbnail'],
            infoLink: jsonBook['volumeInfo']['infoLink'],
            description: jsonBook['volumeInfo']['description'],
            pages: jsonBook['volumeInfo']['pageCount'],
            rating: jsonBook['volumeInfo']['averageRating'],
          ))
      .toList();
      return books[0];
  }

  void show(){
    print("Title: "+this.title);
    print("Authors: " + this.authors);
    print("Pages: "+this.pages.toString());
    print("Rating: "+this.rating.toString());
  }
}
