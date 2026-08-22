import 'package:app/ui/add_posts.dart';
import 'package:app/ui/login_screen.dart';
import 'package:app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: Column(
        children: [
          // ============================================================
          // HEADER
          // ============================================================

          Container(
            width: double.infinity,

            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryDark,
                  AppColors.primary,
                ],
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
                  // Decorative circle
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

                  // Decorative circle
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

                  // Header content
                  SafeArea(
                    bottom: false,

                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        12,
                        12,
                        22,
                      ),

                      child: Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.center,

                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,

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
                                    color:
                                    Colors.white.withOpacity(0.85),
                                    fontSize: 13.5,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Logout button
                          Container(
                            decoration: BoxDecoration(
                              color:
                              Colors.white.withOpacity(0.15),

                              borderRadius:
                              BorderRadius.circular(14),
                            ),

                            child: IconButton(
                              tooltip: 'Logout',

                              onPressed: () async {
                                try {
                                  await auth.signOut();

                                  if (!mounted) return;

                                  Navigator.pushAndRemoveUntil(
                                    context,

                                    MaterialPageRoute(
                                      builder: (context) =>
                                      const LoginScreen(),
                                    ),

                                        (route) => false,
                                  );
                                } catch (error) {
                                  Utils().toastMessage(
                                    error.toString(),
                                  );
                                }
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

          // ============================================================
          // POST LIST
          // ============================================================

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

                        valueColor:
                        AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    const Text(
                      'Loading',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              padding: const EdgeInsets.only(
                top: 10,
                bottom: 90,
              ),

              itemBuilder: (
                  context,
                  snapshot,
                  animation,
                  index,
                  ) {
                final postId = snapshot
                    .child('id')
                    .value
                    .toString();

                final title = snapshot
                    .child('title')
                    .value
                    .toString();

                return SizeTransition(
                  sizeFactor: animation,

                  child: Container(
                    margin: const EdgeInsets.fromLTRB(
                      16,
                      6,
                      16,
                      0,
                    ),

                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,

                      borderRadius:
                      BorderRadius.circular(16),

                      border: Border.all(
                        color: AppColors.border,
                      ),

                      boxShadow: [
                        BoxShadow(
                          color:
                          Colors.black.withOpacity(0.03),

                          blurRadius: 10,

                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),

                    child: Material(
                      color: Colors.transparent,

                      child: InkWell(
                        borderRadius:
                        BorderRadius.circular(16),

                        onTap: () {},

                        child: Padding(
                          padding:
                          const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),

                          child: Row(
                            children: [
                              // ==================================================
                              // POST ICON
                              // ==================================================

                              Container(
                                height: 46,
                                width: 46,

                                decoration: BoxDecoration(
                                  color: AppColors.primary
                                      .withOpacity(0.1),

                                  borderRadius:
                                  BorderRadius.circular(12),
                                ),

                                child: const Icon(
                                  Icons.article_outlined,

                                  color:
                                  AppColors.primary,

                                  size: 22,
                                ),
                              ),

                              const SizedBox(width: 14),

                              // ==================================================
                              // POST TEXT
                              // ==================================================

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,

                                  children: [
                                    Text(
                                      title,

                                      maxLines: 2,

                                      overflow:
                                      TextOverflow.ellipsis,

                                      style: const TextStyle(
                                        color:
                                        AppColors.textDark,

                                        fontWeight:
                                        FontWeight.w600,

                                        fontSize: 15.5,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.tag_rounded,

                                          size: 13,

                                          color:
                                          AppColors
                                              .textSecondary,
                                        ),

                                        const SizedBox(width: 3),

                                        Expanded(
                                          child: Text(
                                            postId,

                                            maxLines: 1,

                                            overflow:
                                            TextOverflow
                                                .ellipsis,

                                            style:
                                            const TextStyle(
                                              color: AppColors
                                                  .textSecondary,

                                              fontSize: 12.5,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // ==================================================
                              // THREE DOT MENU
                              // ==================================================

                              PopupMenuButton<String>(
                                color: Colors.white,

                                elevation: 4,

                                padding: EdgeInsets.zero,

                                shape:
                                RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(14),
                                ),

                                icon: const Icon(
                                  Icons.more_vert,

                                  color:
                                  AppColors.textSecondary,
                                ),

                                onSelected: (value) {
                                  if (value == 'edit') {
                                    _showUpdateDialog(
                                      postId,
                                      title,
                                    );
                                  }

                                  if (value == 'delete') {
                                    _deletePost(postId);
                                  }
                                },

                                itemBuilder: (context) => [
                                  // ==================================================
                                  // EDIT
                                  // ==================================================

                                  const PopupMenuItem<String>(
                                    value: 'edit',

                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.edit_outlined,

                                          color:
                                          AppColors.primary,

                                          size: 21,
                                        ),

                                        SizedBox(width: 12),

                                        Text(
                                          'Edit',

                                          style: TextStyle(
                                            color:
                                            AppColors
                                                .textDark,

                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // ==================================================
                                  // DELETE
                                  // ==================================================

                                  const PopupMenuItem<String>(
                                    value: 'delete',

                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.delete_outline,

                                          color:
                                          Colors.redAccent,

                                          size: 21,
                                        ),

                                        SizedBox(width: 12),

                                        Text(
                                          'Delete',

                                          style: TextStyle(
                                            color:
                                            AppColors
                                                .textDark,

                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
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

      // ================================================================
      // NEW POST BUTTON
      // ================================================================

      floatingActionButton:
      FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,

            MaterialPageRoute(
              builder: (context) =>
              const AddPostScreen(),
            ),
          );
        },

        backgroundColor: AppColors.primary,

        elevation: 3,

        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(18),
        ),

        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),

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

  // ================================================================
  // SHOW UPDATE DIALOG
  //
  // FIX: the previous version popped the dialog immediately, then
  // awaited the Firebase update + showed a toast afterwards. Popping
  // before the async work finished caused a "look up a deactivated
  // widget" red-screen error the first time, which then looked
  // "already updated" on the next run since Firebase had cached the
  // write. Now we await the update FIRST (with a small in-dialog
  // loading state), and only pop + toast once it's actually done.
  // ================================================================

  void _showUpdateDialog(
      String postId,
      String currentTitle,
      ) {
    final TextEditingController updateController =
    TextEditingController(
      text: currentTitle,
    );

    showDialog(
      context: context,

      barrierDismissible: false,

      builder: (dialogContext) {
        bool isUpdating = false;

        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),

              title: const Text(
                'Update',

                style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),

              content: TextField(
                controller: updateController,

                autofocus: true,

                maxLines: 3,

                enabled: !isUpdating,

                style: const TextStyle(
                  color: AppColors.textDark,
                  fontSize: 16,
                ),

                decoration: InputDecoration(
                  hintText: 'Enter your text',

                  hintStyle: const TextStyle(
                    color: AppColors.textSecondary,
                  ),

                  enabledBorder:
                  const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.border,
                    ),
                  ),

                  focusedBorder:
                  const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),

              actions: [
                // ============================================================
                // CANCEL
                // ============================================================

                TextButton(
                  onPressed: isUpdating
                      ? null
                      : () {
                    Navigator.pop(dialogContext);
                  },

                  child: const Text(
                    'Cancel',

                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // ============================================================
                // UPDATE
                // ============================================================

                TextButton(
                  onPressed: isUpdating
                      ? null
                      : () async {
                    final newTitle =
                    updateController.text.trim();

                    if (newTitle.isEmpty) {
                      Utils().toastMessage(
                        'Please enter some text',
                      );

                      return;
                    }

                    setDialogState(() => isUpdating = true);

                    final success = await _updatePost(
                      postId,
                      newTitle,
                    );

                    if (!mounted) return;

                    // Close the dialog only after the write
                    // has actually finished.
                    Navigator.pop(dialogContext);

                    if (success) {
                      Utils().toastMessage(
                        'Post updated successfully',
                      );
                    }
                  },

                  child: isUpdating
                      ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      valueColor:
                      AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  )
                      : const Text(
                    'Update',

                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      updateController.dispose();
    });
  }

  // ================================================================
  // UPDATE POST IN FIREBASE
  //
  // Returns true/false instead of showing its own success toast, so
  // the caller can show the toast only after the dialog has safely
  // closed (avoids the context-after-dispose error).
  // ================================================================

  Future<bool> _updatePost(
      String postId,
      String newTitle,
      ) async {
    try {
      await ref.child(postId).update({
        'title': newTitle,
      });

      return true;
    } catch (error) {
      if (mounted) {
        Utils().toastMessage(
          error.toString(),
        );
      }

      return false;
    }
  }

  // ================================================================
  // DELETE POST
  // ================================================================

  Future<void> _deletePost(
      String postId,
      ) async {
    try {
      await ref.child(postId).remove();

      if (!mounted) return;

      Utils().toastMessage(
        'Post deleted successfully',
      );
    } catch (error) {
      if (!mounted) return;

      Utils().toastMessage(
        error.toString(),
      );
    }
  }
}