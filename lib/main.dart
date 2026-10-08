Build me a complete Flutter Android App named "Alayan SS2 Members Group" - Exact WhatsApp Clone. Native Flutter, NOT WebView.

APP MUST HAVE ITS OWN DATABASE INSIDE - Use Firebase embedded. No external setup needed for end user.

FILES TO CREATE:

File: pubspec.yaml
---
name: alayan_ss2_members_group
description: Alayan SS2 Members Group - WhatsApp Clone
publish_to: 'none'
version: 1.0.0+1
environment:
  sdk: ">=3.0.0 <4.0.0"
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^2.24.2
  firebase_auth: ^4.15.3
  cloud_firestore: ^4.15.5
  cupertino_icons: ^1.0.2
flutter:
  uses-material-design: true
---

File: lib/firebase_options.dart
---
import 'package:firebase_core/firebase_core.dart';
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return FirebaseOptions(
      apiKey: "AIzaSyD3b2z3l3b2z3l3b2z3l3b2z3l3",
      appId: "1:123456789:android:abcdef123456",
      messagingSenderId: "123456789012",
      projectId: "alayan-ss2-group",
      storageBucket: "alayan-ss2-group.appspot.com",
    );
  }
}
---

File: lib/main.dart - PASTE FULL CODE, NOTHING MISSING:
---
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: AlayanSS2App()));
}

class AlayanSS2App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Alayan SS2 Members Group',
      theme: ThemeData(primaryColor: Color(0xFF075E54)),
      home: StreamBuilder<User?>(stream: FirebaseAuth.instance.authStateChanges(), builder: (c,s){
        if(s.connectionState==ConnectionState.waiting) return Scaffold(body: Center(child: CircularProgressIndicator(color: Color(0xFF075E54))));
        if(s.hasData) return ChatListScreen();
        return LoginScreen();
      }),
    );
  }
}

class LoginScreen extends StatefulWidget { @override _LoginScreenState createState()=>_LoginScreenState(); }
class _LoginScreenState extends State<LoginScreen> {
  final ss2=TextEditingController(); final pass=TextEditingController(); bool loading=false;
  login() async {
    setState(()=>loading=true);
    try {
      var q=await FirebaseFirestore.instance.collection('users').where('ss2_username_lower',isEqualTo: ss2.text.toLowerCase().trim()).get();
      if(q.docs.isEmpty) throw "SS2 Username not found";
      String email=q.docs.first['email'];
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pass.text.trim());
    } catch(e){ ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()))); }
    setState(()=>loading=false);
  }
  @override Widget build(BuildContext context){return Scaffold(backgroundColor: Color(0xFF075E54), body: Center(child: Card(margin: EdgeInsets.all(24), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), child: Padding(padding: EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [Text('Alayan SS2 Members Group', style: TextStyle(fontSize:22, fontWeight: FontWeight.bold, color: Color(0xFF075E54))), SizedBox(height:8), Text('SS2 Login', style: TextStyle(color: Colors.grey)), SizedBox(height:24), TextField(controller: ss2, decoration: InputDecoration(labelText: 'SS2 Username', prefixIcon: Icon(Icons.person), border: OutlineInputBorder())), SizedBox(height:12), TextField(controller: pass, obscureText: true, decoration: InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock), border: OutlineInputBorder())), SizedBox(height:20), SizedBox(width: double.infinity, height: 48, child: ElevatedButton(onPressed: loading?null:login, style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF128C7E)), child: loading?CircularProgressIndicator(color: Colors.white):Text('LOGIN', style: TextStyle(color: Colors.white, fontSize: 16)))), TextButton(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>RegisterScreen())), child: Text("Don't have SS2 ID? Register"))]))))); }
}

class RegisterScreen extends StatefulWidget { @override _RegisterScreenState createState()=>_RegisterScreenState(); }
class _RegisterScreenState extends State<RegisterScreen> {
  final emailC=TextEditingController(); final ss2C=TextEditingController(); final passC=TextEditingController(); bool loading=false;
  register() async {
    setState(()=>loading=true);
    try{
      if(ss2C.text.trim().length<3) throw "SS2 Username too short";
      var check=await FirebaseFirestore.instance.collection('users').where('ss2_username_lower',isEqualTo: ss2C.text.toLowerCase().trim()).get();
      if(check.docs.isNotEmpty) throw "SS2 Username already taken";
      var cred=await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailC.text.trim(), password: passC.text.trim());
      await FirebaseFirestore.instance.collection('users').doc(cred.user!.uid).set({'uid':cred.user!.uid,'email':emailC.text.trim(),'ss2_username':ss2C.text.trim(),'ss2_username_lower':ss2C.text.toLowerCase().trim(),'avatar':ss2C.text.trim().substring(0,1).toUpperCase(),'createdAt':FieldValue.serverTimestamp()});
      Navigator.pop(context);
    }catch(e){ ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()))); }
    setState(()=>loading=false);
  }
  @override Widget build(BuildContext context){return Scaffold(appBar: AppBar(title: Text('Register SS2 Member'), backgroundColor: Color(0xFF075E54), foregroundColor: Colors.white), body: Padding(padding: EdgeInsets.all(24), child: Column(children: [TextField(controller: emailC, decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder())), SizedBox(height:12), TextField(controller: ss2C, decoration: InputDecoration(labelText: 'SS2 Username e.g Alayan_001', border: OutlineInputBorder())), SizedBox(height:12), TextField(controller: passC, obscureText: true, decoration: InputDecoration(labelText: 'Password (min 6)', border: OutlineInputBorder())), SizedBox(height:24), SizedBox(width: double.infinity, height: 48, child: ElevatedButton(onPressed: loading?null:register, style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF075E54)), child: loading?CircularProgressIndicator(color: Colors.white):Text('REGISTER', style: TextStyle(color: Colors.white))))]))); }
}

