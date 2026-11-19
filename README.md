# Marikanime

> **RPG 2D top-down de exploração, cotidiano e combate em tempo real, desenvolvido na Godot Engine como projeto acadêmico de Engenharia de Software.**

**Estado:** protótipo unificado V4 em desenvolvimento · **Linguagem:** GDScript · **Engine:** Godot 4.3+ · **Plataforma-alvo:** PC

## Sobre o projeto

O **Marikanime** é um jogo 2D que estou desenvolvendo para aplicar, na prática, conceitos de Engenharia de Software e desenvolvimento de jogos digitais. Minha proposta é unir a tranquilidade das férias de verão em **Maricá (RJ)** com a exploração de uma masmorra misteriosa, criando uma experiência em que as atividades da cidade, os personagens e a aventura se complementam.

Na história planejada, o protagonista passa **30 dias de férias** na casa da **Tia Helena**, enquanto a cidade se prepara para o **Maricá Geek Summer Fest**. Durante sua estadia, ele conhece moradores, realiza pequenas tarefas, encontra pistas e descobre uma passagem para uma masmorra ligada ao mistério do **Guardião do Selo**.

A versão atual é um **protótipo de validação**: apresenta um recorte jogável desse conceito, e não a campanha completa. Meu foco é consolidar uma base única e coerente antes de adicionar sprites definitivos, novos mapas e sistemas maiores.

## Objetivos

- Construir um RPG 2D **top-down**, com movimentação livre em oito direções.
- Integrar **exploração da cidade e da masmorra** na mesma experiência.
- Implementar interações, diálogos, descobertas e uma missão inicial.
- Criar um ciclo de tempo que represente a passagem das férias.
- Desenvolver combate em tempo real com espada, magia, esquiva e inimigos.
- Experimentar coleta de recursos, compras, equipamentos rápidos e progressão.
- Manter **um único controlador e design provisório de personagem** para facilitar a futura integração de sprites.
- Organizar o código de modo que possa ser ampliado gradualmente para o TCC.

## Conceito e referências

O jogo combina três eixos: **cotidiano**, **exploração** e **RPG de ação**. A parte cotidiana se inspira na atmosfera de férias e pequenas descobertas de *Boku no Natsuyasumi*; a estrutura de rotina, relacionamentos e exploração dialoga com *Stardew Valley* e *Persona*; e o combate com equipamentos rápidos tem referências em *Terraria*. São referências de mecânicas e direção, não uma reprodução desses jogos.

Também utilizei um guia de outro jogo como referência **exclusivamente para ideias não adultas** de progressão por eventos, conversas diárias, gatos, caminhos bloqueados e reparo de pontes. **O Marikanime não inclui conteúdo sexual ou eventos +18.**

## Evolução do desenvolvimento

### Primeira base: combate e exploração

Comecei pela movimentação, colisões, câmera, ataques orientados pelo cursor e um inimigo de testes. A proposta era verificar se o controle do personagem e o combate funcionariam em uma perspectiva 2D vista de cima.

### Protótipo de cotidiano

Depois acrescentei uma pequena praça, a Tia Helena, objetos examináveis e um ciclo de períodos do dia. Essa etapa ajudou a definir uma identidade própria para o jogo, além do combate.

### V4: unificação

Na versão atual, reuni os dois caminhos em **um único fluxo**: o jogador começa na cidade, conversa, encontra o gato, conclui a primeira missão, libera a entrada da masmorra, combate inimigos e pode retornar à cidade. A troca de ambiente preserva o mesmo personagem e o estado global da partida.

## Mecânicas presentes no código da V4

> Os itens desta seção estão **programados no código-fonte**. Isso não significa que todos tenham sido validados em uma execução completa na Godot; a verificação no editor continua pendente.

### 1. Personagem e movimentação

- `CharacterBody2D` com movimento em **oito direções**, via `Input.get_vector()`.
- Caminhada a **165 px/s** e corrida a **255 px/s**.
- Energia consumida ao correr (**10 pontos/s**) e recuperada ao descansar da corrida (**7 pontos/s**).
- Esquiva com deslocamento rápido, gasto de **12 de energia**, curta invulnerabilidade e intervalo entre usos.
- `Camera2D` seguindo o mesmo jogador em ambos os ambientes.
- Mira orientada pela posição do cursor do mouse.
- **Uma única silhueta provisória** desenhada em `_draw()`, sem dependência de sprites externos.

