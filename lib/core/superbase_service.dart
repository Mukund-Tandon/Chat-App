import 'package:supabase/supabase.dart';

class SupabseCredentials {
  static const String URl = 'https://ogmsbwsgbdktddsmptgq.supabase.co';
  static const String ANON =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9nbXNid3NnYmRrdGRkc21wdGdxIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NTUxMTQwMjMsImV4cCI6MTk3MDY5MDAyM30.9n6W45NIL9l_kKni88hiGmvBQx6MC_JtOQ8FbiXN_P8';
  static SupabaseClient supabaseClient = SupabaseClient(URl, ANON);
}
