import 'dart:async'; // Add this import for StreamController
import 'dart:math';

import 'package:fitplanv_1/user_profile.dart';
import 'package:fitplanv_1/user_profile_details.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class SocialFeedPage extends StatefulWidget {
  @override
  _SocialFeedPageState createState() => _SocialFeedPageState();
}

enum PostFilter { newest, oldest }

class _SocialFeedPageState extends State<SocialFeedPage> {
  final TextEditingController _postController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  String? _currentUsername;
  PostFilter _postFilter = PostFilter.newest;
  bool _showAllComments = false;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('profiles').doc(user.uid).get();
      if (doc.exists && doc.data()!.containsKey('username')) {
        setState(() {
          _currentUsername = doc['username'];
        });
      } else {
        if (_currentUsername == null) {
          _showSetUsernameDialog();
        }
      }
    }
  }

  void _showSetUsernameDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Set Username'),
          content: Text('Please set a username before posting.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserProfilePage()),
                ).then((_) => _loadUsername());
              },
              child: Text('Set Username'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addPost() async {
    if (_postController.text.isEmpty || _currentUsername == null) return;

    final User? user = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance.collection('posts').add({
      'text': _postController.text,
      'timestamp': Timestamp.now(),
      'userId': user?.uid,
      'userName': _currentUsername,
      'likes': 0,
    });

    _postController.clear();
  }

  void _setFilter(PostFilter filter) {
    setState(() {
      _postFilter = filter;
    });
  }

  Future<void> _likePost(DocumentSnapshot post) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final likeRef = FirebaseFirestore.instance.collection('user_likes').doc(user.uid).collection('liked_posts').doc(post.id);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final freshSnap = await transaction.get(post.reference);
      transaction.update(freshSnap.reference, {'likes': freshSnap['likes'] + 1});
      transaction.set(likeRef, {'postId': post.id, 'likedAt': Timestamp.now()});
    });
  }

  Future<void> _unlikePost(DocumentSnapshot post) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final likeRef = FirebaseFirestore.instance.collection('user_likes').doc(user.uid).collection('liked_posts').doc(post.id);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final freshSnap = await transaction.get(post.reference);
      transaction.update(freshSnap.reference, {'likes': freshSnap['likes'] - 1});
      transaction.delete(likeRef);
    });
  }

  void _editPost(DocumentSnapshot post) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController controller = TextEditingController(text: post['text']);
        return AlertDialog(
          title: Text('Edit Post'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: 'Post Text'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final User? user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  await FirebaseFirestore.instance.collection('posts').doc(post.id).update({'text': controller.text});
                }
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deletePost(DocumentSnapshot post) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
      return AlertDialog(
          title: Text('Delete Post'),
          content: Text('Are you sure you want to delete this post?'),
          actions: <Widget>[
          TextButton(
          onPressed: () {
        Navigator.of(context).pop();

          },
            child: Text('Cancel'),
          ),
            TextButton(
              onPressed: () async {
                final User? user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  await FirebaseFirestore.instance.collection('posts').doc(post.id).delete();
                }
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
      );
        },
    );
  }

  Future<void> _addComment(String postId, String comment) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null || comment.isEmpty) return;

    await FirebaseFirestore.instance.collection('posts').doc(postId).collection('comments').add({
      'text': comment,
      'timestamp': Timestamp.now(),
      'userId': user.uid,
      'userName': _currentUsername,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          title: Text(
            'Social Feed',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0, // No shadow
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade500, Colors.blue.shade500], // Gradient colors
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.3, 0.9], // Gradient stops
              ),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.account_circle_outlined,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserProfilePage()),
                ).then((_) => _loadUsername());
              },
            ),
            PopupMenuButton<PostFilter>(
              icon: Icon(
                Icons.filter_alt_outlined,
                color: Colors.white,
                size: 28,
              ),
              onSelected: _setFilter,
              itemBuilder: (BuildContext context) => <PopupMenuEntry<PostFilter>>[
                PopupMenuItem<PostFilter>(
                  value: PostFilter.newest,
                  child: Text('Newest', style: TextStyle(color: Colors.black)),
                ),
                PopupMenuItem<PostFilter>(
                  value: PostFilter.oldest,
                  child: Text('Oldest', style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
          ],
        ),
      ),



      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getPostStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final posts = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    final isOwner = post['userId'] == FirebaseAuth.instance.currentUser?.uid;
                    return _buildPostCard(post, isOwner);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _postController,
                    decoration: InputDecoration(
                      labelText: 'Write a post...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _addPost,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Stream<QuerySnapshot> _getPostStream() {
    switch (_postFilter) {
      case PostFilter.newest:
        return FirebaseFirestore.instance.collection('posts').orderBy('timestamp', descending: true).snapshots();
      case PostFilter.oldest:
        return FirebaseFirestore.instance.collection('posts').orderBy('timestamp', descending: false).snapshots();
    }
    throw ArgumentError('Invalid post filter: $_postFilter');
  }

  Widget _buildPostCard(DocumentSnapshot post, bool isOwner) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.white.withOpacity(0.9),
      shadowColor: Colors.black.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.green,
                child: Icon(Icons.person),
              ),
              title: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfileDetailPage(
                        userId: post['userId'],
                        userName: post['userName'] ?? 'Unknown',
                      ),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Text(
                      post['userName'] ?? 'Unknown',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.blue,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
              subtitle: Text(
                DateFormat('MMM dd, yyyy hh:mm a').format(post['timestamp'].toDate()),
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              post['text'],
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),
            Divider(color: Colors.grey),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                StreamBuilder<DocumentSnapshot>(
                  stream: _getUserLikeStream(post.id),
                  builder: (context, snapshot) {
                    final isLiked = snapshot.hasData && snapshot.data!.exists;
                    return Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.thumb_up,
                            color: isLiked ? Colors.blue : null,
                          ),
                          onPressed: () {
                            if (isLiked) {
                              _unlikePost(post);
                            } else {
                              _likePost(post);
                            }
                          },
                          tooltip: isLiked ? 'Liked by ${_currentUsername ?? "Unknown"}' : 'Like',
                        ),
                        Text('${post['likes']}', style: TextStyle(fontSize: 16)),
                      ],
                    );
                  },
                ),
                if (isOwner) ...[
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _editPost(post),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deletePost(post),
                  ),
                ],
              ],
            ),
            SizedBox(height: 10),
            _buildCommentSection(post.id, post.reference),
          ],
        ),
      ),
    );
  }


  Widget _buildCommentSection(String postId, DocumentReference postRef) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text(
        'Comments',
        style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
    ),),
            SizedBox(height: 10),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('posts').doc(postId).collection('comments').orderBy('timestamp', descending: true).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              final comments = snapshot.data!.docs;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _showAllComments ? comments.length : min(3, comments.length),
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      return ListTile(
                        title: Text(comment['userName'] ?? 'Unknown'),
                        subtitle: Text(comment['text']),
                      );
                    },
                  ),
                  if (comments.length > 3) ...[
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _showAllComments = !_showAllComments;
                        });
                      },
                      child: Text(_showAllComments ? 'Show less comments' : 'Show more comments'),
                    ),
                  ],
                ],
              );
            },
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: 'Add a comment...',
                    hintStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                ),
              ),
              SizedBox(width: 10),
              IconButton(
                icon: Icon(Icons.send, color: Colors.blue),
                onPressed: () {
                  if (_commentController.text.isNotEmpty) {
                    _addComment(postId, _commentController.text);
                    _commentController.clear();
                  }
                },
              ),
            ],
          )

    ],
    );
  }

  Stream<DocumentSnapshot> _getUserLikeStream(String postId) {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance.collection('user_likes').doc(user.uid).collection('liked_posts').doc(postId).snapshots();
    }
    throw ArgumentError('User is not signed in.');
  }
}
