import 'package:flutter/material.dart';
import 'perfil.dart';
import 'quero_jogar.dart';


const List<String> _ultimosLancamentos = [
  'Wolverine',
  'Control: Resonant',
  "Assassin's Creed Black Flag Resynced",
  'Mouse P.I. For Hire',
];

const List<String> _proximosLancamentos = [
  'GTA 6',
  'The Legend of Zelda: Ocarina of Time Remake',
  'Call of Duty: Modern Warfare 4',
];

const List<String> _melhoresJogos = [
  'Pac-Man World',
  'Celeste',
  'The Last of Us 2',
  'Red Dead Redemption 2',
  'Skyrim',
];

const List<String> _proximosParaJogar = [
  'GTA 6',
  'Crimson Desert',
  'Battlefield 6',
  'Super Mario World',
  'God of War',
];

const List<String> _jogosFavoritos = [
  'The Last of Us',
  'The Witcher 3: Wild Hunt',
  'DayZ',
  'Battlefield 4',
  'Alan Wake 2',
];

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _indice = 0;

  @override
  Widget build(BuildContext context) {

    final telas = <Widget>[
      _InicioTab(onVerQueroJogar: () => setState(() => _indice = 1)),
      const QueroJogarView(),
      const QueroJogarView (), //Não esquecer de alterar!!
      const QueroJogarView(), //Não esquecer de alterar!!
      const  PerfilView(),
    ];

    return Scaffold(
      body: IndexedStack(index: _indice, children: telas),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indice,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        onDestinationSelected: (i) => setState(() => _indice = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_border),
            selectedIcon: Icon(Icons.bookmark),
            label: 'Quero jogar',
          ),
          NavigationDestination(
            icon: Icon(Icons.star_border),
            selectedIcon: Icon(Icons.star),
            label: 'Notas',
          ),
          NavigationDestination(
            icon: Icon(Icons.rate_review_outlined),
            selectedIcon: Icon(Icons.rate_review),
            label: 'Críticas',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}


class _InicioTab extends StatelessWidget {
  const _InicioTab({required this.onVerQueroJogar});

  
  final VoidCallback onVerQueroJogar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Byte'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            tooltip: 'Sair',
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context,
              '/login',
              (rota) => false,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        children: [

          //Grids
          const _TituloSecao('Top 5'),
          const _GradeHorizontal(titulos: _melhoresJogos, comRanking: true),
          const SizedBox(height: 24),
          
          const _TituloSecao('Lançamentos Recentes'),
          const _GradeHorizontal(titulos: _ultimosLancamentos),
          const SizedBox(height: 24),
          
          const _TituloSecao('Próximos Lançamentos'),
          const _GradeHorizontal(titulos: _proximosLancamentos),
          const SizedBox(height: 24),

          // Lists
          _TituloSecao(
            'Na fila',
            acao: 'Ver tudo',
            onAcao: onVerQueroJogar,
          ),
          const _ListaJogos(titulos: _proximosParaJogar),
          const SizedBox(height: 24),

          _TituloSecao(
            'Favoritos',
            acao: 'Editar',
            onAcao: () => Navigator.pushNamed(context, '/favoritos'),
          ),
          const _ListaJogos(titulos: _jogosFavoritos),
        ],
      ),
    );
  }
}

/// Título de uma seção, com um botão de ação opcional à direita.
class _TituloSecao extends StatelessWidget {
  const _TituloSecao(this.titulo, {this.acao, this.onAcao});

  final String titulo;
  final String? acao;
  final VoidCallback? onAcao;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              titulo,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          if (acao != null) TextButton(onPressed: onAcao, child: Text(acao!)),
        ],
      ),
    );
  }
}

class _GradeHorizontal extends StatelessWidget {
  const _GradeHorizontal({required this.titulos, this.comRanking = false});

  final List<String> titulos;
  final bool comRanking;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: titulos.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisExtent: 112,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (context, i) => _CapaJogo(
          titulo: titulos[i],
          posicao: comRanking ? i + 1 : null,
        ),
      ),
    );
  }
}

class _CapaJogo extends StatelessWidget {
  const _CapaJogo({required this.titulo, this.posicao});

  final String titulo;
  final int? posicao;

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: cores.outline),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(8),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Text(
              titulo,
              textAlign: TextAlign.center,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: textos.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          if (posicao != null)
            Positioned(
              top: 0,
              left: 0,
              child: Text(
                '#$posicao',
                style: textos.labelLarge?.copyWith(
                  color: cores.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ListaJogos extends StatelessWidget {
  const _ListaJogos({required this.titulos});

  final List<String> titulos;

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: titulos.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, i) => Card(
        margin: EdgeInsets.zero,
        child: ListTile(
          leading: Container(
            width: 40,
            height: 56,
            decoration: BoxDecoration(
              border: Border.all(color: cores.outline),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.sports_esports_outlined, color: cores.outline),
          ),
          title: Text(titulos[i]),
        ),
      ),
    );
  }
}