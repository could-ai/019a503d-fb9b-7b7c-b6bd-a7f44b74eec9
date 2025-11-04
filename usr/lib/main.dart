import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Could AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue,
        hintColor: Colors.blueAccent,
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardColor: const Color(0xFF1E1E1E),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
        appBarTheme: const AppBarTheme(
          color: Color(0xFF1E1E1E),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();

  // A list of random Iranian ads
  final List<String> _iranianAds = [
    "آیا از سرعت اینترنت خود ناراضی هستید؟ با اینترنت پرسرعت ما، دنیایی جدید را تجربه کنید!",
    "بهترین رستوران‌های شهر را با اپلیکیشن ما پیدا کنید. دانلود کنید و از تخفیف ویژه اولین سفارش لذت ببرید.",
    "جدیدترین مدل‌های گوشی هوشمند با قیمت‌های باورنکردنی! همین حالا سفارش دهید.",
    "با بیمه ما، آینده خود و خانواده‌تان را تضمین کنید. مشاوره رایگان دریافت کنید.",
    "سفری خاطره‌انگیز به زیباترین نقاط ایران با تورهای ما. برای اطلاعات بیشتر تماس بگیرید."
  ];

  void _handleSubmitted(String text) {
    if (text.isEmpty) return;

    _textController.clear();
    setState(() {
      _messages.insert(0, ChatMessage(text: text, isUserMessage: true));
      // Mock AI response
      String aiResponse = "در حال پردازش درخواست شما... به زودی پاسخ خواهم داد.";
      _messages.insert(0, ChatMessage(text: aiResponse, isUserMessage: false));

      // Add a random ad after a few messages
      if (_messages.length % 6 == 0) {
        int adIndex = _messages.length ~/ 6 % _iranianAds.length;
        _messages.insert(0, ChatMessage(text: _iranianAds[adIndex], isUserMessage: false, isAd: true));
      }
    });
  }

  Widget _buildTextComposer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.image_outlined, color: Colors.white70),
            onPressed: () {
              // Placeholder for image generation functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('قابلیت ساخت تصویر به زودی اضافه خواهد شد.')),
              );
            },
          ),
          Expanded(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              decoration: const InputDecoration.collapsed(
                hintText: 'پیام خود را ارسال کنید...',
                hintStyle: TextStyle(color: Colors.white70)
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blueAccent),
            onPressed: () => _handleSubmitted(_textController.text),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('هوش مصنوعی Could AI'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (_, int index) => _messages[index],
            ),
          ),
          const Divider(height: 1.0),
          _buildTextComposer(),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  const ChatMessage({required this.text, required this.isUserMessage, this.isAd = false, super.key});

  final String text;
  final bool isUserMessage;
  final bool isAd;

  @override
  Widget build(BuildContext context) {
    final CrossAxisAlignment crossAxisAlignment = isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final Color bubbleColor = isAd 
      ? Colors.green.shade700 
      : (isUserMessage ? Colors.blueAccent : const Color(0xFF2A2D3E));
    final TextAlign textAlign = isUserMessage ? TextAlign.right : TextAlign.left;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: crossAxisAlignment,
              children: [
                if (isAd)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      "تبلیغ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                Text(
                  text,
                  textAlign: textAlign,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
