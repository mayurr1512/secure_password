import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/data/model/credential.dart';
import 'package:password_manager/ui/bloc/credential_bloc.dart';
import 'package:password_manager/ui/theme/theme_cubit.dart';
import 'package:sizer/sizer.dart';
import '../widgets/bottom_sheet_credentials.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Map<String, bool> _passwordVisibility = {};
  final Map<String, bool> _categoryExpanded = {}; // Track expanded state

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CredentialBloc, CredentialState>(
      builder: (context, state) {
        bool showFab = false;

        Widget body = const Center(child: CircularProgressIndicator());

        if (state is CredentialLoaded) {
          final credentials = state.credentials;
          showFab = credentials.isNotEmpty;

          if (credentials.isEmpty) {
            body = Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.lock_outline, size: 50, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    "You haven't added any credentials yet",
                    style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => showCredentialBottomSheet(context, null),
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text("Click to Add"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            final grouped = <String, List<Credential>>{};
            for (var cred in credentials) {
              grouped.putIfAbsent(cred.category, () => []).add(cred);
            }

            body = ListView(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              children: grouped.entries.map((entry) {
                final category = entry.key;
                final credentialsList = entry.value;
                final isExpanded = _categoryExpanded[category] ?? true;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _categoryExpanded[category] = !isExpanded;
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        color: const Color(0xFFC2C2C2),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              category,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                            Icon(
                              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (isExpanded)
                      ...credentialsList.map((cred) {
                        final key = '${cred.siteName}_${cred.username}';
                        final isVisible = _passwordVisibility[key] ?? false;

                        return Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 1,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      cred.username,
                                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        cred.siteName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.sp,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(isVisible ? cred.password : '******'),
                                    ),
                                    IconButton(
                                      icon: Icon(isVisible ? Icons.visibility_off : Icons.visibility),
                                      onPressed: () {
                                        setState(() {
                                          _passwordVisibility[key] = !isVisible;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            onTap: () => showCredentialBottomSheet(context, cred),
                          ),
                        );
                      }),
                    SizedBox(height: 2.h),
                  ],
                );
              }).toList(),
            );
          }
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Secure Password', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.indigo,
            actions: [
              IconButton(
                icon: const Icon(Icons.brightness_6, color: Colors.white),
                onPressed: () => context.read<ThemeCubit>().toggleTheme(),
              ),
            ]
          ),
          body: body,
          floatingActionButton: showFab
              ? FloatingActionButton(
            onPressed: () => showCredentialBottomSheet(context, null),
            backgroundColor: Colors.indigo,
            child: const Icon(Icons.add, color: Colors.white),
          )
              : null,
        );
      },
    );
  }
}