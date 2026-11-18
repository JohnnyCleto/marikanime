# Marikanime — Protótipo Godot 4 (versão 2)

> RPG 2D de ação e exploração desenvolvido como projeto acadêmico de TCC.

## Sobre o projeto

Nova implementação top-down construída a partir do protótipo GML e organizada conforme o README do projeto Godot já existente. É uma **versão independente**, não uma substituição automática dos arquivos do repositório original.

## Objetivos

- Movimentação em oito direções e corrida.
- Ataque orientado pelo cursor, com espada, cajado e habilidade secundária.
- Colisões, inimigos perseguidores, dano e coleta.
- Cidade, masmorra, preparação e retorno.
- Progressão simples, recursos e calendário.

## Características

- Top-down 2D, sem gravidade ou salto.
- Personagem `CharacterBody2D` com `Camera2D` e `WeaponPivot/Hitbox`.
- Inimigos com perseguição e feedback visual ao sofrer dano.
- Cenários em grade de 32 px, gerados a partir dos mapas GML.
- Hotbar de nove posições, poções, recursos, loja e treinamento.
- Interface desenhada via nós de controle e gráficos provisórios.

## Direção do jogo

Movimentação livre em oito direções (WASD ou setas). O cursor determina a direção dos ataques. Não há plataformas, gravidade ou salto.

## Controles

| Ação | Tecla |
|---|---|
| Movimentação | WASD / setas |
| Correr | Shift |
| Esquiva | Espaço |
| Ataque principal | Mouse esquerdo |
| Habilidade secundária | Mouse direito |
| Interagir | E |
| Poção | Q |
| Reiniciar | R |
| Selecionar hotbar | Roda do mouse |

## Estrutura do projeto

```text
res://
├── assets/
│   ├── characters/
│   ├── enemies/
│   ├── environments/
│   ├── items/
│   ├── ui/
│   └── audio/
├── scenes/
│   ├── player/player.tscn
│   ├── enemies/enemy.tscn
│   ├── enemies/dummy_enemy.tscn
│   ├── city/city.tscn
│   ├── dungeon/dungeon.tscn
│   ├── items/
│   ├── ui/hud.tscn
│   └── test_area.tscn
├── scripts/
│   ├── player/player.gd
│   ├── enemies/enemy.gd
│   ├── enemies/dummy_enemy.gd
│   ├── systems/game.gd
│   ├── items/
│   └── ui/
└── resources/
    ├── city_map.txt
    └── dungeon_map.txt
```

## Desenvolvimento

A primeira etapa reproduz o ciclo de teste do GML. A arquitetura separa cenas do jogador, inimigos e dados de mapa; a lógica de mundo e HUD permanece centralizada em `scripts/systems/game.gd` para ser refatorada posteriormente.

## Estado atual

**Implementado no código:** movimentação, corrida, esquiva, colisões, câmera, mira pelo mouse, ataques, inimigos, vida, coleta, dois mapas, calendário, hotbar e HUD provisório.

**Ainda não implementado:** TileMapLayer editável, sprites definitivos, árvore completa de inventário/equipamentos, NPCs com questlines, áudio e campanha completa.

**Validação:** os arquivos foram gerados, mas não foram executados no editor Godot neste ambiente. A compatibilidade final deve ser conferida ao abrir o projeto.

## Tecnologias

- Godot 4 (recomendado 4.2 ou superior; o README original menciona 4.7+)
- GDScript
- Renderizador Compatibility (OpenGL)
- Git/GitHub

## Como executar

1. Extraia o ZIP.
2. Importe o arquivo `project.godot` na Godot.
3. Execute com F5 (`scenes/test_area.tscn`).
4. Teste cidade, combate e transição para a masmorra.

## Projeto acadêmico

Adaptação incremental do protótipo para o TCC Marikanime. Os mapas e a lógica inicial têm como referência o arquivo GML fornecido e o GDD.

## Licença

Uso acadêmico; não foram adicionados assets externos.
