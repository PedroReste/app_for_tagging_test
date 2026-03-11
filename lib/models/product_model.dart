class Product {
  final String id;
  final String name;
  final String description;
  final String fullDescription;
  final double price;
  final String emoji;
  final String category;
  final List<String> features;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.fullDescription,
    required this.price,
    required this.emoji,
    required this.category,
    required this.features,
  });

  String get formattedPrice => 'R\$ ${price.toStringAsFixed(2).replaceAll('.', ',')}';
}

// ── Catálogo de produtos ──────────────────────────────────────────

final List<Product> kProducts = [
  Product(
    id: 'prod_001',
    name: 'Tênis Ultraboost Pro',
    description: 'Tênis esportivo de alta performance',
    fullDescription:
        'O Tênis Ultraboost Pro foi desenvolvido para atletas que exigem '
        'o máximo desempenho. Com tecnologia de amortecimento avançada, '
        'solado de borracha de alta tração e cabedal respirável, '
        'proporciona conforto e estabilidade em qualquer superfície.',
    price: 599.90,
    emoji: '👟',
    category: 'Calçados',
    features: [
      'Amortecimento Boost™',
      'Cabedal Primeknit respirável',
      'Solado Continental™',
      'Disponível em 6 cores',
    ],
  ),
  Product(
    id: 'prod_002',
    name: 'Smartwatch Series X',
    description: 'Relógio inteligente com monitoramento de saúde',
    fullDescription:
        'O Smartwatch Series X é o companheiro perfeito para o seu dia a dia. '
        'Monitore sua saúde com sensores de frequência cardíaca, SpO2 e GPS. '
        'Bateria com duração de até 7 dias e resistência à água de 50 metros.',
    price: 1299.00,
    emoji: '⌚',
    category: 'Tecnologia',
    features: [
      'Monitor cardíaco 24h',
      'GPS integrado',
      'Resistente à água 50m',
      'Bateria 7 dias',
    ],
  ),
  Product(
    id: 'prod_003',
    name: 'Mochila Urban Explorer',
    description: 'Mochila resistente para o dia a dia urbano',
    fullDescription:
        'A Mochila Urban Explorer foi projetada para quem vive a cidade '
        'em ritmo acelerado. Com compartimento acolchoado para notebook de '
        'até 15", porta USB externa para carregamento e material impermeável, '
        'é a parceira ideal para trabalho e aventura.',
    price: 349.90,
    emoji: '🎒',
    category: 'Acessórios',
    features: [
      'Compartimento notebook 15"',
      'Porta USB externa',
      'Material impermeável',
      'Capacidade 30L',
    ],
  ),
];
