import 'package:apitor/analytics/data/project_create_request_dto.dart';
import 'package:apitor/analytics/data/project_details_dto.dart';
import 'package:apitor/analytics/service/project_service.dart';
import 'package:apitor/components/custom_expanded.dart';
import 'package:apitor/components/pop_up_card.dart';
import 'package:apitor/screens/auth/auth_components.dart';
import 'package:apitor/screens/dashboard/project_token_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({super.key});

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  late Future<List<ProjectDetailsDTO>> projectDetails;

  @override
  void initState() {
    super.initState();
    projectDetails = ProjectService.getAllProjects();
  }

  void _retryFetch() {
    setState(() {
      projectDetails = ProjectService.getAllProjects();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth<450;

    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(24.0),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Your Projects',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
                isMobile?
                ElevatedButton(
                  onPressed: () {
                    showCreateProjectDialog(context, () {
                      _retryFetch(); 
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,

                    foregroundColor: Colors.white,
                  
                    shape: CircleBorder()
                  ),
                   child: const Icon(Icons.add, size: 20),
                )
                :
                ElevatedButton.icon(
                  onPressed: () {
                    showCreateProjectDialog(context, () {
                      _retryFetch(); 
                    });
                  },
                  icon: const Icon(Icons.add, size: 20),
                  label:const Text('Create'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,

                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile?6:20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                    
                  ),
                ),
              ],
            ),
          ),
          FutureBuilder<List<ProjectDetailsDTO>>(
            future: projectDetails,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [CircularProgressIndicator()],
                  ),
                );
              }

              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.cloud_off, color: Colors.red, size: 64),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load projects',
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        snapshot.error.toString(),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _retryFetch,
                        child: const Text('Retry Fetch'),
                      ),
                    ],
                  ),
                );
              }

              if (snapshot.hasData) {
                final projects = snapshot.data!;

                if (projects.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.folder_open_outlined,
                          size: 80,
                          color: theme.primaryColor.withValues(alpha: 0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No projects yet',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Create your first project to get started',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 20.0,
                  ),
                  child: Column(
                    children: [
                      for (var index = 0; index < projects.length; index++)
                        _buildProjectCard(
                          context,
                          theme,
                          projects[index],
                          index,
                          isMobile
                        ),
                    ],
                  ),
                );
              }

              return const Padding(
                padding: EdgeInsets.all(24.0),
                child: Text('Something went wrong'),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(
    BuildContext context,
    ThemeData theme,
    ProjectDetailsDTO project,
    int index,
    bool isMobile
  ) {

    return PopupHoverCard(
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.primaryColor.withValues(alpha: 0.15),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.primaryColor.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flex(
                direction: isMobile? Axis.vertical : Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.projectName,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Project ID: ${project.id}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                
                ],
              ),
              const SizedBox(height: 16),
              Flex(
                direction: isMobile? Axis.vertical: Axis.horizontal,
                children: [
                  CustomExpanded(
                    isExpanded: !isMobile,
                    child: _buildTokenDetailItem(
                      theme,
                      project.projectToken,
                    ),
                  ),
                  const SizedBox(width: 12, height:12),
                  CustomExpanded(
                    isExpanded: !isMobile,
                    child: _buildDetailItem(
                      theme,
                      'URL',
                      project.targetURL,
                      Icons.link,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Flex(
                  direction: isMobile? Axis.vertical: Axis.horizontal,
                children: [
                  CustomExpanded(
                    isExpanded: !isMobile,
                    child: _buildDetailItem(
                      theme,
                      'Created At',
                      DateFormat('dd-MMM-yyyy').format(project.createdAt.toLocal()),
                      Icons.calendar_today,
                    ),
                  ),
                  const SizedBox(width: 12, height:12),
                  CustomExpanded(
                    isExpanded: !isMobile,
                    child: _buildDetailItem(
                      theme,
                      'Status',
                      'Active',
                      Icons.check_circle_outline,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              PopupHoverCard(
                onTap:(){
                  context.go('/dashboard/projects/analytics', extra: project);
                },
                popupColor: theme.primaryColor.withValues(alpha:0.1),
                cursor: SystemMouseCursors.click,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: theme.primaryColor.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.analytics_outlined,
                        size: 18,
                        color: theme.primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'View Analytics',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.w500,
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
    );
  }

  Widget _buildTokenDetailItem(ThemeData theme, String token) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.vpn_key,
                size: 14,
                color: theme.primaryColor,
              ),
              const SizedBox(width: 4),
              Text(
                'Token',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ProjectTokenField(
            token: token,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 14,
                color: theme.primaryColor,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void showCreateProjectDialog(BuildContext context, VoidCallback onProjectCreated) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController urlController = TextEditingController();
    bool isSubmitting = false; 

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        final theme = Theme.of(context);

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: Colors.white,
              
              contentPadding: const EdgeInsets.all(32.0), 
              content: SizedBox(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              color: theme.primaryColor.withValues(alpha:0.05),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.create_new_folder_outlined,
                              size: 24,
                              color: theme.primaryColor,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'New Project',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      AuthFormField(
                        field: 'Project Name',
                        placeholder: 'Enter your project name',
                        controller: nameController,
                        icon: Icons.assignment_outlined,
                        validate: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Project name cannot be blank";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      AuthFormField(
                        field: 'Target URL',
                        placeholder: 'Enter target URL (e.g., https://api.com)',
                        controller: urlController,
                        icon: Icons.link,
                        validate: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Target URL cannot be blank";
                          }
                          if (!value.startsWith('http://') && !value.startsWith('https://')) {
                            return "URL must start with http:// or https://";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                            ),
                            elevation: 2,
                          ),
                          onPressed: isSubmitting
                              ? null
                              : () async {
                                  if (formKey.currentState!.validate()) {
                                    setDialogState(() {
                                      isSubmitting = true;
                                    });

                                    try {
                                      String projectName = nameController.text.trim();
                                      String targetURL = urlController.text.trim();

                                     ProjectCreateRequestDTO request = ProjectCreateRequestDTO(projectName: projectName, targetURL: targetURL);
                                      
                                     await ProjectService.createProject(request);

                                      if (context.mounted) {
                                        Navigator.of(context).pop(); 
                                        onProjectCreated();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Project created successfully!')),
                                        );
                                      }
                                    } catch (e) {
                                      if(!context.mounted) return;
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Failed to create Project')),
                                        );
                                    } finally {
                                      setDialogState(() {
                                        isSubmitting = false;
                                      });
                                    }
                                  }
                                },
                          child: !isSubmitting
                              ? Text(
                                  'Submit',
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              : Transform.scale(
                                  scale: 0.75,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                    
                     SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 210, 210, 210),
                            foregroundColor: const Color.fromARGB(255, 189, 189, 189).withValues(alpha:0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                            ),
                            elevation: 2,
                          ),
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Cancel',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: Colors.black.withValues(alpha:0.7),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                            
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
