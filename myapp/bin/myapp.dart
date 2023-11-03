import 'package:myapp/myapp.dart' as myapp;
// BTVN:
// Viết chương trình thực hiện:
// - Lấy danh sách bài viết, sau đó in ra ID của các bài viết
// - Yêu cầu người dùng nhập một ID bài viết, lấy ra thông tin user của bài viết đó, và lấy danh sách comment của bài viết đó
// ---> sử dụng các API sau:
// - Posts: https://jsonplaceholder.typicode.com/posts
// - User:
// https://jsonplaceholder.typicode.com/users/{user_id}
// - Comments:
// https://jsonplaceholder.typicode.com/posts/{post_id}/comments
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';





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

class Post {
  final int id;
  final int userId;
  final String title;
  final String body;

  Post({required this.id, required this.userId, required this.title, required this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      body: json['body'],
    );
  }
}

class User {
  final int id;
  final String username;
  final String email;

  User({required this.id, required this.username, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
    );
  }
}

class Comment {
  final int id;
  final String name;
  final String email;
  final String body;

  Comment({required this.id, required this.name, required this.email, required this.body});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      body: json['body'],
    );
  }
}

Future<List<Post>> fetchPosts() async {
  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
  
  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    return data.map((post) => Post.fromJson(post)).toList();
  } else {
    throw Exception('Failed to fetch posts');
  }
}

Future<User> fetchUser(int postId) async {
  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/$postId'));
  
  if (response.statusCode == 200) {
    dynamic data = jsonDecode(response.body);
    int userId = data['userId'];
    final userResponse = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users/$userId'));
    
    if (userResponse.statusCode == 200) {
      dynamic userData = jsonDecode(userResponse.body);
      return User.fromJson(userData);
    } else {
      throw Exception('Failed to fetch user');
    }
  } else {
    throw Exception('Failed to fetch post');
  }
}

Future<List<Comment>> fetchComments(int postId) async {
  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/$postId/comments'));
  
  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    return data.map((comment) => Comment.fromJson(comment)).toList();
  } else {
    throw Exception('Failed to fetch comments');
  }
}

Future<String> readInput() async {
  return await Future<String>.value(stdin.readLineSync());
}

