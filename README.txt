CorelNestPro Fix 4 - Installer-only safe registration patch

Tujuan:
- Tidak mengubah DLL Docker atau mesin nesting.
- Menghapus pemanggilan app.Visible = true.
- Tidak memanggil FrameWork.ShowDocker dari proses PowerShell eksternal.
- Melepas referensi COM setelah AddDocker.
- Menahan jendela CMD agar pesan tidak hilang.
- Menulis log ke %TEMP%\CorelNestPro_Install.log.

Pemasangan:
1. Tutup semua jendela CorelDRAW. Pastikan proses CorelDRAW sudah benar-benar keluar.
2. Buat backup Install-CorelNest.ps1 dan Install-CorelNest.bat dari paket hasil build sebelumnya.
3. Salin dua file dari paket ini ke folder yang sama dengan CorelNest.Dockers.dll dan folder Engine.
4. Buka CorelDRAW kembali.
5. Jalankan Install-CorelNest.bat.
6. Setelah pesan REGISTRASI BERHASIL, buka Window > Dockers > CorelNest Pro secara manual.
7. Uji apakah canvas, menu, toolbar, dan panel masih dapat diklik.

Jika masih terkunci:
- Tutup CorelDRAW sepenuhnya.
- Kirim %TEMP%\CorelNestPro_Install.log.
- Jangan jalankan installer lama yang memanggil ShowDocker.

Catatan: patch ini mengisolasi dugaan pemanggilan ShowDocker dari PowerShell eksternal. Ini belum membuktikan bahwa seluruh masalah modal telah terselesaikan; hasil uji host diperlukan.