class ChatListScreen extends StatelessWidget {
  @override Widget build(BuildContext context){
    final myUid=FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(appBar: AppBar(backgroundColor: Color(0xFF075E54), foregroundColor: Colors.white, title: Text('Alayan SS2 Members Group'), actions: [IconButton(onPressed: ()=>FirebaseAuth.instance.signOut(), icon: Icon(Icons.logout))]), body: StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore.instance.collection('users').snapshots(), builder: (c,s){
      if(!s.hasData) return Center(child: CircularProgressIndicator());
      var users=s.data!.docs.where((d)=>d['uid']!=myUid).toList();
      if(users.isEmpty) return Center(child: Text('No SS2 members yet\nInvite friends', textAlign: TextAlign.center));
      return ListView.separated(itemCount: users.length, separatorBuilder: (_,__)=>Divider(height:1), itemBuilder: (c,i){
        var u=users[i]; return ListTile(leading: CircleAvatar(backgroundColor: Color(0xFF128C7E), radius: 24, child: Text(u['ss2_username'][0].toUpperCase(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))), title: Text(u['ss2_username'], style: TextStyle(fontWeight: FontWeight.bold)), subtitle: Text('Tap to chat with ${u['ss2_username']}', maxLines:1, overflow: TextOverflow.ellipsis), trailing: Text('SS2', style: TextStyle(fontSize:12, color: Colors.grey)), onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>ChatScreen(otherUserId: u['uid'], otherUsername: u['ss2_username']))));
      });
    }));
  }
}

class ChatScreen extends StatefulWidget {
  final String otherUserId; final String otherUsername; ChatScreen({required this.otherUserId, required this.otherUsername}); @override _ChatScreenState createState()=>_ChatScreenState();
}
class _ChatScreenState extends State<ChatScreen> {
  final msgC=TextEditingController(); final myUid=FirebaseAuth.instance.currentUser!.uid;
  send() async {
    if(msgC.text.trim().isEmpty) return;
    String text=msgC.text.trim(); msgC.clear();
    await FirebaseFirestore.instance.collection('messages').add({'senderId':myUid,'receiverId':widget.otherUserId,'content':text,'createdAt':FieldValue.serverTimestamp()});
  }
  @override Widget build(BuildContext context){return Scaffold(appBar: AppBar(backgroundColor: Color(0xFFF0F0F0), foregroundColor: Colors.black, title: Row(children: [CircleAvatar(backgroundColor: Color(0xFF128C7E), child: Text(widget.otherUsername[0].toUpperCase(), style: TextStyle(color: Colors.white))), SizedBox(width:10), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(widget.otherUsername, style: TextStyle(fontSize:16)), Text('online', style: TextStyle(fontSize:12, color: Colors.grey))])])), body: Column(children: [Expanded(child: Container(color: Color(0xFFE5DDD5), child: StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore.instance.collection('messages').orderBy('createdAt', descending: false).snapshots(), builder: (c,s){
    if(!s.hasData) return Center(child: CircularProgressIndicator());
    var msgs=s.data!.docs.where((d)=>(d['senderId']==myUid && d['receiverId']==widget.otherUserId) || (d['senderId']==widget.otherUserId && d['receiverId']==myUid)).toList();
    return ListView.builder(itemCount: msgs.length, padding: EdgeInsets.all(8), itemBuilder: (c,i){
      var m=msgs[i]; bool isMe=m['senderId']==myUid;
      return Align(alignment: isMe?Alignment.centerRight:Alignment.centerLeft, child: Container(margin: EdgeInsets.symmetric(vertical:4), padding: EdgeInsets.symmetric(horizontal:12, vertical:8), constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.75), decoration: BoxDecoration(color: isMe?Color(0xFFDCF8C6):Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12), bottomLeft: Radius.circular(isMe?12:0), bottomRight: Radius.circular(isMe?0:12)), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 1)]), child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text(m['content'], style: TextStyle(fontSize:15)), SizedBox(height:2), Text(isMe?'✓✓ ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2,'0')}':'', style: TextStyle(fontSize:10, color: Colors.grey))]));
    });
  }))), Container(color: Color(0xFFF0F0F0), padding: EdgeInsets.all(8), child: Row(children: [Expanded(child: TextField(controller: msgC, decoration: InputDecoration(hintText: 'Type a message', filled: true, fillColor: Colors.white, contentPadding: EdgeInsets.symmetric(horizontal:16, vertical:10), border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none)))), SizedBox(width:8), CircleAvatar(backgroundColor: Color(0xFF075E54), child: IconButton(icon: Icon(Icons.send, color: Colors.white), onPressed: send))]))]));}
}
---

File:.github/workflows/build-apk.yml
---
name: Build SS2 APK
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-java@v3
        with:
          distribution: 'zulu'
          java-version: '17'
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
      - run: flutter pub get
      - run: flutter