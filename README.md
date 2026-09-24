# Marikanime

> RPG 2D de ação e exploração desenvolvido como projeto de Trabalho de Conclusão de Curso (TCC).
> 
> 

## Sobre o projeto

**Marikanime** é um RPG 2D de ação e exploração desenvolvido na Godot Engine.

O projeto apresenta uma experiência baseada na exploração de uma cidade e de uma masmorra, combinando combate em tempo real, exploração, coleta de recursos e progressão do personagem.

O desenvolvimento tem como objetivo construir um protótipo jogável que demonstre os principais sistemas e conceitos propostos para o projeto.

## Objetivos

O projeto tem como principais objetivos:

* Desenvolver um jogo 2D utilizando a Godot Engine;


* Implementar movimentação livre em oito direções com suporte a corrida;


* Desenvolver um sistema de combate em tempo real focado no uso do cursor do mouse;
* Criar inimigos com comportamentos básicos de reatividade e recepção de dano;


* Implementar exploração de ambientes com física de colisões;


* Desenvolver sistema de coleta e gerenciamento de itens;


* Criar uma área de cidade e uma área de masmorra;


* Desenvolver sistemas de progressão do personagem;


* Produzir um protótipo funcional para apresentação do TCC.



## Características

O protótipo busca apresentar:

* Movimentação top-down de 8 direções;


* Exploração;


* Combate em tempo real com direcionamento por cursor;
* Inimigos interativos com rotinas de dano;


* Itens e recursos;


* Inventário;


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

A movimentação é continua e não utiliza mecânicas de plataforma, gravidade ou salto.

## Controles

| Ação | Controle |
| --- | --- |
| Movimentar para cima | W / Seta para Cima

 |
| Movimentar para baixo | S / Seta para Baixo

 |
| Movimentar para esquerda | A / Seta para Esquerda

 |
| Movimentar para direita | D / Seta para Direita

 |
| Correr | Shift

 |
| Ataque principal | Mouse esquerdo

 |
| Ataque secundário / Habilidade | Mouse direito

 |
| Interagir | E

 |

> Os controles estão parametrizados via **Input Map** e podem ser ajustados conforme o desenvolvimento progrida.
> 
> 

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

Contém os scripts em GDScript responsáveis pelas regras de negócio e comportamentos do jogo.

### `resources/`

Armazena dados estáticos e recursos reutilizáveis compartilhados entre os sistemas.

## Desenvolvimento

O projeto está sendo desenvolvido de forma incremental.

A implementação segue a ordem abaixo:

```text
Estrutura do projeto
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
IA de Inimigos
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

* [x] Estrutura inicial do projeto


* [x] Organização das pastas


* [x] Cena e lógica do jogador (`CharacterBody2D`)


* [x] `CollisionShape2D` e vetor de física do jogador


* [x] `Camera2D` configurada


* [x] Movimentação top-down em 8 direções (com velocidade constante e corrida no `Shift`)
* [x] Mapeamento de entradas no **Input Map** (`move_left`, `move_right`, `move_up`, `move_down`, `run`, `attack`)
* [x] Colisões do cenário (`StaticBody2D` testado na área de testes)
* [x] Sistema de mira e rotação de arma direcionado ao cursor do mouse (`WeaponPivot`)
* [x] Sistema de ataque e colisão em tempo real (`Hitbox` via `Area2D` com conexão do sinal `body_entered`)
* [x] Inimigo de testes provisório (`dummy_enemy.gd`) com detecção de dano e feedback visual (pisca em vermelho)
* [ ] Construção do mapa com TileMap2D
* [ ] Inteligência Artificial de perseguir/atacar para inimigos
* [ ] Sistema de vida e dano do jogador
* [ ] Itens e coleta
* [ ] Inventário
* [ ] Transição entre Cidade e Masmorra
* [ ] Interface de usuário (HUD)
* [ ] Áudio
* [ ] Polimento

## Tecnologias

* **Engine:** Godot Engine 4 (v4.7+)


* **Linguagem:** GDScript


* **Renderizador:** OpenGL API 3.3.0 (Compatibility Mode)


* **Versionamento:** Git


* **Repositório:** GitHub



## Controle de versão

O projeto utiliza Git para controle de versão.

Exemplo de commits das atualizações efetuadas:

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