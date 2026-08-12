import 'package:supabase_flutter/supabase_flutter.dart';

class MessageService {
  // Get a reference your Supabase client
  final supabase = Supabase.instance.client;

  // CREATE — Insérer une ligne
  Future<void> sendMessage(String message, [String roomId = 'general']) async {
    return await supabase.from('messages').insert({
      'content': message,
      'user_id': supabase.auth.currentUser!.id,
      'room_id': roomId,
    });
  }

  // CREATE — Upsert (insert ou update si existe)
  Future<void> updateProfile(String username) async {
    return await supabase.from('profiles').upsert({
      'id': supabase.auth.currentUser!.id,
      'username': username,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  // READ — Sélection avec filtres
  Future<List<Map<String, dynamic>>> getMessages() async {
    final List<Map<String, dynamic>> data = await supabase
        .from('messages')
        .select('id, content, created_at, profiles(username, avatar_url)')
        .eq('room_id', 'general') // WHERE room_id = 'general'
        .order('created_at', ascending: false)
        .limit(50);
    return data;
  }

  // READ — Filtres avancés
  Future<List<Map<String, dynamic>>> filterMessages(String query) async {
    final results = await supabase
        .from('products')
        .select()
        .gte('price', 10) // price >= 10
        .lte('price', 100) // price <= 100
        // .in_('category', ['electronics', 'books']) // IN (...)
        .ilike('name', '%$query%'); // ILIKE '%flutter%' (case-insensitive)
    return results;
  }

  Future<void> updateMessage({
    required String messageId,
    required String content,
  }) async {
    return await supabase
        .from('messages')
        .update({'content': content})
        .eq('id', messageId)
        .eq(
          'user_id',
          supabase.auth.currentUser!.id,
        ); // Sécurité : seul l'auteur peut modifier
  }

  Future<void> deleteMessage(String messageId) async {
    return await supabase.from('messages').delete().eq('id', messageId);
  }
}
