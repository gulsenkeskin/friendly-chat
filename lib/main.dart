import 'package:flutter/material.dart';

void main() {
  runApp(
    FriendlyChatApp(),
  );
}

String _name = 'Gülsen';

class FriendlyChatApp extends StatelessWidget {
  const FriendlyChatApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FriendlyChat',
      home: ChatScreen(),
    );
  }
}

class ChatMessage extends StatelessWidget {
  const ChatMessage(
      {required this.text, required this.animationController, Key? key})
      : super(key: key);
  final String text;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    //Animasyona bir SizeTransition widget'ı eklemek, metni içeri doğru kayarken giderek daha fazla ortaya çıkaran bir cliprect'i canlandırma etkisine sahiptir.
    return SizeTransition(
      sizeFactor:
          CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          //CrossAxisAlignment.startmetni yatay eksen boyunca en soldaki konumda hizalar.
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                child: Text(_name[0]),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _name,
                  style: Theme.of(context).textTheme.headline6,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: Text(text),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = [];
  final _textController = TextEditingController();
  //içerik gönderildikten sonra odağı tekrar metin alanına getirmek için
  final FocusNode _focusNode = FocusNode();

  void _handleSubmitted(String text) {
    _textController.clear();

    var message = ChatMessage(
      text: text,
      animationController: AnimationController(
          duration:
              const Duration(milliseconds: 700), //animasyonun çalışma zamanı
          vsync:
              this //Bir Animasyon Denetleyicisi oluştururken, bunu bir vsync bağımsız değişkeni iletmeniz gerekir. Vsync, animasyonu ileriye doğru yönlendiren kalp atışlarının kaynağıdır (Senedi). Bu örnek, vsync olarak _Chat Ekran Durumunu kullanır, bu nedenle _Chat Ekran Durumu sınıf tanımına bir Ticker Sağlayıcı Durumu Mixin mixin ekler.
          ),
    );
    setState(() {
      _messages.insert(0, message);
    });
    _focusNode.requestFocus();
    message.animationController.forward();
  }

  Widget _buildTextComposer() {
    return Container(
      //EdgeInsets.symmetric, bir cihazın piksel oranına bağlı olarak belirli sayıda fiziksel piksele dönüştürülen mantıksal piksellerdir.
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              decoration:
                  const InputDecoration.collapsed(hintText: 'Send a message'),
              //içerik gönderildikten sonra odağı tekrar metin alanına getiri
              focusNode: _focusNode,
            ),
          ),
          IconTheme(
            //butonun rengini değiştirmek //themaData geçerli temanın vurgu rengini verir
            data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: const Icon(Icons.send),
                // Dart'ta ok sözdizimi ( => expression) bazen işlevleri bildirirken kullanılır. Bu kısaltmadır { return expression; }ve yalnızca tek satırlık işlevler için kullanılır
                onPressed: () => _handleSubmitted(_textController.text),
              ),
            ),
          )
        ],
      ),
    );
  }

  //Artık ihtiyaç duyulmadığında kaynaklarınızı boşaltmak için animasyon denetleyicilerinizi elden çıkarmak için
  void dispose() {
    for (var message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('FriendlyChat')),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              //_ çizgi ile ilk argümanı kullanmayacağımı belirttim
              itemBuilder: (_, index) => _messages[index],
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              itemCount: _messages.length,
            ),
          ),
          const Divider(
            height: 1.0,
          ),
          Container(
            //BoxDecorationArka plan rengini tanımlayan yeni bir nesne oluşturur .
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          )
        ],
      ), // NEW
    );
  }
}