Não há gravidade, plataformas nem salto: a perspectiva adotada é inteiramente **top-down**.

### 2. Cidade de Maricá

O protótipo gera por código um mapa de **38 × 24 células de 32 px**, com piso, caminhos, obstáculos e colisões. A cidade contém pontos interativos que representam:

- **Tia Helena**, personagem da missão inicial;
- **Lucas**, ligado à preparação do evento geek;
- **Gato da praça**, descoberta registrada no diário;
- **Placa e banco**, examináveis;
- **Árvores**, de onde é possível recolher madeira;
- **Casa da tia**, usada para descansar;
- **Loja**, onde é possível comprar poções;
- **Ponte antiga**, com requisito de reparo;
- **Entrada da masmorra**, liberada após a missão inicial.

As casas e a loja são, por enquanto, **pontos de interação no mapa**, e não interiores exploráveis.

### 3. Interações e diálogos

A tecla **E** procura o objeto interativo mais próximo dentro de uma distância aproximada de **57 px**. Ao conversar, uma caixa de diálogo mostra as falas sequencialmente; pressionar **E** avança o texto.

O jogo pausa a passagem do tempo e bloqueia a movimentação enquanto o diálogo está aberto. A Tia Helena possui controle de conversa por dia, e o sistema registra eventos simples em um dicionário de flags.

### 4. Primeira missão: o gato da praça

A missão inicial é uma pequena sequência com estados:

1. Conversar com a Tia Helena.
2. Receber o pedido para encontrar o gato.
3. Explorar a praça e interagir com o gato.
4. Retornar à Tia Helena para relatar a descoberta.
5. Receber **50 moedas** e liberar o acesso à masmorra.

O diário acompanha os estágios da missão. A afinidade com a Tia Helena aumenta ao iniciar uma conversa diária válida. **Ainda não existe um sistema completo de relacionamentos ou várias questlines.**

### 5. Calendário e passagem do tempo

O calendário começa no **Dia 01/30** e divide o dia em quatro períodos:

**Manhã → Tarde → Noite → Madrugada → próximo dia.**

Cada período dura **75 segundos de tempo real** no protótipo. A cidade muda sua tonalidade ao longo do dia, com filtros de cor para tarde, noite e madrugada. O descanso na casa da tia inicia um novo dia, restaura a energia e recupera parte da vida.

O código contém um limite de **30 dias**, mas **ainda não há uma sequência final, encerramento narrativo ou sistema de finais implementado**.

### 6. Masmorra e transição de mapas

Depois de concluir a missão do gato, o jogador pode entrar na masmorra. O cenário subterrâneo tem paredes, obstáculos, três inimigos iniciais e pontos de interesse:

- Escada de retorno à cidade;
- Inscrição antiga com referência ao **Guardião do Selo**;
- Baú com recompensa de **1 pedra e 60 moedas**.

A transição é feita pelo controlador do mundo, que recria os elementos do ambiente e reposiciona o mesmo jogador. **Ainda não existem múltiplos andares, terraço seguro ou chefe final jogável.**

### 7. Combate em tempo real

- **Espada:** ataque corpo a corpo orientado pelo cursor, com **12 de dano** e intervalo de **0,3 s**.
- **Cajado / magia:** projétil com **8 de dano**, custo de **9 de energia** e intervalo de **0,5 s**.
- **Esquiva:** movimento rápido com breve proteção contra dano.
- **Poção:** restaura **40 HP**, respeitando o limite de vida.
- **Dano recebido:** invulnerabilidade temporária após um golpe.
- **Desmaio:** ao chegar a zero HP, o personagem retorna à cidade com **50 HP**, em vez de uma tela de game over.

O ataque de espada é calculado por distância e direção; os projéteis são atualizados no script do mundo. **Ainda não há um sistema completo de armas equipáveis, animações de ataque ou árvore de habilidades.**

### 8. Inimigos e recompensas

Os inimigos utilizam `CharacterBody2D` e uma IA básica:

