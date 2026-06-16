import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

String _formatTanggal(DateTime tanggal) {
  const namaBulan = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  final hari = tanggal.day.toString().padLeft(2, '0');
  final bulan = namaBulan[tanggal.month - 1];
  final tahun = tanggal.year;
  final jam = tanggal.hour.toString().padLeft(2, '0');
  final menit = tanggal.minute.toString().padLeft(2, '0');

  return '$hari $bulan $tahun, $jam:$menit';
}

class Catatan {
  final String id;
  final String judul;
  final String isi;
  final String kategori;
  final String emailPengirim;
  final DateTime dibuatPada;

  const Catatan({
    required this.id,
    required this.judul,
    required this.isi,
    required this.kategori,
    required this.emailPengirim,
    required this.dibuatPada,
  });

  Catatan copyWith({
    String? judul,
    String? isi,
    String? kategori,
    String? emailPengirim,
  }) {
    return Catatan(
      id: id,
      judul: judul ?? this.judul,
      isi: isi ?? this.isi,
      kategori: kategori ?? this.kategori,
      emailPengirim: emailPengirim ?? this.emailPengirim,
      dibuatPada: dibuatPada,
    );
  }
}

class ProfilPengguna {
  final String nama;
  final String email;
  final String telepon;
  final String bio;

  const ProfilPengguna({
    required this.nama,
    required this.email,
    required this.telepon,
    required this.bio,
  });

  ProfilPengguna copyWith({
    String? nama,
    String? email,
    String? telepon,
    String? bio,
  }) {
    return ProfilPengguna(
      nama: nama ?? this.nama,
      email: email ?? this.email,
      telepon: telepon ?? this.telepon,
      bio: bio ?? this.bio,
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catatan Mahasiswa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ProfilPengguna _profil = const ProfilPengguna(
    nama: 'Mahasiswa Flutter',
    email: 'mahasiswa@kampus.ac.id',
    telepon: '0812-3456-7890',
    bio: 'Belajar membuat aplikasi Flutter yang rapi dan interaktif.',
  );

  final List<Catatan> _catatan = [
    Catatan(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      judul: 'Belajar Flutter',
      isi: 'Mempelajari Stateful Widget, Form, dan Navigation.',
      kategori: 'Kuliah',
      emailPengirim: 'dosen@if.univ.ac.id',
      dibuatPada: DateTime.now(),
    ),
  ];

  final List<String> _kategoriOpsi = const [
    'Semua',
    'Kuliah',
    'Tugas',
    'Pribadi',
    'Lainnya',
  ];

  String _filterKategori = 'Semua';

  List<Catatan> get _catatanTersaring {
    if (_filterKategori == 'Semua') {
      return _catatan;
    }

    return _catatan.where((c) => c.kategori == _filterKategori).toList();
  }

  Future<void> _bukaEditProfil() async {
    final hasil = await Navigator.push<ProfilPengguna>(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfilePage(profilAwal: _profil),
      ),
    );

    if (!mounted || hasil == null) return;

    setState(() => _profil = hasil);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profil "${hasil.nama}" diperbarui')),
    );
  }

