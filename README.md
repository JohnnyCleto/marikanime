```markdown
# Marikanime

> RPG 2D de ação e exploração desenvolvido como projeto de Trabalho de Conclusão de Curso (TCC).

## Sobre o projeto

**Marikanime** é um RPG 2D de ação e exploração desenvolvido na Godot Engine.

O projeto apresenta uma experiência baseada na exploração de uma cidade e de uma masmorra, combinando combate em tempo real, exploração, coleta de recursos e progressão do personagem.

O desenvolvimento tem como objetivo construir um protótipo jogável que demonstre os principais sistemas e conceitos propostos para o projeto.

## Objetivos

O projeto tem como principais objetivos:

* Desenvolver um jogo 2D utilizando a Godot Engine;
* Implementar movimentação livre em oito direções com suporte a corrida;
* Desenvolver um sistema de combate em tempo real focado no direcionamento pelo cursor do mouse;
* Criar inimigos com comportamentos básicos de reatividade e recepção de dano;
* Implementar exploração de ambientes com física de colisões;
* Desenvolver sistema de coleta e gerenciamento de itens;
* Criar uma área de cidade e uma área de masmorra;
* Desenvolver sistemas de progressão do personagem;
* Produzir um protótipo funcional para apresentação do TCC.

## Características

O protótipo busca apresentar:

* Movimentação top-down de 8 direções;
* Exploração de cenários;
* Combate em tempo real com direcionamento via cursor;
* Inimigos interativos com rotinas de recebimento de dano;
* Itens e recursos;
* Inventário e Hotbar;
* Equipamentos;
* Progressão do personagem;
* Cidade;
* Masmorra;
* Interação com o ambiente.

## Direção do jogo

O jogo utiliza uma perspectiva **2D top-down (up-down)**.

O personagem pode se movimentar livremente pelo ambiente:

```text
       W (Cima)
        ↑
  A ←   ●   → D (Direita)
 (Esquerda) │
        ↓
       S (Baixo)

```

A movimentação é contínua e não utiliza mecânicas de plataforma, gravidade ou salto.

## Controles

| Ação | Controle |
| --- | --- |
| Movimentar para cima | W / Seta para Cima |
| Movimentar para baixo | S / Seta para Baixo |
| Movimentar para esquerda | A / Seta para Esquerda |
| Movimentar para direita | D / Seta para Direita |
| Correr | Shift |
| Ataque principal | Mouse esquerdo |
| Ataque secundário / Habilidade | Mouse direito |
| Interagir | E |

> Os controles estão parametrizados via **Input Map** e podem ser ajustados conforme o desenvolvimento progrida.

## Estrutura do projeto

```text
res://
│
├── assets/
│   ├── characters/
│   ├── enemies/
│   ├── environments/
│   ├── items/
│   ├── ui/
│   └── audio/
│
├── scenes/
│   ├── player/
│   ├── enemies/
│   ├── city/
│   ├── dungeon/
│   ├── items/
│   └── ui/
│
├── scripts/
│   ├── player/
│   ├── enemies/
│   ├── systems/
│   ├── items/
│   └── ui/
│
└── resources/

```

### `assets/`

Armazena os recursos gráficos e sonoros utilizados pelo jogo, como sprites, texturas, cenários, interface e áudios.

### `scenes/`

Contém as cenas do jogo organizadas por sistema ou ambiente, incluindo o jogador, inimigos e cenários de teste (`test_area.tscn`).

### `scripts/`

Contém os scripts em GDScript responsáveis pelas regras de negócio, mecânicas e comportamentos do jogo.

### `resources/`

Armazena dados estáticos e recursos reutilizáveis compartilhados entre os sistemas.

## Desenvolvimento

O desenvolvimento do projeto segue uma abordagem incremental:

```text
Estrutura do projeto (Concluído)
        ↓
Movimentação do jogador (Concluído)
        ↓
Colisões e câmera (Concluído)
        ↓
Sistema de combate básico (Concluído)
        ↓
Inimigo de teste / Dummy (Concluído)
        ↓
Construção do mapa (TileMap)
        ↓
IA de Inimigos (Perseguir e Atacar)
        ↓
Itens e coleta
        ↓
Inventário e Hotbar
        ↓
Progressão do Personagem
        ↓
Cidade e Masmorra
        ↓
Interface (HUD e Menus)
        ↓
Áudio e efeitos
        ↓
Polimento final

```

## Estado atual

🚧 **Em desenvolvimento**

O projeto evoluiu da estruturação inicial e agora possui a base mecânica de movimentação e combate do jogador totalmente funcionais em tempo real.

### Implementado

* [x] Estrutura inicial do projeto e organização das pastas
* [x] Cena e lógica do jogador (`CharacterBody2D`)
* [x] `CollisionShape2D` e física de movimento em 8 direções
* [x] `Camera2D` configurada acompanhando o jogador
* [x] Suporte a caminhada e corrida (`Shift`)
* [x] Mapeamento de entradas no **Input Map** (`move_left`, `move_right`, `move_up`, `move_down`, `run`, `attack`)
* [x] Colisões do cenário com `StaticBody2D`
* [x] Sistema de mira e rotação da arma em direção ao cursor do mouse (`WeaponPivot`)
* [x] Sistema de ataque e área de colisão em tempo real (`Hitbox` via `Area2D` com sinal `body_entered`)
* [x] Inimigo de testes provisório (`dummy_enemy.gd`) com recebimento de dano e feedback visual (pisca em vermelho)
* [ ] Construção do cenário básico com `TileMapLayer`
* [ ] Inteligência Artificial para inimigos (Perseguição e Ataque)
* [ ] Sistema de vida e dano do jogador
* [ ] Itens e coleta de recursos
* [ ] Inventário e gerenciamento de equipamentos
* [ ] Transição de cenários entre Cidade e Masmorra
* [ ] Interface de usuário (HUD)
* [ ] Áudio e efeitos sonoros
* [ ] Polimento visual e de código

## Tecnologias

* **Engine:** Godot Engine 4 (v4.7+)
* **Linguagem:** GDScript
* **Renderizador:** OpenGL API 3.3.0 (Compatibility Mode)
* **Versionamento:** Git
* **Repositório:** GitHub

## Controle de versão

O projeto utiliza Git para controle de versão. As alterações são registradas incrementalmente por commits organizados:

```bash
git add .
git commit -m "Implementa movimentação top-down e corrida"
git commit -m "Adiciona mira com mouse, hitbox de ataque e dummy enemy com feedback de dano"
git push

```

## Projeto acadêmico

Este projeto está sendo desenvolvido como parte de um **Trabalho de Conclusão de Curso (TCC)**.

O desenvolvimento do jogo serve como aplicação prática dos conceitos de:

* Desenvolvimento de jogos 2D;
* Arquitetura de programação orientada a eventos em GDScript;
* Física de jogos (colisões, corpos rígidos, vetores de movimento);
* Engenharia de software e controle de versão.

## Licença

Este projeto está em desenvolvimento exclusivamente para fins acadêmicos.

```

```