- **28 HP** por inimigo;
- Detectam e perseguem o jogador a menos de **210 px**;
- Movem-se a aproximadamente **78 px/s**;
- Atacam de perto, causando **8 de dano**, com intervalo de **1,2 s**;
- Piscam ao receber dano;
- Ao serem derrotados, concedem **15 EXP** e geram recursos coletáveis.

Essa é uma IA de perseguição simples. Ainda não inclui patrulha, estados complexos, navegação avançada ou variedades de inimigos.

### 9. Recursos, loja e ponte

O estado do jogo registra **moedas, poções, madeira, pedra e experiência**. O personagem começa com **300 moedas** e **2 poções**. A loja vende uma poção por **30 moedas**.

Árvores fornecem madeira, o baú da masmorra concede pedra e dinheiro, e inimigos derrotados podem deixar recursos. A ponte possui uma condição experimental de reparo: **2 madeiras + 1 pedra**. O reparo é registrado no estado da partida, mas **não abre ainda uma nova área explorável**.

### 10. Hotbar e diário

A hotbar possui **nove posições**, selecionadas pelas teclas **1 a 9**. As três primeiras estão configuradas como **espada, cajado e poção**; as outras estão vazias.

O HUD exibe **dia, período, HP, energia, moedas, poções, EXP, madeira, pedra e afinidade**. O diário, aberto pela tecla **I**, mostra a missão atual, a quantidade de gatos encontrados, o estado da ponte e a experiência acumulada.

**Importante:** o diário ainda não é um inventário completo; não há interface de arrastar itens, pilhas de itens, equipamento por slot ou salvamento persistente.

## Controles

| Ação | Tecla / entrada |
|---|---|
| Movimentar | WASD ou setas |
| Correr | Shift |
| Esquivar | Espaço |
| Interagir / continuar diálogo | E |
| Ataque principal / usar item selecionado | Mouse esquerdo |
| Magia / ataque secundário | Mouse direito |
| Usar poção | Q |
| Selecionar posição da hotbar | 1–9 |
| Abrir ou fechar diário | I |

As ações principais são definidas no **Input Map** de `project.godot`.

## Arquitetura e organização do projeto

```text
res://
├── project.godot
├── README.md
├── scenes/
│   ├── main.tscn
│   ├── player/
│   │   └── player.tscn
│   ├── enemies/
│   │   └── enemy.tscn
│   └── ui/
│       └── hud.tscn
├── scripts/
│   ├── player/
│   │   └── player.gd
│   ├── enemies/
│   │   └── enemy.gd
│   ├── systems/
│   │   ├── game_state.gd
│   │   └── world.gd
│   └── ui/
│       └── hud.gd
├── assets/
│   ├── characters/
│   ├── enemies/
│   ├── environments/
│   ├── items/
│   ├── ui/
│   └── audio/
└── resources/
```

**Responsabilidades dos arquivos:**

| Arquivo | Responsabilidade |
|---|---|
| `project.godot` | Configuração do projeto, renderização, cena inicial, autoload e entradas |
| `scenes/main.tscn` | Ponto de entrada do mundo |
| `scripts/systems/game_state.gd` | Estado compartilhado: calendário, HP, energia, dinheiro, recursos, missão e flags |
| `scripts/systems/world.gd` | Geração dos mapas, interações, diálogos, viagens, projéteis e objetos |
| `scripts/player/player.gd` | Movimentação, câmera, esquiva, ataques, dano e visual provisório |
| `scripts/enemies/enemy.gd` | Perseguição, ataque, dano recebido e derrota dos inimigos |
| `scripts/ui/hud.gd` | HUD, diálogos, dicas, hotbar e diário |

O `GameState` é carregado como **Autoload**. O controlador do mundo centraliza várias funcionalidades nesta versão; **separá-las em sistemas menores é uma melhoria planejada**, não algo já concluído.

## Direção artística e identidade visual

Minha intenção é trabalhar com **pixel art 2D**, usando uma paleta mais clara e acolhedora para a cidade e cores frias e misteriosas para a masmorra. O protótipo atual desenha pisos, obstáculos, personagens, itens e efeitos com primitivas gráficas da própria Godot.

A principal decisão da V4 foi manter **um único design provisório para o protagonista**. Futuramente pretendo trocar o desenho feito em `_draw()` por um `AnimatedSprite2D`, com animações de parado, caminhada, corrida, esquiva e ataque, sem duplicar o personagem entre cidade e masmorra.

