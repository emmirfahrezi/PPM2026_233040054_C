import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'image_picker_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF2E6FE7),
      ),
      home: const ProfilePage(),
    );
  }
}

class ProfileData {
  const ProfileData({
    required this.name,
    required this.headline,
    required this.about,
    required this.education,
    required this.location,
    required this.hobbies,
    required this.email,
    required this.phone,
    required this.avatarBytes,
    required this.postCount,
    required this.friendCount,
    required this.likeCount,
    required this.skills,
  });

  final String name;
  final String headline;
  final String about;
  final String education;
  final String? location;
  final String hobbies;
  final String email;
  final String phone;
  final Uint8List? avatarBytes;
  final String postCount;
  final String friendCount;
  final String likeCount;
  final List<String> skills;

  factory ProfileData.initial() {
    return const ProfileData(
      name: 'Emmir Fahrezi',
      headline: 'Fullstack Developer, Designer Grafis, Mahasiswa Informatika',
      about:
          'Saya berkuliah di Teknik Informatika Unpas semester 6. Minat saya ada di pengembangan aplikasi, website, dan desain.',
      education: 'Universitas Pasundan - Teknik Informatika Semester 6',
      location: 'Bandung, Indonesia',
      hobbies: 'Coding, Game, Desain, Musik, Voli',
      email: 'emmir@gmail.com',
      phone: '+62 812-000-00',
      avatarBytes: null,
      postCount: '25',
      friendCount: '540',
      likeCount: '1M',
      skills: <String>['Flutter', 'React', 'UI/UX', 'Firebase', 'Figma'],
    );
  }

  ProfileData copyWith({
    String? name,
    String? headline,
    String? about,
    String? education,
    String? location,
    String? hobbies,
    String? email,
    String? phone,
    Uint8List? avatarBytes,
    String? postCount,
    String? friendCount,
    String? likeCount,
    List<String>? skills,
  }) {
    return ProfileData(
      name: name ?? this.name,
      headline: headline ?? this.headline,
      about: about ?? this.about,
      education: education ?? this.education,
      location: location ?? this.location,
      hobbies: hobbies ?? this.hobbies,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarBytes: avatarBytes ?? this.avatarBytes,
      postCount: postCount ?? this.postCount,
      friendCount: friendCount ?? this.friendCount,
      likeCount: likeCount ?? this.likeCount,
      skills: skills ?? this.skills,
    );
  }
}

class ExperienceData {
  const ExperienceData({
    required this.title,
    required this.description,
    required this.imageBytes,
  });

  final String title;
  final String description;
  final Uint8List? imageBytes;

  factory ExperienceData.initial() {
    return ExperienceData(
      title: 'Project Mobile App',
      description:
          'Membangun aplikasi profil responsif dengan Flutter dan tampilan modern.',
      imageBytes: null,
    );
  }