  Future<void> _bukaFormCatatan({Catatan? catatan}) async {
    final hasil = await Navigator.push<Catatan>(
      context,
      MaterialPageRoute(
        builder: (_) => TambahCatatanPage(catatanAwal: catatan),
      ),
    );

    if (!mounted || hasil == null) return;

    final indexLama = _catatan.indexWhere((item) => item.id == hasil.id);

    setState(() {
      if (indexLama >= 0) {
        _catatan[indexLama] = hasil;
      } else {
        _catatan.add(hasil);
      }
    });

    final pesan = indexLama >= 0
        ? 'Catatan "${hasil.judul}" diperbarui'
        : 'Catatan "${hasil.judul}" ditambahkan';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(pesan)),
    );
  }

  Future<void> _bukaDetailCatatan(Catatan catatan) async {
    final hasil = await Navigator.push<Catatan>(
      context,
      MaterialPageRoute(
        builder: (_) => DetailCatatanPage(catatan: catatan),
      ),
    );

    if (!mounted || hasil == null) return;

    final indexLama = _catatan.indexWhere((item) => item.id == hasil.id);
    if (indexLama < 0) return;

    setState(() => _catatan[indexLama] = hasil);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Catatan "${hasil.judul}" diperbarui')),
    );
  }

  void _hapusCatatan(String id) {
    final index = _catatan.indexWhere((item) => item.id == id);
    if (index < 0) return;

    final catatan = _catatan[index];

    setState(() => _catatan.removeAt(index));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Catatan "${catatan.judul}" dihapus')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final daftarCatatan = _catatanTersaring;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Mahasiswa'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _filterKategori,
                borderRadius: BorderRadius.circular(16),
                icon: const Icon(Icons.arrow_drop_down),
                selectedItemBuilder: (context) {
                  return _kategoriOpsi.map((kategori) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.filter_list, size: 18),
                        const SizedBox(width: 6),
                        Text(kategori),
                      ],
                    );
                  }).toList();
                },
                items: _kategoriOpsi.map((kategori) {
                  return DropdownMenuItem(
                    value: kategori,
                    child: Text(kategori),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _filterKategori = value);
                },
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: _ProfileCard(
              profil: _profil,
              onEdit: _bukaEditProfil,
            ),
          ),
          Expanded(
            child: daftarCatatan.isEmpty
                ? _EmptyState(
                    title: _catatan.isEmpty
                        ? 'Belum ada catatan'
                        : 'Tidak ada catatan kategori $_filterKategori',
                    subtitle: _catatan.isEmpty
                        ? 'Tambahkan catatan pertama untuk mulai menyimpan ide atau tugas kuliah.'
                        : 'Coba pilih kategori lain atau tambahkan catatan baru.',
                    onTambah: () => _bukaFormCatatan(),
                  )
                : ListView.separated(
                    itemCount: daftarCatatan.length,
                    separatorBuilder: (_, _) => const Divider(height: 0),
                    itemBuilder: (context, i) {
                      final c = daftarCatatan[i];
                      final avatarHuruf = c.judul.trim().isEmpty
                          ? '?'
                          : c.judul.trim()[0].toUpperCase();

                      return ListTile(
                        leading: CircleAvatar(child: Text(avatarHuruf)),
                        title: Text(c.judul),
                        subtitle: Text(
                          '${c.kategori} - ${_formatTanggal(c.dibuatPada)}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          tooltip: 'Hapus catatan',
                          onPressed: () => _hapusCatatan(c.id),
                        ),
                        onTap: () => _bukaDetailCatatan(c),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _bukaFormCatatan(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final ProfilPengguna profil;
  final VoidCallback onEdit;

  const _ProfileCard({
    required this.profil,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final inisial = profil.nama.trim().isEmpty
        ? '?'
        : profil.nama.trim()[0].toUpperCase();

    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.manage_accounts_outlined,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Edit Profil',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  child: Text(
                    inisial,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profil.nama,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 2),
                      Text(profil.email),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              profil.bio,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.phone_outlined, size: 18),
                const SizedBox(width: 8),
                Text(profil.telepon),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit Profil'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TambahCatatanPage extends StatefulWidget {
  final Catatan? catatanAwal;

  const TambahCatatanPage({super.key, this.catatanAwal});

  @override
  State<TambahCatatanPage> createState() => _TambahCatatanPageState();
}

class _TambahCatatanPageState extends State<TambahCatatanPage> {
  final _formKey = GlobalKey<FormState>();
  final _judulCtrl = TextEditingController();
  final _isiCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _regexEmail = RegExp(r'^[\w\.-]+@([\w-]+\.)+[A-Za-z]{2,}$');

  final _kategoriOpsi = const ['Kuliah', 'Tugas', 'Pribadi', 'Lainnya'];
  late String _kategori;

  bool get _isModeEdit => widget.catatanAwal != null;

  @override
  void initState() {
    super.initState();
    final catatanAwal = widget.catatanAwal;

    _judulCtrl.text = catatanAwal?.judul ?? '';
    _isiCtrl.text = catatanAwal?.isi ?? '';
    _emailCtrl.text = catatanAwal?.emailPengirim ?? '';
    _kategori = catatanAwal?.kategori ?? _kategoriOpsi.first;
  }

  @override
  void dispose() {
    _judulCtrl.dispose();
    _isiCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;

    final judul = _judulCtrl.text.trim();
    final isi = _isiCtrl.text.trim();
    final emailPengirim = _emailCtrl.text.trim();

    final catatan = widget.catatanAwal?.copyWith(
          judul: judul,
          isi: isi,
          kategori: _kategori,
          emailPengirim: emailPengirim,
        ) ??
        Catatan(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          judul: judul,
          isi: isi,
          kategori: _kategori,
          emailPengirim: emailPengirim,
          dibuatPada: DateTime.now(),
        );

    Navigator.pop(context, catatan);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isModeEdit ? 'Edit Catatan' : 'Tambah Catatan'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _judulCtrl,
              decoration: const InputDecoration(
                labelText: 'Judul',
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Judul wajib diisi';
                if (v.trim().length < 3) return 'Minimal 3 karakter';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email pengirim',
                prefixIcon: Icon(Icons.alternate_email),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Email pengirim wajib diisi';
                }

                if (!_regexEmail.hasMatch(value.trim())) {
                  return 'Format email belum valid';
                }

                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _kategori,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(),
              ),
              items: _kategoriOpsi
                  .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                  .toList(),
              onChanged: (v) {
                if (v == null) return;
                setState(() => _kategori = v);
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _isiCtrl,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Isi',
                prefixIcon: Icon(Icons.notes),
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Isi wajib diisi' : null,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _simpan,
              icon: const Icon(Icons.save),
              label: Text(_isModeEdit ? 'Update Catatan' : 'Simpan Catatan'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  final ProfilPengguna profilAwal;

  const EditProfilePage({super.key, required this.profilAwal});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _namaCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _teleponCtrl;
  late final TextEditingController _bioCtrl;
  final _regexEmail = RegExp(r'^[\w\.-]+@([\w-]+\.)+[A-Za-z]{2,}$');

  @override
  void initState() {
    super.initState();
    _namaCtrl = TextEditingController(text: widget.profilAwal.nama);
    _emailCtrl = TextEditingController(text: widget.profilAwal.email);
    _teleponCtrl = TextEditingController(text: widget.profilAwal.telepon);
    _bioCtrl = TextEditingController(text: widget.profilAwal.bio);
  }

  @override
  void dispose() {
    _namaCtrl.dispose();
    _emailCtrl.dispose();
    _teleponCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;

    final profilBaru = widget.profilAwal.copyWith(
      nama: _namaCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      telepon: _teleponCtrl.text.trim(),
      bio: _bioCtrl.text.trim(),
    );

    Navigator.pop(context, profilBaru);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profil')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      child: ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _namaCtrl,
                        builder: (context, value, _) {
                          final inisial = value.text.trim().isEmpty
                              ? '?'
                              : value.text.trim()[0].toUpperCase();
                          return Text(inisial);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Perbarui data profil untuk ditampilkan di halaman utama.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _namaCtrl,
              decoration: const InputDecoration(
                labelText: 'Nama',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama wajib diisi';
                }
                if (value.trim().length < 3) {
                  return 'Minimal 3 karakter';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.alternate_email),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Email wajib diisi';
                }
                if (!_regexEmail.hasMatch(value.trim())) {
                  return 'Format email belum valid';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _teleponCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Nomor telepon',
                prefixIcon: Icon(Icons.phone_outlined),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nomor telepon wajib diisi';
                }
                if (value.trim().length < 8) {
                  return 'Nomor telepon terlalu pendek';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _bioCtrl,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Bio',
                prefixIcon: Icon(Icons.notes_outlined),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Bio wajib diisi';
                }
                if (value.trim().length < 10) {
                  return 'Bio minimal 10 karakter';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _simpan,
              icon: const Icon(Icons.save_outlined),
              label: const Text('Simpan Profil'),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailCatatanPage extends StatelessWidget {
  final Catatan catatan;

  const DetailCatatanPage({super.key, required this.catatan});

  Future<void> _editCatatan(BuildContext context) async {
    final hasil = await Navigator.push<Catatan>(
      context,
      MaterialPageRoute(
        builder: (_) => TambahCatatanPage(catatanAwal: catatan),
      ),
    );

    if (!context.mounted || hasil == null) return;

    Navigator.pop(context, hasil);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Catatan')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              catatan.judul,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(label: Text(catatan.kategori)),
                Chip(
                  avatar: const Icon(Icons.schedule, size: 18),
                  label: Text(_formatTanggal(catatan.dibuatPada)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.alternate_email),
              title: const Text('Email pengirim'),
              subtitle: Text(catatan.emailPengirim),
            ),
            const Divider(height: 32),
            Text(
              catatan.isi,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => _editCatatan(context),
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Edit'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final Future<void> Function() onTambah;

  const _EmptyState({
    required this.title,
    required this.subtitle,
    required this.onTambah,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.sticky_note_2_outlined,
              size: 72,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onTambah,
              icon: const Icon(Icons.add),
              label: const Text('Tambah Catatan'),
            ),
          ],
        ),
      ),
    );
  }
}
