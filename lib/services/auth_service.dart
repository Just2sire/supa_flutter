import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  // Get a reference your Supabase client
  final supabase = Supabase.instance.client;

  // UTILISATEUR ACTUEL
  User? get currentUser => supabase.auth.currentUser;

  // INSCRIPTION — Email + Mot de passe
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return await supabase.auth.signUp(
      password: password,
      email: email,
      data: {'username': email.split('@').first},
    );
  }

  // CONNEXION — Email + Mot de passe
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await supabase.auth.signInWithPassword(
      password: password,
      email: email,
    );
    // Le JWT d'accès est stocké automatiquement et sécurisé en local
  }

  // DÉCONNEXION
  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  // CONNEXION — OAuth (Google)
  /*
  Future<void> signInWithGoogle() async {
    await supabase.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'io.supabase.myapp://login-callback/',
    );
  }
  */
}
