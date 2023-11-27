import 'package:book1/src/common/model/book_review_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookReviewInfoRepository {
  FirebaseFirestore db;
  BookReviewInfoRepository(this.db);

  Future<void> createBookReviewInfo(BookReivewInfo bookReviewInfo) async {
    await db.collection('book_review_info').add(bookReviewInfo.toJson());
  }

  Future<BookReivewInfo?> loadBookReviewInfo(String bookId) async {
    var doc = await db
        .collection('book_review_info')
        .where('bookId', isEqualTo: bookId)
        .get();
    if (doc.docs.isEmpty) {
      return null;
    } else {
      return BookReivewInfo.fromJson(doc.docs.first.data());
    }
  }

  Future<void> updateBookReviewInfo(BookReivewInfo bookReviewInfo) async {
    var data = await db
        .collection('book_review_info')
        .where('bookId', isEqualTo: bookReviewInfo.bookId)
        .get();
    await db
        .collection('book_review_info')
        .doc(data.docs.first.id)
        .update(bookReviewInfo.toJson());
  }

  Future<List<BookReivewInfo>?> loadBookReviewRecentlyData() async {
    var doc = await db
        .collection('book_review_info')
        .orderBy('updateAt', descending: true)
        .limit(10)
        .get();
    if (doc.docs.isEmpty) {
      return null;
    }
    return doc.docs
        .map<BookReivewInfo>((data) => BookReivewInfo.fromJson(data.data()))
        .toList();
  }


}

