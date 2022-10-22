import 'package:supabase/supabase.dart';
import 'package:whatsapp_clone/core/secrets.dart';

class SupabseCredentials {
  static final String URl = URL;
  static final String ANON = KEY;
  static SupabaseClient supabaseClient = SupabaseClient(URl, ANON);
}
