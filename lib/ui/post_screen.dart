import 'package:app/ui/add_posts.dart';
import 'package:app/ui/login_screen.dart';
import 'package:app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final _auth = FirebaseAuth.instance;
  final _ref = FirebaseDatabase.instance.ref('Post');

  final TextEditingController _searchController =
  TextEditingController();

  String _searchText = '';

  Future<void> _signOut() async {
    try {
      await _auth.signOut();

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
            (route) => false,
      );
    } catch (e) {
      Utils().toastMessage(e.toString());
    }
  }

  Future<void> _updatePost(String id) async {
    try {
      await _ref.child(id).update({
        'title': 'Updated Title',
      });

      Utils().toastMessage('Post Updated');
    } catch (e) {
      Utils().toastMessage(e.toString());
    }
  }

  Future<void> _deletePost(String id) async {
    try {
      await _ref.child(id).remove();

      Utils().toastMessage('Post Deleted');
    } catch (e) {
      Utils().toastMessage(e.toString());
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,

        title: const Text(
          'My Posts',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),

        actions: [
          IconButton(
            tooltip: 'Logout',
            onPressed: _signOut,
            icon: const Icon(
              Icons.logout_rounded,
              color: Colors.black87,
            ),
          ),

          const SizedBox(width: 8),
        ],
      ),

      body: Column(
        children: [

          // Header
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(
              20,
              5,
              20,
              20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                if (user?.email != null)
                  Row(
                    children: [
                      Container(
                        height: 38,
                        width: 38,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          color: Colors.blue,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          user!.email!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 18),

                // Search
                TextField(
                  controller: _searchController,

                  onChanged: (value) {
                    setState(() {
                      _searchText = value.trim().toLowerCase();
                    });
                  },

                  decoration: InputDecoration(
                    hintText: 'Search posts...',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                    ),

                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: Colors.blue,
                    ),

                    suffixIcon: _searchText.isNotEmpty
                        ? IconButton(
                      onPressed: () {
                        _searchController.clear();

                        setState(() {
                          _searchText = '';
                        });
                      },
                      icon: const Icon(
                        Icons.clear_rounded,
                      ),
                    )
                        : null,

                    filled: true,
                    fillColor: const Color(0xffF5F7FB),

                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 15,
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Posts
          Expanded(
            child: StreamBuilder<DatabaseEvent>(
              stream: _ref.onValue,

              builder: (context, snapshot) {

                // Loading
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // Error
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Something went wrong',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 16,
                      ),
                    ),
                  );
                }

                final data = snapshot.data?.snapshot.value;

                // No posts
                if (data == null) {
                  return _emptyState(
                    icon: Icons.article_outlined,
                    title: 'No Posts Yet',
                    subtitle:
                    'Create your first post using the + button.',
                  );
                }

                final Map<dynamic, dynamic> posts =
                data as Map<dynamic, dynamic>;

                final List<Map<String, dynamic>> postList = [];

                posts.forEach((key, value) {

                  if (value is Map) {
                    final title =
                        value['title']?.toString() ?? '';

                    final id =
                        value['id']?.toString() ?? key.toString();

                    postList.add({
                      'key': key.toString(),
                      'title': title,
                      'id': id,
                    });
                  }
                });

                // Search filtering
                final filteredPosts = postList.where((post) {

                  final title =
                  post['title'].toString().toLowerCase();

                  final id =
                  post['id'].toString().toLowerCase();

                  return title.contains(_searchText) ||
                      id.contains(_searchText);
                }).toList();

                // Search result empty
                if (filteredPosts.isEmpty) {
                  return _emptyState(
                    icon: Icons.search_off_rounded,
                    title: 'No Posts Found',
                    subtitle:
                    'Try searching with a different title or ID.',
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    16,
                    16,
                    100,
                  ),

                  itemCount: filteredPosts.length,

                  itemBuilder: (context, index) {

                    final post = filteredPosts[index];

                    final title =
                    post['title'].toString();

                    final id =
                    post['id'].toString();

                    final key =
                    post['key'].toString();

                    return _postCard(
                      title: title,
                      id: id,
                      firebaseKey: key,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,

        elevation: 5,

        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddPostScreen(),
            ),
          );
        },

        icon: const Icon(Icons.add_rounded),

        label: const Text(
          'Add Post',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _postCard({
    required String title,
    required String id,
    required String firebaseKey,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Row(
          children: [

            // Post icon
            Container(
              height: 52,
              width: 52,

              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(15),
              ),

              child: const Icon(
                Icons.article_rounded,
                color: Colors.blue,
                size: 27,
              ),
            ),

            const SizedBox(width: 14),

            // Post information
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Text(
                    title.isEmpty ? 'Untitled Post' : title,

                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,

                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 7),

                  Row(
                    children: [

                      Icon(
                        Icons.tag_rounded,
                        size: 15,
                        color: Colors.grey.shade500,
                      ),

                      const SizedBox(width: 4),

                      Expanded(
                        child: Text(
                          id,

                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,

                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Menu
            PopupMenuButton<String>(
              icon: const Icon(
                Icons.more_vert_rounded,
              ),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),

              onSelected: (value) {

                if (value == 'edit') {
                  _updatePost(firebaseKey);
                }

                if (value == 'delete') {
                  _showDeleteDialog(
                    firebaseKey,
                    title,
                  );
                }
              },

              itemBuilder: (context) => [

                const PopupMenuItem(
                  value: 'edit',

                  child: Row(
                    children: [
                      Icon(
                        Icons.edit_rounded,
                        color: Colors.blue,
                      ),

                      SizedBox(width: 10),

                      Text('Edit'),
                    ],
                  ),
                ),

                const PopupMenuItem(
                  value: 'delete',

                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.red,
                      ),

                      SizedBox(width: 10),

                      Text('Delete'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Container(
              height: 85,
              width: 85,

              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),

              child: Icon(
                icon,
                size: 42,
                color: Colors.blue,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              title,

              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              subtitle,

              textAlign: TextAlign.center,

              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteDialog(
      String id,
      String title,
      ) async {
    final result = await showDialog<bool>(
      context: context,

      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          title: const Text(
            'Delete Post?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          content: Text(
            'Are you sure you want to delete "$title"?',
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },

              child: const Text('Cancel'),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),

              onPressed: () {
                Navigator.pop(context, true);
              },

              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      await _deletePost(id);
    }
  }
}