  ExperienceData copyWith({
    String? title,
    String? description,
    Uint8List? imageBytes,
  }) {
    return ExperienceData(
      title: title ?? this.title,
      description: description ?? this.description,
      imageBytes: imageBytes ?? this.imageBytes,
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileData _profile = ProfileData.initial();
  ExperienceData _experience = ExperienceData.initial();

  Future<void> _openEditProfile() async {
    final updatedProfile = await Navigator.of(context).push<ProfileData>(
      MaterialPageRoute(builder: (_) => EditProfilePage(profile: _profile)),
    );

    if (updatedProfile == null) {
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _profile = updatedProfile;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Profil berhasil diperbarui')));
  }

  Future<void> _openEditExperience() async {
    final updatedExperience = await Navigator.of(context).push<ExperienceData>(
      MaterialPageRoute(
        builder: (_) => EditExperiencePage(experience: _experience),
      ),
    );

    if (updatedExperience == null) {
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _experience = updatedExperience;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pengalaman berhasil diperbarui')),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Pengaturan'),
        content: const Text('Fitur pengaturan belum tersedia.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF4FF),
      appBar: AppBar(
        title: const Text('Profil Saya'),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2E6FE7), Color(0xFF69A7FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Kelola profil dan pengaturan',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const ListTile(leading: Icon(Icons.home), title: Text('Beranda')),
            const ListTile(leading: Icon(Icons.person), title: Text('Profil')),
            ListTile(
              leading: const Icon(Icons.work_outline),
              title: const Text('Edit Pengalaman'),
              onTap: () {
                Navigator.pop(context);
                _openEditExperience();
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              onTap: () {
                Navigator.pop(context);
                _showSettingsDialog(context);
              },
            ),
            const ListTile(leading: Icon(Icons.info), title: Text('Tentang')),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEAF4FF), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _ProfileHeader(profile: _profile),
              const SizedBox(height: 16),
              _EditProfileCard(onTap: _openEditProfile),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _StatBox(label: 'Post', value: _profile.postCount),
                  ),
                  Expanded(
                    child: _StatBox(
                      label: 'Teman',
                      value: _profile.friendCount,
                    ),
                  ),
                  Expanded(
                    child: _StatBox(label: 'Like', value: _profile.likeCount),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _SectionCard(
                icon: Icons.info_outline,
                title: 'Tentang Saya',
                content: _profile.about,
              ),
              _SectionCard(
                icon: Icons.school,
                title: 'Pendidikan',
                content: _profile.education,
              ),
              _SectionCard(
                icon: Icons.location_on,
                title: 'Lokasi',
                content: _profile.location ?? 'Lokasi belum diisi',
              ),
              _SectionCard(
                icon: Icons.favorite,
                title: 'Hobi & Minat',
                content: _profile.hobbies,
              ),
              _SectionCard(
                icon: Icons.email,
                title: 'Kontak',
                content: '${_profile.email}\n${_profile.phone}',
              ),
              _SkillsCard(skills: _profile.skills),
              _ExperienceCard(experience: _experience),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openEditProfile,
        icon: const Icon(Icons.edit),
        label: const Text('Edit Profile'),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 1,
        onDestinationSelected: (i) {},
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
          NavigationDestination(icon: Icon(Icons.message), label: 'Pesan'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Setting'),
        ],
      ),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.profile});

  final ProfileData profile;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _headlineController;
  late final TextEditingController _aboutController;
  late final TextEditingController _educationController;
  late final TextEditingController _locationController;
  late final TextEditingController _hobbiesController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  Uint8List? _selectedAvatarBytes;
  late final TextEditingController _skillsController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _headlineController = TextEditingController(text: widget.profile.headline);
    _aboutController = TextEditingController(text: widget.profile.about);
    _educationController = TextEditingController(
      text: widget.profile.education,
    );
    _locationController = TextEditingController(
      text: widget.profile.location ?? '',
    );
    _hobbiesController = TextEditingController(text: widget.profile.hobbies);
    _emailController = TextEditingController(text: widget.profile.email);
    _phoneController = TextEditingController(text: widget.profile.phone);
    _selectedAvatarBytes = widget.profile.avatarBytes;
    _skillsController = TextEditingController(
      text: widget.profile.skills.join(', '),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _headlineController.dispose();
    _aboutController.dispose();
    _educationController.dispose();
    _locationController.dispose();
    _hobbiesController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _skillsController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatarImage() async {
    final pickedBytes = await pickImageBytes();
    if (!mounted || pickedBytes == null) {
      return;
    }

    setState(() {
      _selectedAvatarBytes = pickedBytes;
    });
  }

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final skills = _skillsController.text
        .split(',')
        .map((skill) => skill.trim())
        .where((skill) => skill.isNotEmpty)
        .toList();

    Navigator.of(context).pop(
      widget.profile.copyWith(
        name: _nameController.text.trim(),
        headline: _headlineController.text.trim(),
        about: _aboutController.text.trim(),
        education: _educationController.text.trim(),
        location: _locationController.text.trim(),
        hobbies: _hobbiesController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        avatarBytes: _selectedAvatarBytes,
        skills: skills.isEmpty ? widget.profile.skills : skills,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F8FF),
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF3F8FF), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                elevation: 0,
                color: const Color(0xFFE6F0FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 44,
                        backgroundColor: const Color(0xFFD6E7FF),
                        backgroundImage: _selectedAvatarBytes == null
                            ? null
                            : MemoryImage(_selectedAvatarBytes!),
                        child: _selectedAvatarBytes == null
                            ? const Icon(
                                Icons.person,
                                size: 42,
                                color: Color(0xFF2E6FE7),
                              )
                            : null,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.profile.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Perbarui identitas dan informasi profil dari sini.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton.icon(
                        onPressed: _pickAvatarImage,
                        icon: const Icon(Icons.photo_library_outlined),
                        label: const Text('Pilih Foto Profil'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _InputField(
                controller: _nameController,
                label: 'Nama Lengkap',
                icon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              _InputField(
                controller: _headlineController,
                label: 'Headline',
                icon: Icons.badge_outlined,
              ),
              _InputField(
                controller: _aboutController,
                label: 'Tentang Saya',
                icon: Icons.info_outline,
                maxLines: 4,
              ),
              _InputField(
                controller: _educationController,
                label: 'Pendidikan',
                icon: Icons.school_outlined,
              ),
              _InputField(
                controller: _locationController,
                label: 'Lokasi',
                icon: Icons.location_on_outlined,
              ),
              _InputField(
                controller: _hobbiesController,
                label: 'Hobi & Minat',
                icon: Icons.favorite_outline,
              ),
              _InputField(
                controller: _emailController,
                label: 'Email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  if (!value.contains('@')) {
                    return 'Email tidak valid';
                  }
                  return null;
                },
              ),
              _InputField(
                controller: _phoneController,
                label: 'Nomor Telepon',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              _InputField(
                controller: _skillsController,
                label: 'Skills',
                icon: Icons.star_outline,
                hintText: 'Pisahkan dengan koma, contoh: Flutter, Firebase',
                maxLines: 2,
              ),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: _saveProfile,
                icon: const Icon(Icons.save_outlined),
                label: const Text('Simpan Perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditExperiencePage extends StatefulWidget {
  const EditExperiencePage({super.key, required this.experience});

  final ExperienceData experience;

  @override
  State<EditExperiencePage> createState() => _EditExperiencePageState();
}

class _EditExperiencePageState extends State<EditExperiencePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  Uint8List? _selectedImageBytes;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.experience.title);
    _descriptionController = TextEditingController(
      text: widget.experience.description,
    );
    _selectedImageBytes = widget.experience.imageBytes;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedBytes = await pickImageBytes();
    if (!mounted || pickedBytes == null) {
      return;
    }

    setState(() {
      _selectedImageBytes = pickedBytes;
    });
  }

  void _saveExperience() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.of(context).pop(
      widget.experience.copyWith(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        imageBytes: _selectedImageBytes,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F8FF),
      appBar: AppBar(title: const Text('Edit Pengalaman')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              elevation: 0,
              color: const Color(0xFFE6F0FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: _selectedImageBytes == null
                          ? Container(
                              height: 180,
                              color: const Color(0xFFD6E7FF),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.image_outlined,
                                size: 54,
                                color: Color(0xFF2E6FE7),
                              ),
                            )
                          : Image.memory(
                              _selectedImageBytes!,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.experience.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Ubah gambar, judul, dan deskripsi pengalaman di sini.',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.photo_library_outlined),
                      label: const Text('Pilih Gambar'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _InputField(
              controller: _titleController,
              label: 'Judul Pengalaman',
              icon: Icons.work_outline,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Judul tidak boleh kosong';
                }
                return null;
              },
            ),
            _InputField(
              controller: _descriptionController,
              label: 'Deskripsi Singkat',
              icon: Icons.description_outlined,
              maxLines: 4,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Deskripsi tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: _saveExperience,
              icon: const Icon(Icons.save_outlined),
              label: const Text('Simpan Pengalaman'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.profile});

  final ProfileData profile;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            colors: [Color(0xFF1F5ED8), Color(0xFF69A7FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 52,
              backgroundColor: Colors.white.withValues(alpha: 0.18),
              backgroundImage: profile.avatarBytes == null
                  ? null
                  : MemoryImage(profile.avatarBytes!),
              child: profile.avatarBytes == null
                  ? const Icon(Icons.person, color: Colors.white, size: 48)
                  : null,
            ),
            const SizedBox(height: 14),
            Text(
              profile.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              profile.headline,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditProfileCard extends StatelessWidget {
  const _EditProfileCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F0FF),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.edit_square, color: Color(0xFF2E6FE7)),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Tap untuk mengubah nama, bio, kontak, dan skills.',
                      style: TextStyle(height: 1.35),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey.shade600)),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.title,
    required this.content,
  });

  final IconData icon;
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF2E6FE7), size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(content, style: const TextStyle(height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkillsCard extends StatelessWidget {
  const _SkillsCard({required this.skills});

  final List<String> skills;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.star, color: Color(0xFF2E6FE7), size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Skills',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: skills
                        .map((skill) => Chip(label: Text(skill)))
                        .toList(growable: false),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExperienceCard extends StatelessWidget {
  const _ExperienceCard({required this.experience});

  final ExperienceData experience;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.work_outline, color: Color(0xFF2E6FE7), size: 28),
                SizedBox(width: 10),
                Text(
                  'Pengalaman',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: experience.imageBytes == null
                  ? Container(
                      height: 180,
                      color: const Color(0xFFE6F0FF),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.image_outlined,
                        size: 48,
                        color: Color(0xFF2E6FE7),
                      ),
                    )
                  : Image.memory(
                      experience.imageBytes!,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(height: 12),
            Text(
              experience.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(experience.description, style: const TextStyle(height: 1.4)),
          ],
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.maxLines = 1,
    this.hintText,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final int maxLines;
  final String? hintText;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
    );
  }
}
