import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfileDetailPage extends StatefulWidget {
  final String userId;
  final String userName;

  UserProfileDetailPage({required this.userId, required this.userName});

  @override
  _UserProfileDetailPageState createState() => _UserProfileDetailPageState();
}

class _UserProfileDetailPageState extends State<UserProfileDetailPage> {
  bool _showAllComments = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // AppBar and user profile header
          Stack(
            children: [
              ClipPath(
                clipper: CurvedAppBarClipper(),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green.shade500, Colors.blue.shade500], // Gradient colors
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.3, 0.9], // Gradient stops
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Positioned(
                left: 20,
                right: 20,
                top: 100,
                child: Text(
                  '${widget.userName}\'s Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),

          // User posts section
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .where('userId', isEqualTo: widget.userId)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final userPosts = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: userPosts.length,
                  itemBuilder: (context, index) {
                    final post = userPosts[index];

                    return Column(
                      children: [
                        // User post
                        Card(
                          elevation: 4,
                          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.green,
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: Text(
                                    widget.userName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle: Text(
                                    post['timestamp'].toDate().toString(),
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  post['text'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Comments section
                        _buildCommentSection(post.reference),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentSection(DocumentReference postRef) {
    return StreamBuilder<QuerySnapshot>(
      stream: postRef.collection('comments').orderBy('timestamp').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox.shrink(); // Hide if no comments yet
        }

        final comments = snapshot.data!.docs;

        return Column(
          children: [
            for (var i = 0; i < (comments.length > 3 ? (_showAllComments ? comments.length : 3) : comments.length); i++)
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  comments[i]['userName'] ?? 'Unknown',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(comments[i]['text']),
              ),
            if (comments.length > 3) ...[
              TextButton(
                onPressed: () {
                  setState(() {
                    _showAllComments = !_showAllComments;
                  });
                },
                child: Text(_showAllComments ? 'Show Less Comments' : 'Show More Comments'),
              ),
            ],
            Divider(),
            _buildCommentInput(postRef),
          ],
        );
      },
    );
  }

  Widget _buildCommentInput(DocumentReference postRef) {
    final TextEditingController _commentController = TextEditingController();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                labelText: 'Add a comment...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              if (_commentController.text.isNotEmpty) {
                _addComment(postRef, _commentController.text);
                _commentController.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _addComment(DocumentReference postRef, String commentText) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await postRef.collection('comments').add({
      'text': commentText,
      'timestamp': Timestamp.now(),
      'userId': user.uid,
      'userName': user.displayName, // Assuming user has displayName set
    });
  }
}

class CurvedAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    var firstControlPoint = Offset(size.width / 2, size.height);
    var firstEndPoint = Offset(size.width, size.height - 50);
    path.quadraticBezierTo(
        firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
