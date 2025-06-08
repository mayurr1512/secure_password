import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/data/model/credential.dart';
import 'package:password_manager/ui/bloc/credential_bloc.dart';
import 'package:password_manager/ui/widgets/custom_text_field.dart';
import 'package:password_manager/utils/password_utils.dart';
import 'package:password_manager/utils/util_extensions.dart';
import 'package:sizer/sizer.dart';

void showCredentialBottomSheet(BuildContext context, Credential? credential) {
  final isEditing = credential != null;
  bool obscurePassword = true;
  final siteController = TextEditingController(text: credential?.siteName);
  final usernameController = TextEditingController(text: credential?.username);
  final passwordController = TextEditingController(text: credential?.password);

  String selectedCategory = credential?.category ?? 'Personal';
  final categories = ['Personal', 'Work', 'Others'];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (context, setState) {
          PasswordStrength strength = getPasswordStrength(passwordController.text);

          String? strengthLabel;
          Color strengthColor = Colors.grey;
          if (strength == PasswordStrength.empty) {
            strengthLabel = null;
          } else if (strength == PasswordStrength.weak) {
            strengthLabel = 'Weak password';
            strengthColor = Colors.red;
          } else if (strength == PasswordStrength.medium) {
            strengthLabel = 'Medium strength';
            strengthColor = Colors.orange;
          } else if (strength == PasswordStrength.strong) {
            strengthLabel = 'Strong password';
            strengthColor = Colors.green;
          }

          passwordController.addListener(() {
            setState(() {});
          });

          return Padding(
            padding: EdgeInsets.only(
              left: 4.w,
              right: 4.w,
              top: 2.h,
              bottom: MediaQuery.of(context).viewInsets.bottom
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  Text(
                    isEditing ? "Edit Password" : "Add Password",
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.indigo,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  SizedBox(height: 3.h),

                  // SiteName TextField
                  buildTextField(
                    controller: siteController,
                    labelText: 'Site Name'
                  ),
                  SizedBox(height: 2.5.h),

                  // UserName TextField
                  buildTextField(
                    controller: usernameController,
                    labelText: 'Username'
                  ),
                  SizedBox(height: 2.5.h),

                  // Password TextField
                  buildTextField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    labelText: 'Password',
                    isPasswordField: true,
                    textInputAction: TextInputAction.done,
                    onVisibilityToggle: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                    helperText: strengthLabel,
                    helperStyle: TextStyle(color: strengthColor)
                  ),
                  SizedBox(height: 1.h),


                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          final generated = generatePassword();
                          setState(() {
                            passwordController.text = generated;
                          });
                        },
                        icon: const Icon(Icons.password),
                        label: const Text("Generate")
                      ),

                      SizedBox(width: 4.w),
                      ElevatedButton.icon(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: passwordController.text));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Copied to clipboard")),
                          );

                          Future.delayed(const Duration(seconds: 30), () {
                            Clipboard.setData(const ClipboardData(text: ''));
                          });
                        },
                        icon: const Icon(Icons.copy_rounded),
                        label: const Text("Copy")
                      )
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    "Hint : Use at least 8 characters with a mix of letters (uppercase, lowercase), numbers & symbols.",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(height: 2.5.h),

                  // Category Dropdown
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    items: categories.map((cat) {
                      return DropdownMenuItem<String>(
                        value: cat,
                        child: Text(cat),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedCategory = value;
                        });
                      }
                    },
                    decoration: const InputDecoration(labelText: 'Category'),
                  ),

                  SizedBox(height: 5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (siteController.text.trim().isEmpty ||
                                usernameController.text.trim().isEmpty ||
                                passwordController.text.trim().isEmpty
                            ) {
                              "Please fill all the fields".toastError();
                              return;
                            }

                            final newCredential = Credential(
                              id: isEditing ? credential.id : null,
                              siteName: siteController.text,
                              username: usernameController.text,
                              password: passwordController.text,
                              category: selectedCategory,
                            );

                            if (isEditing) {

                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Update Password"),
                                    content: const Text("Are you sure you want to update this password?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context), // Cancel
                                        child: const Text("No"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          context.read<CredentialBloc>().add(UpdateCredential(newCredential));
                                          Navigator.pop(context); // Close dialog
                                          Navigator.pop(context); // Close bottom sheet
                                        },
                                        child: const Text("Yes"),
                                      ),
                                    ],
                                  );
                                },
                              );

                            } else {
                              context.read<CredentialBloc>().add(AddCredential(newCredential));
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16)
                          ),
                          child: Text(
                              isEditing ? 'Update' : 'Save',
                              style: TextStyle(color: Colors.white, fontSize: 16.sp)
                          )
                        )
                      ),

                      if (isEditing)
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 4.w),
                            child: ElevatedButton(
                                onPressed: () {

                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text("Delete Password"),
                                        content: const Text("Are you sure you want to delete this password?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text("No"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              context.read<CredentialBloc>().add(DeleteCredential(credential));
                                              Navigator.pop(context); // Close dialog
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Yes", style: TextStyle(color: Colors.red)),
                                          )
                                        ],
                                      );
                                    },
                                  );

                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 16)
                                ),
                                child: Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.white, fontSize: 16.sp)
                                )
                            ),
                          ),
                        )
                    ],
                  ),

                  SizedBox(height: 5.h)
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