## Como executar

1. Instale a **Godot 4.3 ou superior**.
2. Extraia os arquivos do projeto para uma pasta.
3. No gerenciador de projetos da Godot, selecione **Importar** e abra `project.godot`.
4. Abra o projeto e pressione **F5** para iniciar `scenes/main.tscn`.
5. Caminhe até a Tia Helena, converse com **E**, encontre o gato, volte para receber a recompensa e procure a entrada da masmorra.

**Status de validação:** a V4 foi gerada como código-fonte, mas **não foi executada e aprovada no editor Godot neste ambiente**. Portanto, não afirmo que o projeto esteja livre de erros de parser, integração ou execução. A primeira tarefa prática é abrir o projeto, resolver mensagens do depurador e testar o ciclo completo.

## Estado atual do desenvolvimento

### Programado na V4 — aguardando testes de integração

- [x] Estrutura de cenas e scripts da versão unificada
- [x] Controlador único do jogador para cidade e masmorra
- [x] Movimentação top-down, corrida, esquiva e câmera
- [x] Geração provisória de cidade e masmorra por código
- [x] Colisões com obstáculos
- [x] Objetos interativos e diálogos sequenciais
- [x] Tia Helena, Lucas e gato da praça
- [x] Missão inicial com recompensa e desbloqueio
- [x] Quatro períodos do dia e descanso
- [x] Espada, magia, poções e inimigos de perseguição
- [x] Coleta de recursos, baú e compra de poções
- [x] Hotbar de nove espaços e diário básico
- [x] Sistema experimental de reparo de ponte

### Próximas melhorias — prioridade

- [ ] **Validar a V4 no editor Godot** e corrigir erros de compilação, sinais e interação.
- [ ] Garantir que colisões e transições funcionem após trocar de mapa repetidamente.
- [ ] Migrar a cidade e a masmorra para **`TileMapLayer`** com tilesets próprios.
- [ ] Integrar **sprites e animações** ao único personagem existente.
- [ ] Separar `world.gd` em sistemas menores de interação, diálogo, combate, mapa e missões.
- [ ] Criar um inventário real, equipamentos e interface de itens.
- [ ] Implementar **salvar e carregar** o progresso.
- [ ] Adicionar interiores da casa, da loja e uma área segura de preparação na masmorra.
- [ ] Criar rotinas de NPCs por período e diálogos com escolhas.
- [ ] Expandir missões encadeadas, afinidade, colecionáveis, pesca e insetos.
- [ ] Construir novos andares, tipos de inimigos, armadilhas e chefes.
- [ ] Implementar efeitos sonoros, música e feedback visual.
- [ ] Completar a narrativa e o encerramento do calendário de 30 dias.

## Próximo marco: uma demonstração vertical

Minha próxima meta é produzir uma versão pequena, estável e apresentável com o ciclo completo **explorar a praça → conversar → cumprir uma missão → preparar-se → entrar na masmorra → combater → coletar → voltar à cidade**. Depois de validar esse ciclo, poderei expandir o jogo sem perder a coerência entre os sistemas.

## Tecnologias

- **Engine:** Godot Engine 4.3+
- **Linguagem:** GDScript
- **Perspectiva:** 2D top-down
- **Renderização:** Compatibility / OpenGL
- **Controle de versão:** Git e GitHub
- **Arte atual:** formas provisórias desenhadas por código
- **Arte planejada:** sprites e tilesets em pixel art

## Projeto acadêmico

Desenvolvo o Marikanime como aplicação prática de conceitos estudados em **Engenharia de Software**, incluindo organização de código, modelagem de estados, orientação a objetos, desenvolvimento incremental, testes, documentação, versionamento e construção de interfaces interativas.

O projeto também funciona como exercício de controle de escopo: primeiro busco um **protótipo pequeno, coerente e testável**, para depois adicionar conteúdo e polimento visual.

## Contribuições e controle de versão

As mudanças são registradas por commits no Git. Exemplo de publicação da documentação:

```bash
git add README.md
git commit -m "docs: documenta prototipo unificado Marikanime V4"
git push
```

## Licença

Este projeto está em desenvolvimento para fins acadêmicos. **Ainda não defini uma licença de distribuição pública.**
