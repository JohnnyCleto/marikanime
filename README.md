<<<<<<< HEAD
# marikanime

na raiz:

```text
Marikanime/
├── README.md
├── project.godot
├── assets/
├── scenes/
├── scripts/
└── resources/
```

E colocar:

```markdown
# Marikanime

> RPG 2D de ação e exploração desenvolvido como projeto de Trabalho de Conclusão de Curso (TCC).
=======
# Marikanime

> RPG 2D de ação e exploração desenvolvido como projeto de Trabalho de Conclusão de Curso (TCC).
> 
> 
>>>>>>> 6661dcb8ee698e2ee88c333c135c6890f10d6458

## Sobre o projeto

**Marikanime** é um RPG 2D de ação e exploração desenvolvido na Godot Engine.

O projeto apresenta uma experiência baseada na exploração de uma cidade e de uma masmorra, combinando combate em tempo real, exploração, coleta de recursos e progressão do personagem.

O desenvolvimento tem como objetivo construir um protótipo jogável que demonstre os principais sistemas e conceitos propostos para o projeto.

## Objetivos

O projeto tem como principais objetivos:

<<<<<<< HEAD
- Desenvolver um jogo 2D utilizando a Godot Engine;
- Implementar movimentação livre em quatro direções;
- Desenvolver um sistema de combate em tempo real;
- Criar inimigos com comportamento básico;
- Implementar exploração de ambientes;
- Desenvolver sistema de coleta e gerenciamento de itens;
- Criar uma área de cidade e uma área de masmorra;
- Desenvolver sistemas de progressão do personagem;
- Produzir um protótipo funcional para apresentação do TCC.
=======
* Desenvolver um jogo 2D utilizando a Godot Engine;


* Implementar movimentação livre em oito direções com suporte a corrida;


* Desenvolver um sistema de combate em tempo real focado no uso do cursor do mouse;
* Criar inimigos com comportamentos básicos de reatividade e recepção de dano;


* Implementar exploração de ambientes com física de colisões;


* Desenvolver sistema de coleta e gerenciamento de itens;


* Criar uma área de cidade e uma área de masmorra;


* Desenvolver sistemas de progressão do personagem;


* Produzir um protótipo funcional para apresentação do TCC.


>>>>>>> 6661dcb8ee698e2ee88c333c135c6890f10d6458

## Características

O protótipo busca apresentar:

<<<<<<< HEAD
- Movimentação top-down;
- Exploração;
- Combate em tempo real;
- Inimigos;
- Itens e recursos;
- Inventário;
- Equipamentos;
- Progressão do personagem;
- Cidade;
- Masmorra;
- Interação com o ambiente.
=======
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


>>>>>>> 6661dcb8ee698e2ee88c333c135c6890f10d6458

## Direção do jogo

O jogo utiliza uma perspectiva **2D top-down (up-down)**.

O personagem pode se movimentar livremente pelo ambiente:

```text
<<<<<<< HEAD
        W
        ↑
        │
    A ← ● → D
        │
        ↓
        S
```

A movimentação não utiliza mecânicas de plataforma, gravidade ou salto.
=======
       W (Cima)
        ↑
  A ←   ●   → D (Direita)
 (Esquerda) │
        ↓
       S (Baixo)

```

A movimentação é continua e não utiliza mecânicas de plataforma, gravidade ou salto.
>>>>>>> 6661dcb8ee698e2ee88c333c135c6890f10d6458

## Controles

| Ação | Controle |
<<<<<<< HEAD
|---|---|
| Movimentar para cima | W |
| Movimentar para baixo | S |
| Movimentar para esquerda | A |
| Movimentar para direita | D |
| Correr | Shift |
| Ataque | Mouse esquerdo |
| Ataque secundário | Mouse direito |
| Interagir | E |

> Os controles podem ser modificados durante o desenvolvimento do projeto.
=======
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
>>>>>>> 6661dcb8ee698e2ee88c333c135c6890f10d6458

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
<<<<<<< HEAD
=======

