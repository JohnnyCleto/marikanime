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

## Sobre o projeto

**Marikanime** é um RPG 2D de ação e exploração desenvolvido na Godot Engine.

O projeto apresenta uma experiência baseada na exploração de uma cidade e de uma masmorra, combinando combate em tempo real, exploração, coleta de recursos e progressão do personagem.

O desenvolvimento tem como objetivo construir um protótipo jogável que demonstre os principais sistemas e conceitos propostos para o projeto.

## Objetivos

O projeto tem como principais objetivos:

- Desenvolver um jogo 2D utilizando a Godot Engine;
- Implementar movimentação livre em quatro direções;
- Desenvolver um sistema de combate em tempo real;
- Criar inimigos com comportamento básico;
- Implementar exploração de ambientes;
- Desenvolver sistema de coleta e gerenciamento de itens;
- Criar uma área de cidade e uma área de masmorra;
- Desenvolver sistemas de progressão do personagem;
- Produzir um protótipo funcional para apresentação do TCC.

## Características

O protótipo busca apresentar:

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

## Direção do jogo

O jogo utiliza uma perspectiva **2D top-down (up-down)**.

O personagem pode se movimentar livremente pelo ambiente:

```text
        W
        ↑
        │
    A ← ● → D
        │
        ↓
        S
```

A movimentação não utiliza mecânicas de plataforma, gravidade ou salto.

## Controles

| Ação | Controle |
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

Armazena os recursos utilizados pelo jogo, como personagens, inimigos, ambientes, itens, interface e áudio.

### `scenes/`

Contém as cenas do jogo organizadas por sistema ou ambiente.

### `scripts/`

Contém os scripts responsáveis pelo funcionamento dos sistemas do jogo.

### `resources/`

Armazena recursos reutilizáveis e dados utilizados pelos sistemas do projeto.

## Desenvolvimento

O projeto está sendo desenvolvido de forma incremental.

A implementação segue uma ordem aproximada:

```text
Estrutura do projeto
        ↓
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

## Estado atual

🚧 **Em desenvolvimento**

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

## Controle de versão

O projeto utiliza Git para controle de versão.

As alterações são organizadas em commits durante o desenvolvimento, permitindo acompanhar a evolução do projeto e recuperar versões anteriores quando necessário.

Exemplo:

```bash
git add .
git commit -m "Implementa movimentação do jogador"
git push
```

## Projeto acadêmico

Este projeto está sendo desenvolvido como parte de um **Trabalho de Conclusão de Curso (TCC)**.

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