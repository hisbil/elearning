-- phpMyAdmin SQL Dump
-- version 4.6.5.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: 09 Agu 2017 pada 14.27
-- Versi Server: 10.1.21-MariaDB
-- PHP Version: 7.1.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `elearning_db`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `field_tambahan`
--

CREATE TABLE `field_tambahan` (
  `id` varchar(255) NOT NULL,
  `nama` varchar(255) DEFAULT NULL,
  `value` longtext
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data untuk tabel `field_tambahan`
--

INSERT INTO `field_tambahan` (`id`, `nama`, `value`) VALUES
('history-mengerjakan-1-1', 'History pengerjaan tugas', '{\"mulai\":\"2017-08-09 18:58:40\",\"selesai\":\"2017-08-09 20:28:40\",\"uri_string\":\"tugas\\/kerjakan\\/1\",\"valid_route\":[\"\\/tugas\\/kerjakan\",\"\\/tugas\\/finish\",\"\\/tugas\\/submit_essay\",\"\\/tugas\\/submit_upload\"],\"tugas\":{\"id\":\"1\",\"mapel_id\":\"4\",\"pengajar_id\":\"1\",\"type_id\":\"3\",\"judul\":\"Jaringan Komputer\",\"durasi\":\"90\",\"info\":\"<p>Hitamkan balkajslkdfjalskjdflksd<\\/p>\",\"aktif\":\"1\",\"tgl_buat\":\"2017-08-09 18:54:37\",\"tampil_siswa\":\"1\"},\"unix_id\":\"c10736a3d032fd4246b2ae1431de267e699562\",\"ip\":\"::1\",\"agent_string\":\"Mozilla\\/5.0 (Windows NT 10.0; WOW64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/59.0.3071.115 Safari\\/537.36\",\"pertanyaan_id\":[\"1\"],\"jawaban\":{\"1\":\"2\"},\"nilai\":0,\"jml_benar\":0,\"jml_salah\":1,\"tgl_submit\":\"2017-08-09 18:59:01\",\"total_waktu\":\"21 detik\"}');

-- --------------------------------------------------------

--
-- Struktur dari tabel `kelas`
--

CREATE TABLE `kelas` (
  `id` int(11) NOT NULL,
  `nama` varchar(45) NOT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `urutan` int(11) NOT NULL,
  `aktif` tinyint(4) NOT NULL DEFAULT '1' COMMENT '1=aktif 0=tidak'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data untuk tabel `kelas`
--

INSERT INTO `kelas` (`id`, `nama`, `parent_id`, `urutan`, `aktif`) VALUES
(1, 'KELAS X', NULL, 1, 1),
(2, 'KELAS X - A', 1, 2, 0),
(3, 'KELAS X - B', 1, 3, 0),
(4, 'KELAS X - C', 1, 4, 0),
(5, 'KELAS X - D', 1, 5, 0),
(6, 'KELAS XI', NULL, 6, 1),
(7, 'KELAS XI - A', 6, 7, 0),
(8, 'KELAS XI - B', 6, 8, 0),
(9, 'KELAS XI - C', 6, 9, 1),
(10, 'KELAS XI - D', 6, 10, 1),
(11, 'KELAS XII', NULL, 11, 1),
(12, 'RUANG - A', 11, 12, 1),
(13, 'KELAS XII - B', 11, 13, 1),
(14, 'KELAS XII - C', 11, 14, 1),
(15, 'KELAS XII - D', 11, 15, 1);

-- --------------------------------------------------------

--
-- Struktur dari tabel `kelas_siswa`
--

CREATE TABLE `kelas_siswa` (
  `id` int(11) NOT NULL,
  `kelas_id` int(11) NOT NULL,
  `siswa_id` int(11) NOT NULL,
  `aktif` tinyint(4) NOT NULL COMMENT '0 jika bukan, 1 jika ya'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data untuk tabel `kelas_siswa`
--

INSERT INTO `kelas_siswa` (`id`, `kelas_id`, `siswa_id`, `aktif`) VALUES
(1, 12, 1, 1);

-- --------------------------------------------------------

--
-- Struktur dari tabel `komentar`
--

CREATE TABLE `komentar` (
  `id` int(11) NOT NULL,
  `login_id` int(11) NOT NULL,
  `materi_id` int(11) NOT NULL,
  `tampil` tinyint(1) NOT NULL DEFAULT '1' COMMENT '0=tidak,1=tampil',
  `konten` text,
  `tgl_posting` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struktur dari tabel `login`
--

CREATE TABLE `login` (
  `id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `siswa_id` int(11) DEFAULT NULL,
  `pengajar_id` int(11) DEFAULT NULL,
  `is_admin` int(11) NOT NULL COMMENT '0=tidak,1=ya',
  `reset_kode` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data untuk tabel `login`
--

INSERT INTO `login` (`id`, `username`, `password`, `siswa_id`, `pengajar_id`, `is_admin`, `reset_kode`) VALUES
(1, 'irwan@gmail.com', '202cb962ac59075b964b07152d234b70', NULL, 1, 1, NULL),
(2, 'jhoni@gmail.com', '202cb962ac59075b964b07152d234b70', 1, NULL, 0, NULL);

-- --------------------------------------------------------

--
-- Struktur dari tabel `mapel`
--

CREATE TABLE `mapel` (
  `id` int(11) NOT NULL,
  `nama` varchar(255) NOT NULL,
  `info` text,
  `aktif` tinyint(4) NOT NULL DEFAULT '1' COMMENT '1 = ya, 0 = tidak'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data untuk tabel `mapel`
--

INSERT INTO `mapel` (`id`, `nama`, `info`, `aktif`) VALUES
(1, 'Bahasa Indonesia', NULL, 1),
(2, 'Bahasa Inggris', NULL, 1),
(3, 'Matematika', NULL, 1),
(4, 'Teori Kejuruan', '', 1);

-- --------------------------------------------------------

--
-- Struktur dari tabel `mapel_ajar`
--

CREATE TABLE `mapel_ajar` (
  `id` int(11) NOT NULL,
  `hari_id` tinyint(4) NOT NULL COMMENT '1=senin,2=selasa,3=rabu,4=kamis,5=jum''at,6=sabtu,7=minggu',
  `jam_mulai` time NOT NULL,
  `jam_selesai` time NOT NULL,
  `pengajar_id` int(11) NOT NULL,
  `mapel_kelas_id` int(11) NOT NULL,
  `aktif` tinyint(4) NOT NULL DEFAULT '1' COMMENT '1 = aktif 0 = tidak'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struktur dari tabel `mapel_kelas`
--

CREATE TABLE `mapel_kelas` (
  `id` int(11) NOT NULL,
  `kelas_id` int(11) NOT NULL,
  `mapel_id` int(11) NOT NULL,
  `aktif` tinyint(4) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data untuk tabel `mapel_kelas`
--

INSERT INTO `mapel_kelas` (`id`, `kelas_id`, `mapel_id`, `aktif`) VALUES
(1, 12, 1, 1),
(2, 12, 2, 1),
(3, 12, 3, 1),
(4, 12, 4, 1);

-- --------------------------------------------------------

--
-- Struktur dari tabel `materi`
--

CREATE TABLE `materi` (
  `id` int(11) NOT NULL,
  `mapel_id` int(11) NOT NULL,
  `pengajar_id` int(11) DEFAULT NULL,
  `siswa_id` int(11) DEFAULT NULL,
  `judul` varchar(255) NOT NULL,
  `konten` text,
  `file` text,
  `tgl_posting` datetime NOT NULL,
  `publish` tinyint(4) NOT NULL DEFAULT '0',
  `views` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struktur dari tabel `materi_kelas`
--

CREATE TABLE `materi_kelas` (
  `id` int(11) NOT NULL,
  `materi_id` int(11) NOT NULL,
  `kelas_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struktur dari tabel `messages`
--

CREATE TABLE `messages` (
  `id` int(11) NOT NULL,
  `type_id` tinyint(1) NOT NULL COMMENT '1=inbox,2=outbox',
  `content` text NOT NULL,
  `owner_id` int(11) NOT NULL,
  `sender_receiver_id` int(11) NOT NULL,
  `date` datetime NOT NULL,
  `opened` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0=belum,1=sudah'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struktur dari tabel `nilai_tugas`
--

CREATE TABLE `nilai_tugas` (
  `id` int(11) NOT NULL,
  `nilai` float NOT NULL,
  `tugas_id` int(11) NOT NULL,
  `siswa_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data untuk tabel `nilai_tugas`
--

INSERT INTO `nilai_tugas` (`id`, `nilai`, `tugas_id`, `siswa_id`) VALUES
(1, 0, 1, 1);

-- --------------------------------------------------------

--
-- Struktur dari tabel `pengajar`
--

CREATE TABLE `pengajar` (
  `id` int(11) NOT NULL,
  `nip` varchar(45) DEFAULT NULL,
  `nama` varchar(100) NOT NULL,
  `jenis_kelamin` varchar(9) NOT NULL,
  `tempat_lahir` varchar(45) NOT NULL,
  `tgl_lahir` date DEFAULT NULL,
  `alamat` varchar(255) NOT NULL,
  `foto` text,
  `status_id` tinyint(4) NOT NULL COMMENT '0=pending, 1=aktif, 2=blok'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data untuk tabel `pengajar`
--

INSERT INTO `pengajar` (`id`, `nip`, `nama`, `jenis_kelamin`, `tempat_lahir`, `tgl_lahir`, `alamat`, `foto`, `status_id`) VALUES
(1, '11012379', 'Moh. Irwanto', 'Laki-laki', 'Bondowoso', '2017-01-01', 'Wringin - Bondowoso', NULL, 1);

-- --------------------------------------------------------

--
-- Struktur dari tabel `pengaturan`
--

CREATE TABLE `pengaturan` (
  `id` varchar(255) NOT NULL,
  `nama` varchar(255) DEFAULT NULL,
  `value` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data untuk tabel `pengaturan`
--

INSERT INTO `pengaturan` (`id`, `nama`, `value`) VALUES
('alamat', 'alamat', 'Sidopekso - Kraksaan - Probolinggo'),
('email-server', 'Email server', 'no-reply@domain.com'),
('email-template-approve-pengajar', 'Approve pengajar (email pengajar)', '{\"subject\":\"Pengaktifan Akun\",\"body\":\"<p>Hai {$nama},<\\/p>\\n<p>Anda telah diterima sebagai pengajar pada {$nama_sekolah}, berikut informasi data diri anda:<\\/p>\\n<p>{$tabel_profil}<\\/p>\\n<p>Anda dapat login ke sistem E-Learning menggunakan username dan password yang telah anda buat saat pendaftaran, login pada url berikut : {$url_login}<\\/p>\"}'),
('email-template-approve-siswa', 'Approve siswa (email siswa)', '{\"subject\":\"Pengaktifan Akun\",\"body\":\"<p>Hai {$nama},<\\/p>\\n<p>Anda telah diterima sebagai siswa pada {$nama_sekolah}, berikut informasi data diri anda:<\\/p>\\n<p>{$tabel_profil}<\\/p>\\n<p>Anda dapat login ke sistem E-Learning menggunakan username dan password yang telah anda buat saat pendaftaran, login pada url berikut : {$url_login}<\\/p>\"}'),
('email-template-link-reset', 'Link Reset Password', '{\"subject\":\"Reset Password\",\"body\":\"<p>Hai,<\\/p>\\n<p>Anda mengirimkan permintaan untuk reset password anda, klik link berikut untuk memulai reset password : {$link_reset}<\\/p>\"}'),
('email-template-register-pengajar', 'Register pengajar (email pengajar)', '{\"subject\":\"Registrasi Berhasil\",\"body\":\"<p>Hai {$nama},<\\/p>\\n<p>Terimakasih telah melakukan pendaftaran sebagai pengajar di E-Learning {$nama_sekolah}. Akun anda akan segera diaktifkan oleh admin.<\\/p>\"}'),
('email-template-register-siswa', 'Register siswa (email siswa)', '{\"subject\":\"Registrasi Berhasil\",\"body\":\"<p>Hai {$nama},<\\/p>\\n<p>Terimakasih telah melakukan pendaftaran sebagai siswa di E-Learning {$nama_sekolah}. Akun anda akan segera diaktifkan oleh admin.<\\/p>\"}'),
('info-registrasi', 'Info Registrasi', '<p>Silahkan mendaftar sebagai siswa atau pengajar (jika anda sebagai pengajar) dengan memilih sesuai tab berikut :</p>'),
('install-success', 'install-success', '1'),
('jenjang', 'jenjang', 'SMA'),
('nama-sekolah', 'nama-sekolah', 'SMK ISLAM Syech Badri Masduki'),
('peraturan-elearning', 'Peraturan E-learning', ''),
('registrasi-pengajar', 'Registrasi Pengajar', '1'),
('registrasi-siswa', 'Registrasi Siswa', '1'),
('telp', 'telp', '085236530776'),
('versi', 'Versi', '1.0');

-- --------------------------------------------------------

--
-- Struktur dari tabel `pengumuman`
--

CREATE TABLE `pengumuman` (
  `id` int(11) NOT NULL,
  `judul` varchar(255) NOT NULL,
  `konten` text NOT NULL,
  `tgl_tampil` date NOT NULL,
  `tgl_tutup` date NOT NULL,
  `tampil_siswa` tinyint(1) NOT NULL DEFAULT '1',
  `tampil_pengajar` tinyint(1) NOT NULL DEFAULT '1',
  `pengajar_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struktur dari tabel `pilihan`
--

CREATE TABLE `pilihan` (
  `id` int(11) NOT NULL,
  `pertanyaan_id` int(11) NOT NULL,
  `konten` text NOT NULL,
  `kunci` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0=tidak',
  `urutan` int(11) NOT NULL,
  `aktif` tinyint(4) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data untuk tabel `pilihan`
--

INSERT INTO `pilihan` (`id`, `pertanyaan_id`, `konten`, `kunci`, `urutan`, `aktif`) VALUES
(1, 1, '<p>RG 45</p>', 1, 1, 1),
(2, 1, '<p>RG 11</p>', 0, 2, 1),
(3, 1, '<p>RG 15</p>', 0, 3, 1),
(4, 1, '<p>Benar semua</p>', 0, 4, 1),
(5, 1, '<p>Salah Semua</p>', 0, 5, 1);

-- --------------------------------------------------------

--
-- Struktur dari tabel `siswa`
--

CREATE TABLE `siswa` (
  `id` int(11) NOT NULL,
  `nis` varchar(45) DEFAULT NULL,
  `nama` varchar(100) NOT NULL,
  `jenis_kelamin` varchar(9) NOT NULL COMMENT 'Laki-laki dan Perempuan',
  `tempat_lahir` varchar(45) NOT NULL,
  `tgl_lahir` date DEFAULT NULL,
  `agama` char(7) DEFAULT NULL,
  `alamat` varchar(255) NOT NULL,
  `tahun_masuk` year(4) NOT NULL,
  `foto` text,
  `status_id` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0=pending, 1=aktif, 2=blok, 3=alumni, 4=deleted'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data untuk tabel `siswa`
--

INSERT INTO `siswa` (`id`, `nis`, `nama`, `jenis_kelamin`, `tempat_lahir`, `tgl_lahir`, `agama`, `alamat`, `tahun_masuk`, `foto`, `status_id`) VALUES
(1, '10011886', 'jhoni', 'Laki-laki', 'Probolinggo', '2001-01-02', 'ISLAM', 'Probolinggo', 2015, NULL, 1);

-- --------------------------------------------------------

--
-- Struktur dari tabel `tugas`
--

CREATE TABLE `tugas` (
  `id` int(11) NOT NULL,
  `mapel_id` int(11) NOT NULL,
  `pengajar_id` int(11) NOT NULL,
  `type_id` tinyint(4) NOT NULL COMMENT '1=upload,2=essay,3=ganda',
  `judul` varchar(255) NOT NULL,
  `durasi` int(11) DEFAULT NULL COMMENT 'lama pengerjaan dalam menit',
  `info` text,
  `aktif` tinyint(4) NOT NULL DEFAULT '0',
  `tgl_buat` datetime DEFAULT NULL,
  `tampil_siswa` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0=tidak tampil di siswa, 1=tampil siswa'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data untuk tabel `tugas`
--

INSERT INTO `tugas` (`id`, `mapel_id`, `pengajar_id`, `type_id`, `judul`, `durasi`, `info`, `aktif`, `tgl_buat`, `tampil_siswa`) VALUES
(1, 4, 1, 3, 'Jaringan Komputer', 90, '<p>Hitamkan balkajslkdfjalskjdflksd</p>', 0, '2017-08-09 18:54:37', 1);

-- --------------------------------------------------------

--
-- Struktur dari tabel `tugas_kelas`
--

CREATE TABLE `tugas_kelas` (
  `id` int(11) NOT NULL,
  `tugas_id` int(11) NOT NULL,
  `kelas_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data untuk tabel `tugas_kelas`
--

INSERT INTO `tugas_kelas` (`id`, `tugas_id`, `kelas_id`) VALUES
(1, 1, 12),
(2, 1, 13),
(3, 1, 14),
(4, 1, 15);

-- --------------------------------------------------------

--
-- Struktur dari tabel `tugas_pertanyaan`
--

CREATE TABLE `tugas_pertanyaan` (
  `id` int(11) NOT NULL,
  `pertanyaan` text NOT NULL,
  `urutan` int(11) NOT NULL,
  `tugas_id` int(11) NOT NULL,
  `aktif` tinyint(4) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data untuk tabel `tugas_pertanyaan`
--

INSERT INTO `tugas_pertanyaan` (`id`, `pertanyaan`, `urutan`, `tugas_id`, `aktif`) VALUES
(1, '<p>Apa nama konektor jaringan LAN ?</p>', 1, 1, 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `field_tambahan`
--
ALTER TABLE `field_tambahan`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `kelas`
--
ALTER TABLE `kelas`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `kelas_siswa`
--
ALTER TABLE `kelas_siswa`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_kelas_siswa_kelas_idx` (`kelas_id`),
  ADD KEY `fk_kelas_siswa_siswa1_idx` (`siswa_id`);

--
-- Indexes for table `komentar`
--
ALTER TABLE `komentar`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_komentar_login1_idx` (`login_id`),
  ADD KEY `fk_komentar_materi1_idx` (`materi_id`);

--
-- Indexes for table `login`
--
ALTER TABLE `login`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_login_siswa1_idx` (`siswa_id`),
  ADD KEY `fk_login_pengajar1_idx` (`pengajar_id`);

--
-- Indexes for table `mapel`
--
ALTER TABLE `mapel`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `mapel_ajar`
--
ALTER TABLE `mapel_ajar`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_mapel_ajar_pengajar1_idx` (`pengajar_id`),
  ADD KEY `fk_mapel_ajar_mapel_kelas1_idx` (`mapel_kelas_id`);

--
-- Indexes for table `mapel_kelas`
--
ALTER TABLE `mapel_kelas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_mapel_kelas_kelas1_idx` (`kelas_id`),
  ADD KEY `fk_mapel_kelas_mapel1_idx` (`mapel_id`);

--
-- Indexes for table `materi`
--
ALTER TABLE `materi`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_materi_pengajar1_idx` (`pengajar_id`),
  ADD KEY `fk_materi_siswa1_idx` (`siswa_id`),
  ADD KEY `fk_materi_mapel1_idx` (`mapel_id`);

--
-- Indexes for table `materi_kelas`
--
ALTER TABLE `materi_kelas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_materi_kelas_materi1_idx` (`materi_id`),
  ADD KEY `fk_materi_kelas_kelas1_idx` (`kelas_id`);

--
-- Indexes for table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_messages_login1_idx` (`owner_id`),
  ADD KEY `fk_messages_login2_idx` (`sender_receiver_id`);

--
-- Indexes for table `nilai_tugas`
--
ALTER TABLE `nilai_tugas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `tugas_id` (`tugas_id`,`siswa_id`),
  ADD KEY `fk_nilai_tugas1_idx` (`tugas_id`),
  ADD KEY `fk_nilai_siswa1_idx` (`siswa_id`);

--
-- Indexes for table `pengajar`
--
ALTER TABLE `pengajar`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pengaturan`
--
ALTER TABLE `pengaturan`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pengumuman`
--
ALTER TABLE `pengumuman`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_pengumuman_pengajar1_idx` (`pengajar_id`);

--
-- Indexes for table `pilihan`
--
ALTER TABLE `pilihan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_pilihan_tugas_pertanyaan1_idx` (`pertanyaan_id`);

--
-- Indexes for table `siswa`
--
ALTER TABLE `siswa`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tugas`
--
ALTER TABLE `tugas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_tugas_mapel1_idx` (`mapel_id`),
  ADD KEY `fk_tugas_pengajar1_idx` (`pengajar_id`);

--
-- Indexes for table `tugas_kelas`
--
ALTER TABLE `tugas_kelas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_tugas_kelas_tugas1_idx` (`tugas_id`),
  ADD KEY `fk_tugas_kelas_kelas1_idx` (`kelas_id`);

--
-- Indexes for table `tugas_pertanyaan`
--
ALTER TABLE `tugas_pertanyaan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_tugas_essay_tugas1_idx` (`tugas_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `kelas`
--
ALTER TABLE `kelas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;
--
-- AUTO_INCREMENT for table `kelas_siswa`
--
ALTER TABLE `kelas_siswa`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `komentar`
--
ALTER TABLE `komentar`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `login`
--
ALTER TABLE `login`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `mapel`
--
ALTER TABLE `mapel`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `mapel_ajar`
--
ALTER TABLE `mapel_ajar`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `mapel_kelas`
--
ALTER TABLE `mapel_kelas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `materi`
--
ALTER TABLE `materi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `materi_kelas`
--
ALTER TABLE `materi_kelas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `messages`
--
ALTER TABLE `messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `nilai_tugas`
--
ALTER TABLE `nilai_tugas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `pengajar`
--
ALTER TABLE `pengajar`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `pengumuman`
--
ALTER TABLE `pengumuman`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `pilihan`
--
ALTER TABLE `pilihan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `siswa`
--
ALTER TABLE `siswa`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `tugas`
--
ALTER TABLE `tugas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `tugas_kelas`
--
ALTER TABLE `tugas_kelas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `tugas_pertanyaan`
--
ALTER TABLE `tugas_pertanyaan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `kelas_siswa`
--
ALTER TABLE `kelas_siswa`
  ADD CONSTRAINT `fk_kelas_siswa_kelas` FOREIGN KEY (`kelas_id`) REFERENCES `kelas` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_kelas_siswa_siswa1` FOREIGN KEY (`siswa_id`) REFERENCES `siswa` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Ketidakleluasaan untuk tabel `komentar`
--
ALTER TABLE `komentar`
  ADD CONSTRAINT `fk_komentar_login1` FOREIGN KEY (`login_id`) REFERENCES `login` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_komentar_materi1` FOREIGN KEY (`materi_id`) REFERENCES `materi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Ketidakleluasaan untuk tabel `login`
--
ALTER TABLE `login`
  ADD CONSTRAINT `fk_login_pengajar1` FOREIGN KEY (`pengajar_id`) REFERENCES `pengajar` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_login_siswa1` FOREIGN KEY (`siswa_id`) REFERENCES `siswa` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Ketidakleluasaan untuk tabel `mapel_ajar`
--
ALTER TABLE `mapel_ajar`
  ADD CONSTRAINT `fk_mapel_ajar_mapel_kelas1` FOREIGN KEY (`mapel_kelas_id`) REFERENCES `mapel_kelas` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_mapel_ajar_pengajar1` FOREIGN KEY (`pengajar_id`) REFERENCES `pengajar` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Ketidakleluasaan untuk tabel `mapel_kelas`
--
ALTER TABLE `mapel_kelas`
  ADD CONSTRAINT `fk_mapel_kelas_kelas1` FOREIGN KEY (`kelas_id`) REFERENCES `kelas` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_mapel_kelas_mapel1` FOREIGN KEY (`mapel_id`) REFERENCES `mapel` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Ketidakleluasaan untuk tabel `materi`
--
ALTER TABLE `materi`
  ADD CONSTRAINT `fk_materi_mapel1` FOREIGN KEY (`mapel_id`) REFERENCES `mapel` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_materi_pengajar1` FOREIGN KEY (`pengajar_id`) REFERENCES `pengajar` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_materi_siswa1` FOREIGN KEY (`siswa_id`) REFERENCES `siswa` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Ketidakleluasaan untuk tabel `materi_kelas`
--
ALTER TABLE `materi_kelas`
  ADD CONSTRAINT `fk_materi_kelas_kelas1` FOREIGN KEY (`kelas_id`) REFERENCES `kelas` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_materi_kelas_materi1` FOREIGN KEY (`materi_id`) REFERENCES `materi` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Ketidakleluasaan untuk tabel `messages`
--
ALTER TABLE `messages`
  ADD CONSTRAINT `fk_messages_login1` FOREIGN KEY (`owner_id`) REFERENCES `login` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_messages_login2` FOREIGN KEY (`sender_receiver_id`) REFERENCES `login` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Ketidakleluasaan untuk tabel `nilai_tugas`
--
ALTER TABLE `nilai_tugas`
  ADD CONSTRAINT `fk_nilai_siswa1` FOREIGN KEY (`siswa_id`) REFERENCES `siswa` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_nilai_tugas1` FOREIGN KEY (`tugas_id`) REFERENCES `tugas` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Ketidakleluasaan untuk tabel `pengumuman`
--
ALTER TABLE `pengumuman`
  ADD CONSTRAINT `fk_pengumuman_pengajar1` FOREIGN KEY (`pengajar_id`) REFERENCES `pengajar` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Ketidakleluasaan untuk tabel `pilihan`
--
ALTER TABLE `pilihan`
  ADD CONSTRAINT `fk_pilihan_tugas_pertanyaan1` FOREIGN KEY (`pertanyaan_id`) REFERENCES `tugas_pertanyaan` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Ketidakleluasaan untuk tabel `tugas`
--
ALTER TABLE `tugas`
  ADD CONSTRAINT `fk_tugas_mapel1` FOREIGN KEY (`mapel_id`) REFERENCES `mapel` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_tugas_pengajar1` FOREIGN KEY (`pengajar_id`) REFERENCES `pengajar` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Ketidakleluasaan untuk tabel `tugas_kelas`
--
ALTER TABLE `tugas_kelas`
  ADD CONSTRAINT `fk_tugas_kelas_kelas1` FOREIGN KEY (`kelas_id`) REFERENCES `kelas` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_tugas_kelas_tugas1` FOREIGN KEY (`tugas_id`) REFERENCES `tugas` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Ketidakleluasaan untuk tabel `tugas_pertanyaan`
--
ALTER TABLE `tugas_pertanyaan`
  ADD CONSTRAINT `fk_tugas_essay_tugas1` FOREIGN KEY (`tugas_id`) REFERENCES `tugas` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
