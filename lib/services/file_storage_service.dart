import 'dart:io';

import 'package:flutter/widgets.dart' show debugPrint;
import 'package:supabase_flutter/supabase_flutter.dart';

class FileStorageService {
//   Supabase Storage
// Supabase Storage permet de stocker des fichiers binaires volumineux (images, vidéos, documents) organisés dans des Buckets (Seaux). Les buckets peuvent être publics (URL accessible sans authentification) ou privés (accès contrôlé par RLS).

  final supabase = Supabase.instance.client;
// 1. Uploader un fichier


Future<String?> uploadAvatar(File imageFile, String userId) async {

  try {
    // Chemin du fichier dans le bucket (ex: userId/avatar.png)
    final String path = '$userId/avatar_${DateTime.now().millisecondsSinceEpoch}.png';

    // Upload dans le bucket 'avatars'
    await supabase.storage.from('avatars').upload(
      path,
      imageFile,
      fileOptions: const FileOptions(
        upsert: true,                 // Écrase si existe déjà
        contentType: 'image/png',
      ),
    );

    // Récupérer l'URL publique (si le bucket est public)
    final String publicUrl = supabase.storage.from('avatars').getPublicUrl(path);
    return publicUrl;

  } catch (e) {
    debugPrint ('Erreur Storage: $e');
    return null;
  }
}
  
/// 2. URL signée (pour buckets privés)

// Pour les buckets PRIVÉS : générer une URL signée (valable X secondes)
// final String signedUrl = await supabase.storage
//     .from('private-docs')
//     .createSignedUrl(
//       'confidential/report.pdf',
//       60 * 60, // Expiration : 1 heure (en secondes)
//     );
  
/// 3. Supprimer et lister des fichiers

// Supprimer un fichier
// await supabase.storage.from('avatars').remove(['$userId/avatar.png']);

// Lister les fichiers d'un "dossier"
// final List<FileObject> files = await supabase.storage
//     .from('avatars')
//     .list(path: userId); // Chemin du "dossier"
  
// 4. Transformations d'image

// Supabase peut redimensionner les images à la volée !
// final url = supabase.storage.from('avatars').getPublicUrl(
  //   '$userId/avatar.png',
  //   transform: const TransformOptions(
  //     width: 100,
  //     height: 100,
  //     resize: ResizeMode.cover,
  //   ),
  // );
  
}