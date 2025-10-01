// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geargrid/core/utils/snackbar_helper.dart';
import 'package:go_router/go_router.dart';
import '../../common/widgets/light_dark.dart';
import '../../common/widgets/custom_app_bar.dart';
import '../../core/providers/flutter_riverpod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authControllerProvider).getProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authController = ref.watch(authControllerProvider);
    final user = authController.currentUser;
    final isLoading = authController.isLoading;

    return Scaffold(
      appBar: CustomAppBar(
        title: "Account",
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: user?.avatarUrl != null
                            ? NetworkImage(user!.avatarUrl!)
                            : const AssetImage('assets/images/launcher_icon.png')
                                as ImageProvider,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        user?.displayName ?? "User12345",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        user?.email ?? "user@email.com",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "ID: ${user?.userId ?? 'N/A'}",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildListTile(
                        icon: Icons.lock_outline,
                        title: "Privacy Policy",
                        onTap: () => debugPrint("Go to Privacy Policy"),
                      ),
                      _buildListTile(
                        icon: Icons.article_outlined,
                        title: "Terms & Conditions",
                        onTap: () => debugPrint("Go to Terms & Conditions"),
                      ),
                      _buildListTile(
                        icon: Icons.info_outline,
                        title: "About GearGrid",
                        onTap: () => debugPrint("Go to About Page"),
                      ),
                      ListTile(
                        leading: const Icon(Icons.color_lens_outlined),
                        title: const Text("App Appearance"),
                        trailing: LightDark(),
                      ),
                      _buildListTile(
                        icon: Icons.edit_outlined,
                        title: "Update Profile",
                        onTap: () async {
                          context.push('/update-profile');
                          await ref.read(authControllerProvider).getProfile();
                        },
                      ),
                      _buildListTile(
                        icon: Icons.delete_outline,
                        title: "Delete Account",
                        onTap: () => debugPrint("Go to Delete Account Flow"),
                      ),
                      Divider(
                        height: 40,
                        thickness: 1,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.3),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .error
                              .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          onTap: () async {
                            await authController.logout();
                            if (!authController.isAuthenticated) {
                              context.go('/login');
                            } else {
                              SnackBarHelper.showError(
                                context,
                                "Logout Failed",
                                authController.error ?? "An error occurred.",
                              );
                            }
                          },
                          borderRadius: BorderRadius.circular(12),
                          splashColor: Theme.of(context)
                              .colorScheme
                              .error
                              .withValues(alpha: 0.2),
                          highlightColor: Theme.of(context)
                              .colorScheme
                              .error
                              .withValues(alpha: 0.1),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.logout,
                                    color:
                                        Theme.of(context).colorScheme.error),
                                const SizedBox(width: 8),
                                Text(
                                  "Sign Out",
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}