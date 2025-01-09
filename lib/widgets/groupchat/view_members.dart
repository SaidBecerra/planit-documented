import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:planit/widgets/groupchat/invite_code_screen.dart';
import 'package:planit/widgets/scaffold_layout.dart';
import 'package:planit/widgets/main_button.dart';

class ViewMembersScreen extends StatefulWidget {
  final String groupchatID;
  const ViewMembersScreen({required this.groupchatID, super.key});

  @override
  State<ViewMembersScreen> createState() => ViewMembersScreenState();
}

class ViewMembersScreenState extends State<ViewMembersScreen> {
  List<Map<String, dynamic>> _members = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMembers();
  }

  Future<void> _fetchMembers() async {
    try {
      final groupChatDoc = await FirebaseFirestore.instance
          .collection('groupchats')
          .doc(widget.groupchatID)
          .get();

      if (groupChatDoc.exists) {
        final groupData = groupChatDoc.data();
        if (groupData != null) {
          final memberIDs = groupData['members'] as List<dynamic>;
          final memberDetails = await Future.wait(memberIDs.map((id) async {
            final userDoc = await FirebaseFirestore.instance
                .collection('users')
                .doc(id)
                .get();
            if (userDoc.exists) {
              return {
                'username': userDoc['username'] ?? 'Unknown',
                'imageURL': userDoc['imageURL'] ?? '',
              };
            }
            return null;
          }).toList());

          setState(() {
            _members = memberDetails.whereType<Map<String, dynamic>>().toList();
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        _showErrorSnackbar('Group chat not found!');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackbar('Error fetching members: $e');
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red.shade800,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldLayout(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: Text(
                'Group Members',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Text(
              '${_members.length} members',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _buildMembersList(),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: MainButton(
                text: 'Add Member',
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => InviteCodeScreen(
                        groupchatID: widget.groupchatID,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMembersList() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_members.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.group_off_outlined,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No members found',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _members.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (ctx, index) {
        final member = _members[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8,
          ),
          leading: Hero(
            tag: 'member-avatar-${member['username']}',
            child: CircleAvatar(
              radius: 24,
              backgroundImage: member['imageURL'] != ''
                  ? NetworkImage(member['imageURL'])
                  : null,
              backgroundColor: Colors.grey.shade200,
              child: member['imageURL'] == ''
                  ? Icon(
                      Icons.person,
                      size: 24,
                      color: Colors.grey.shade400,
                    )
                  : null,
            ),
          ),
          title: Text(
            member['username'],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      },
    );
  }
}