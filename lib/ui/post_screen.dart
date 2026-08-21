import 'package:app/ui/add_posts.dart';
import 'package:app/ui/login_screen.dart';
import 'package:app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

// Shared design tokens — kept identical to the other redesigned screens
// so the whole app stays visually consistent.
class AppColors {
  static const Color primary = Colors.blue;
  static const Color primaryDark = Color(0xff1355D6);
  static const Color background = Color(0xffF5F7FB);
  static const Color cardBackground = Colors.white;
  static const Color textDark = Color(0xff1A1D29);
  static const Color textSecondary = Color(0xff8A8D9F);
  static const Color inputFill = Color(0xffF0F3F9);
  static const Color border = Color(0xffE3E7EF);
}

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Post');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Gradient hero app bar
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primaryDark, AppColors.primary],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -50,
                    right: -40,
                    child: Container(
                      height: 140,
                      width: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.08),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -60,
                    left: -30,
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.06),
                      ),
                    ),
                  ),
                  SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 12, 22),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'My Posts',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'All your posts in one place',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.85),
                                    fontSize: 13.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: IconButton(
                              tooltip: 'Logout',
                              onPressed: () {
                                auth
                                    .signOut()
                                    .then((value) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          LoginScreen(),
                                    ),
                                  );
                                })
                                    .onError((error, stackTrace) {
                                  Utils().toastMessage(
                                    error.toString(),
                                  );
                                });
                              },
                              icon: const Icon(
                                Icons.logout_outlined,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Post list
          Expanded(
            child: FirebaseAnimatedList(
              query: ref,
              defaultChild: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 26,
                      width: 26,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.6,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Loading',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              padding: const EdgeInsets.only(top: 10, bottom: 90),
              itemBuilder: (context, snapshot, animation, index) {
                return SizeTransition(
                  sizeFactor: animation,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(16, 6, 16, 0),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 46,
                                width: 46,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.article_outlined,
                                  color: AppColors.primary,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot
                                          .child('title')
                                          .value
                                          .toString(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: AppColors.textDark,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15.5,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.tag_rounded,
                                          size: 13,
                                          color: AppColors.textSecondary,
                                        ),
                                        const SizedBox(width: 3),
                                        Expanded(
                                          child: Text(
                                            snapshot
                                                .child('id')
                                                .value
                                                .toString(),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: AppColors.textSecondary,
                                              fontSize: 12.5,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuButton(
                                color: Colors.white,
                                elevation: 4,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                icon: const Icon(
                                  Icons.more_vert,
                                  color: AppColors.textSecondary,
                                ),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 1,
                                    child: PopupMenuItem(
                                      value: 2,
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.pop(context);

                                          ref
                                              .child(
                                            snapshot
                                                .child('id')
                                                .value
                                                .toString(),
                                          )
                                              .update({
                                            'title': 'nice world',
                                          })
                                              .then((value) {})
                                              .onError((
                                              error,
                                              stackTrace,
                                              ) {
                                            Utils().toastMessage(
                                              error.toString(),
                                            );
                                          });
                                        },
                                        leading: const Icon(
                                          Icons.edit_outlined,
                                          color: AppColors.primary,
                                        ),
                                        title: const Text(
                                          'Edit',
                                          style: TextStyle(
                                            color: AppColors.textDark,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 2,
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.pop(context);

                                        // ref.child(snapshot.child('id').value.toString()).update(
                                        //     {
                                        //       'ttitle' : 'hello world'
                                        //     }).then((value){
                                        //
                                        // }).onError((error, stackTrace){
                                        //   Utils().toastMessage(error.toString());
                                        // });
                                        ref
                                            .child(
                                          snapshot
                                              .child('id')
                                              .value
                                              .toString(),
                                        )
                                            .remove()
                                            .then((value) {})
                                            .onError((
                                            error,
                                            stackTrace,
                                            ) {
                                          Utils().toastMessage(
                                            error.toString(),
                                          );
                                        });
                                      },
                                      leading: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.redAccent,
                                      ),
                                      title: const Text(
                                        'Delete',
                                        style: TextStyle(
                                          color: AppColors.textDark,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPostScreen()),
          );
        },
        backgroundColor: AppColors.primary,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'New Post',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}