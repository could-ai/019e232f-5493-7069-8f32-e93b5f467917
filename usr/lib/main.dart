import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const AutonomousSystemApp());
}

class AutonomousSystemApp extends StatelessWidget {
  const AutonomousSystemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema Autônomo',
      theme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.cyan,
        useMaterial3: true,
        fontFamily: 'RobotoMono',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const DashboardScreen(),
        '/telemetry': (context) => const TelemetryScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isRunning = false;
  bool isShizukuConnected = false;
  bool isModelLoaded = true;

  void toggleSystem() {
    setState(() {
      isRunning = !isRunning;
    });
    if (isRunning) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Iniciando pipeline de visão e inferência...')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sistema autônomo pausado.')),
      );
    }
  }

  void connectShizuku() {
    setState(() {
      isShizukuConnected = !isShizukuConnected;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel de Controle Tático'),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () => Navigator.pushNamed(context, '/telemetry'),
            tooltip: 'Telemetria',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            tooltip: 'Configurações',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildStatusCards(isMobile),
              const SizedBox(height: 24),
              _buildMainControl(),
              const SizedBox(height: 24),
              _buildLogConsole(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCards(bool isMobile) {
    final cards = [
      _StatusCard(
        title: 'Shizuku',
        status: isShizukuConnected ? 'Conectado' : 'Desconectado',
        icon: Icons.adb,
        color: isShizukuConnected ? Colors.green : Colors.red,
        onTap: connectShizuku,
      ),
      _StatusCard(
        title: 'Modelo RL',
        status: isModelLoaded ? 'PPO_v4_Int8.tflite' : 'Não Carregado',
        icon: Icons.memory,
        color: isModelLoaded ? Colors.green : Colors.orange,
      ),
      _StatusCard(
        title: 'Visão (CNN)',
        status: isRunning ? 'Ativo (12ms/frame)' : 'Em Espera',
        icon: Icons.visibility,
        color: isRunning ? Colors.green : Colors.grey,
      ),
    ];

    if (isMobile) {
      return Column(
        children: cards.map((c) => Padding(padding: const EdgeInsets.only(bottom: 12), child: c)).toList(),
      );
    } else {
      return Row(
        children: cards.map((c) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: c))).toList(),
      );
    }
  }

  Widget _buildMainControl() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              'Motor de Auto-Jogo',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: (!isShizukuConnected && !isRunning) ? null : toggleSystem,
              icon: Icon(isRunning ? Icons.stop : Icons.play_arrow, size: 32),
              label: Text(isRunning ? 'PARAR EXECUÇÃO' : 'INICIAR SISTEMA', style: const TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: isRunning ? Colors.red.shade800 : Colors.green.shade800,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                minimumSize: const Size(double.infinity, 64),
              ),
            ),
            if (!isShizukuConnected) ...[
              const SizedBox(height: 12),
              const Text('Conecte o Shizuku para habilitar a atuação.', style: TextStyle(color: Colors.orange)),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildLogConsole() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.cyan.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Console do Sistema', style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold)),
          const Divider(color: Colors.cyan),
          Expanded(
            child: ListView(
              children: const [
                Text('[INFO] Módulo de Percepção Visual inicializado.', style: TextStyle(color: Colors.greenAccent)),
                Text('[INFO] Aguardando permissões MediaProjection...', style: TextStyle(color: Colors.white70)),
                Text('[INFO] Carregando pesos quantizados INT8...', style: TextStyle(color: Colors.white70)),
                Text('[WARN] Shizuku não detectado no socket padrão.', style: TextStyle(color: Colors.orangeAccent)),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final String title;
  final String status;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _StatusCard({
    required this.title,
    required this.status,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 12),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(status, style: TextStyle(color: color, fontSize: 12), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

class TelemetryScreen extends StatelessWidget {
  const TelemetryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Telemetria em Tempo Real')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildInfoTile('Predição de Elixir do Oponente', 'Estimado: 7 (Alta Certeza)'),
          _buildInfoTile('Arquétipo de Deck', 'Log Bait (85% Confiança)'),
          _buildInfoTile('Tempo de Inferência (YOLOv8)', '8.4 ms'),
          _buildInfoTile('Ações de Output', '472 taps, 18 swipes'),
          const SizedBox(height: 24),
          const Text('Janela de Simulação', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade900,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text('Renderização de Features Indisponível (Modo Offline)', style: TextStyle(color: Colors.white54)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14)),
      subtitle: Text(value, style: const TextStyle(color: Colors.cyan, fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações do Motor')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Simular Curvas de Movimento (Bezier)'),
            subtitle: const Text('Reduz detecção anti-cheat suavizando swipes.'),
            value: true,
            onChanged: (val) {},
          ),
          SwitchListTile(
            title: const Text('Coleta de Telemetria Contínua'),
            subtitle: const Text('Salva logs de replay offline para refinamento.'),
            value: true,
            onChanged: (val) {},
          ),
          SwitchListTile(
            title: const Text('Throttling Térmico Adaptativo'),
            subtitle: const Text('Reduz FPS se a temp. da CPU exceder 75°C.'),
            value: true,
            onChanged: (val) {},
          ),
          const Divider(),
          ListTile(
            title: const Text('Modelo RL Atual'),
            subtitle: const Text('PPO_v4_Int8 (Treinado com 1M+ episódios)'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
