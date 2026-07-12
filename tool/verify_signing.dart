// Run via `melos run build:dev`/`build:staging`/`build:prod` (each is
// `fvm dart run tool/verify_signing.dart <platform> && fvm flutter build ...`).
// Pure Dart + dart:io only, same reasoning as tool/verify_fvm.dart (this
// repo also targets Windows, ADR-006). Exit codes: 0 = a real release
// signing config exists for the requested platform; 1 = anything else.
//
// Deliberately does NOT touch `flutter run --release` — that path still
// falls back to Android's debug signing config exactly as before (quick
// local testing convenience, apps/mobile/android/app/build.gradle.kts).
// This script only gates `melos run build:*`, the commands that actually
// produce a distributable artifact — see RELEASE.md "Android signing" /
// "iOS signing" for why the two platforms are checked differently.
import 'dart:io';

Future<void> main(List<String> args) async {
  if (args.isEmpty || !['android', 'ios'].contains(args.first)) {
    stderr.writeln('Usage: dart run tool/verify_signing.dart <android|ios>');
    exit(1);
  }

  final repoRoot = File.fromUri(Platform.script).parent.parent;
  final platform = args.first;

  if (platform == 'android') {
    final keyProperties = File(
      '${repoRoot.path}${Platform.pathSeparator}apps${Platform.pathSeparator}'
      'mobile${Platform.pathSeparator}android${Platform.pathSeparator}'
      'key.properties',
    );

    if (!keyProperties.existsSync()) {
      stderr.writeln('''
TODO: belum ada signing config Android yang nyata.

  apps/mobile/android/key.properties tidak ditemukan — build.gradle.kts
  akan diam-diam jatuh balik ke debug signing key kalau build ini
  dipaksa lanjut, dan .aab/.apk hasilnya TIDAK BISA diupload ke Play
  Store (dan tidak seharusnya didistribusikan ke siapa pun).

  Langkah untuk memperbaiki (detail lengkap: RELEASE.md "Android signing"):
    1. Generate keystore sungguhan:
       keytool -genkey -v -keystore <path-di-luar-repo-ini>/upload-keystore.jks \\
         -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
    2. Copy apps/mobile/android/key.properties.example ->
       apps/mobile/android/key.properties, isi dengan path keystore +
       password + alias yang baru dibuat.
    3. Jalankan lagi: melos run build:dev / build:staging / build:prod.

  Build DIHENTIKAN di sini dengan sengaja -- bukan gagal senyap, dan
  bukan berhasil dengan APK yang salah ditandatangani tanpa peringatan.
''');
      exit(1);
    }

    stdout.writeln(
      'Signing OK — apps/mobile/android/key.properties ditemukan, '
      'build.gradle.kts akan pakai signing config release yang nyata.',
    );
    exit(0);
  }

  // iOS: code signing is enforced by Xcode itself at archive/export time
  // (a missing Team ID / provisioning profile is already a hard, loud
  // build failure — there is no Android-style "quietly falls back to a
  // throwaway key" trap to guard against here). This script still checks
  // for the ExportOptions.plist a real `flutter build ipa` needs, since
  // that one genuinely is a silent-until-much-later gap otherwise: without
  // it, `flutter build ipa` produces an .xcarchive but skips IPA export
  // with an easy-to-miss warning rather than a hard failure.
  final exportOptions = File(
    '${repoRoot.path}${Platform.pathSeparator}apps${Platform.pathSeparator}'
    'mobile${Platform.pathSeparator}ios${Platform.pathSeparator}'
    'ExportOptions.plist',
  );

  if (!exportOptions.existsSync()) {
    stderr.writeln('''
TODO: belum ada apps/mobile/ios/ExportOptions.plist.

  Tanpa file ini, "flutter build ipa" membuat .xcarchive tapi TIDAK
  mengekspor .ipa yang sebenarnya -- Flutter hanya mencetak warning, tidak
  gagal keras, jadi ini bisa lolos tanpa disadari.

  Langkah untuk memperbaiki (detail lengkap: RELEASE.md "iOS signing"):
    1. Buka apps/mobile/ios/Runner.xcworkspace di Xcode, konfigurasikan
       Team ID + provisioning profile untuk tiap flavor scheme
       (dev/staging/prod) di bawah Signing & Capabilities.
    2. Export ExportOptions.plist dari Xcode (Product > Archive > Distribute
       App), atau tulis manual mengikuti template Apple.
    3. Jalankan lagi: fvm flutter build ipa --flavor <dev|staging|prod>
       -t lib/main_<flavor>.dart (belum ada melos script untuk ini --
       lihat RELEASE.md "iOS signing" kenapa).

  CATATAN: script ini belum pernah diverifikasi jalan sungguhan di macOS/
  Xcode -- environment audit ini adalah Windows, tanpa toolchain iOS sama
  sekali. Logikanya (cek keberadaan file) sengaja dibuat sederhana supaya
  rendah risiko, tapi belum ada bukti langsung "flutter build ipa" benar2
  berperilaku seperti dijelaskan di atas pada mesin ini.
''');
    exit(1);
  }

  stdout.writeln('Signing OK — apps/mobile/ios/ExportOptions.plist ditemukan.');
  exit(0);
}