>>>>>>> 6661dcb8ee698e2ee88c333c135c6890f10d6458
```

### `assets/`

<<<<<<< HEAD
Armazena os recursos utilizados pelo jogo, como personagens, inimigos, ambientes, itens, interface e áudio.

### `scenes/`

Contém as cenas do jogo organizadas por sistema ou ambiente.

### `scripts/`

Contém os scripts responsáveis pelo funcionamento dos sistemas do jogo.

### `resources/`

Armazena recursos reutilizáveis e dados utilizados pelos sistemas do projeto.
=======
Armazena os recursos gráficos e sonoros utilizados pelo jogo, como sprites, texturas, cenários, interface e áudios.

### `scenes/`

Contém as cenas do jogo organizadas por sistema ou ambiente, incluindo o jogador, inimigos e cenários de teste (`test_area.tscn`).

### `scripts/`

Contém os scripts em GDScript responsáveis pelas regras de negócio e comportamentos do jogo.

### `resources/`

Armazena dados estáticos e recursos reutilizáveis compartilhados entre os sistemas.
>>>>>>> 6661dcb8ee698e2ee88c333c135c6890f10d6458

## Desenvolvimento

O projeto está sendo desenvolvido de forma incremental.

<<<<<<< HEAD
A implementação segue uma ordem aproximada:
=======
A implementação segue a ordem abaixo:
>>>>>>> 6661dcb8ee698e2ee88c333c135c6890f10d6458

```text
Estrutura do projeto
        ↓
<<<<<<< HEAD
Movimentação do jogador
        ↓
Colisões e câmera
        ↓
Construção do mapa
        ↓
Sistema de combate
        ↓
Inimigos
        ↓
Itens e coleta
        ↓
Inventário
        ↓
Progressão
        ↓
Cidade
        ↓
Masmorra
        ↓
Interface
        ↓
Áudio e efeitos
        ↓
Polimento
        ↓
Protótipo final
```

O desenvolvimento prioriza inicialmente sistemas funcionais e posteriormente substitui elementos provisórios por arte, animações, efeitos sonoros e outros recursos definitivos.
=======
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
>>>>>>> 6661dcb8ee698e2ee88c333c135c6890f10d6458

## Estado atual

🚧 **Em desenvolvimento**

<<<<<<< HEAD
Atualmente, o projeto está na etapa inicial de desenvolvimento do protótipo.

### Implementado

- [x] Estrutura inicial do projeto
- [x] Organização das pastas
- [x] Cena inicial do jogador
- [x] `CharacterBody2D` para o jogador
- [x] `CollisionShape2D`
- [x] `Polygon2D` provisório
- [x] `Camera2D`
- [ ] Movimentação top-down
- [ ] Colisões do cenário
- [ ] Sistema de combate
- [ ] Inimigos
- [ ] Sistema de vida e dano
- [ ] Itens
- [ ] Inventário
- [ ] Cidade
- [ ] Masmorra
- [ ] Interface
- [ ] Áudio
- [ ] Polimento

## Tecnologias

- **Engine:** Godot
- **Linguagem:** GDScript
- **Versionamento:** Git
- **Repositório:** GitHub
=======
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


>>>>>>> 6661dcb8ee698e2ee88c333c135c6890f10d6458

## Controle de versão

O projeto utiliza Git para controle de versão.

<<<<<<< HEAD
As alterações são organizadas em commits durante o desenvolvimento, permitindo acompanhar a evolução do projeto e recuperar versões anteriores quando necessário.

Exemplo:

```bash
git add .
git commit -m "Implementa movimentação do jogador"
git push
=======
Exemplo de commits das atualizações efetuadas:

```bash
git add .
git commit -m "Implementa movimentação top-down e corrida"
git commit -m "Adiciona mira com mouse, hitbox de ataque e dummy enemy com feedback de dano"
git push

>>>>>>> 6661dcb8ee698e2ee88c333c135c6890f10d6458
```

## Projeto acadêmico

Este projeto está sendo desenvolvido como parte de um **Trabalho de Conclusão de Curso (TCC)**.

<<<<<<< HEAD
O desenvolvimento do jogo também serve como aplicação prática dos conhecimentos relacionados a:

- Desenvolvimento de jogos;
- Programação;
- Engenharia de software;
- Design de jogos;
- Organização de projetos;
- Controle de versão.

## Licença

Este projeto está em desenvolvimento para fins acadêmicos.

A definição da licença e das condições de distribuição será realizada posteriormente.
```

### Uma observação importante

Eu deixaria o README **sem colocar informações que ainda não definimos**, como nome da instituição, curso, autor, professor orientador ou licença. Quando você me passar esses dados, podemos colocar uma seção acadêmica mais completa.

Também deixei **“Em desenvolvimento”** e os checkboxes porque isso combina bem com o uso do GitHub no TCC: conforme formos implementando cada sistema, vamos atualizando o README junto com os commits.
=======
O desenvolvimento do jogo serve como aplicação prática dos conceitos de:

* Desenvolvimento de jogos 2D;


* Arquitetura de programação orientada a eventos em GDScript;
* Física de jogos (colisões, corpos rígidos, vetores de movimento);
* Engenharia de software e controle de versão.



## Licença

Este projeto está em desenvolvimento exclusivamente para fins acadêmicos.
>>>>>>> 6661dcb8ee698e2ee88c333c135c6890f10d6458
