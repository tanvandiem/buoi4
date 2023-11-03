import 'package:myapp/myapp.dart';
import 'package:test/test.dart';

void main(List<String> args) async {
  // Lấy danh sách bài viết
  List<Post> posts = await fetchPosts();
  
  // In ra ID của các bài viết
  for (Post post in posts) {
    print('Post ID: ${post.id}');
  }
  
  // Yêu cầu người dùng nhập ID bài viết
  print('Nhập ID bài viết:');
  int postId = int.parse(await readInput());
  
  // Lấy thông tin user của bài viết
  User user = await fetchUser(postId);
  print('Thông tin user của bài viết có ID là $postId:');
  print('User ID: ${user.id}');
  print('Username: ${user.username}');
  print('Email: ${user.email}');
  
  // Lấy danh sách comment của bài viết
  List<Comment> comments = await fetchComments(postId);
  print('Danh sách comment của bài viết có ID là $postId:');
  for (Comment comment in comments) {
    print('Comment ID: ${comment.id}');
    print('Name: ${comment.name}');
    print('Email: ${comment.email}');
    print('Body: ${comment.body}');
    print('---');
  }
}
