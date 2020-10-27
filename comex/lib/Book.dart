class Book{
  final String id,name,author,image,listedBy,description;final int price,pages;
  Book({this.id,this.name,this.author,this.price,this.listedBy,this.image,this.description,this.pages});
}

class BookAPIQuery{
  final String title,description,infoLink,image; final int pages;final double rating;final List authors;
  BookAPIQuery({this.title,this.description,this.image,this.infoLink,this.pages,this.rating,this.authors});

  factory BookAPIQuery.fromJson(Map<String, dynamic> json){
    return BookAPIQuery(
      title: json["title"]==null?"Title":json['title'],
      authors : json["authors"]==null?["No author details available"]:List<String>.from(json["authors"].map((x) => x)),
      description: json["description"]==null?"Description":json["description"],
      image: json["imageLinks"] == null ? null : (json["imageLinks"])["thumbnail"],
      infoLink: json["infoLink"]==null ? "link" : json["infoLink"],
      pages: json["pageCount"] == null ? -1 : json["pageCount"],
      rating: json["averageRating"] == null ? null : json["averageRating"].toDouble()
    );
  }
}
