import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Galería Interactiva',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Lista de imágenes para el ejemplo (Option B: cambiar imagen al tap)
  final List<String> _cycleImages = [
    'https://picsum.photos/seed/1/600/400',
    'https://picsum.photos/seed/2/600/400',
    'https://picsum.photos/seed/3/600/400',
  ];

  int _currentIndex = 0;

  void _nextImage() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _cycleImages.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Galería Interactiva'),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF6F8FB), // fondo suave
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Imagen que cambia al tocarla (Option B)
              GestureDetector(
                onTap: _nextImage,
                child: ImageCard(
                  imageUrl: _cycleImages[_currentIndex],
                  label: 'Toca para cambiar imagen',
                ),
              ),
              const SizedBox(height: 16),

              // Imagen que navega a SecondPage (Option A)
              GestureDetector(
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SecondPage()),
                  );
                },
                child: const ImageCard(
                  imageUrl: 'https://picsum.photos/seed/galeria/600/400',
                  label: 'Ir a segunda pantalla',
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'Instrucciones:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                '• Toca la primera imagen para que cambie.\n• Toca la segunda imagen para navegar a la galería (SecondPage).',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Tarjeta reutilizable para mostrar una imagen con estilo
class ImageCard extends StatelessWidget {
  final String imageUrl;
  final String? label;

  const ImageCard({super.key, required this.imageUrl, this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      padding: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: AspectRatio(
              aspectRatio: 3 / 2,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(child: Icon(Icons.broken_image)),
                  );
                },
              ),
            ),
          ),
          if (label != null) ...[
            const SizedBox(height: 8),
            Text(label!, style: const TextStyle(fontSize: 14)),
          ]
        ],
      ),
    );
  }
}

/// Segunda pantalla con una galería de imágenes
class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    final images = List<String>.generate(
      4,
      (i) => 'https://picsum.photos/seed/second${i + 1}/500/350',
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('SecondPage - Galería'),
      ),
      backgroundColor: const Color(0xFFF6F8FB),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: List.generate(images.length, (index) {
            final img = images[index];
            return GestureDetector(
              onTap: () {
                // Alternamos comportamiento para demostrar ambas opciones
                if (index % 2 == 0) {
                  // Mostrar otra pantalla con la imagen ampliada
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => ImageDetailPage(imageUrl: img),
                  ));
                } else {
                  // Regresar a la pantalla anterior
                  Navigator.of(context).pop();
                }
              },
              child: ImageCard(
                imageUrl: img,
                label: index % 2 == 0 ? 'Toca para ver grande' : 'Toca para regresar',
              ),
            );
          }),
        ),
      ),
    );
  }
}

/// Página que muestra una imagen en grande
class ImageDetailPage extends StatelessWidget {
  final String imageUrl;

  const ImageDetailPage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Imagen'),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: InteractiveViewer(
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stackTrace) {
              return const Center(child: Icon(Icons.broken_image, color: Colors.white));
            },
          ),
        ),
      ),
    );
  }
}
