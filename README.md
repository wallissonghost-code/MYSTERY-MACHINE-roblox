# Mystery Machine — Máquina Surpresa 🎁

Primeiro protótipo jogável de coleção RNG para **Roblox Studio**, desenvolvido em **Luau**.

## Já implementado (código inicial, ainda não testado no Studio)

- Máquina de cápsulas 3D gerada automaticamente no mapa, com ProximityPrompt.
- Sorteio no servidor de **20 objetos colecionáveis** (catálogo em `src/shared/Items.lua`).
- Custo de abertura: **25 Coins**; saldo inicial: **250 Coins**.
- Inventário por quantidade, venda individual e índice de objetos descobertos.
- HUD com saldo, abrir cápsula, coleção e notificações de prêmio.
- Dados básicos persistidos em DataStoreService. Se o carregamento falhar, as operações econômicas são bloqueadas para evitar sobrescrita de dados.
- Verificações de saldo, lotação (150 itens), propriedade dos itens, distância da máquina e cooldown.

**Estado: protótipo não validado no Roblox Studio.** Não publicar com economia definitiva sem testar concorrência, saves, reconnect, mobile e casos de falha.

## Como abrir no Roblox Studio

### Fluxo com Rojo (recomendado)

1. Instale [Rojo](https://rojo.space/) e o plugin correspondente no Roblox Studio.
2. Faça clone deste repositório.
3. Abra uma experiência **Baseplate** no Studio.
4. Na pasta do projeto, execute `rojo serve` e conecte o plugin.
5. Pressione **Play**. O servidor constrói a plataforma e a máquina em tempo de execução.
6. Aproxime-se da máquina azul e pressione **E** (ou toque no ProximityPrompt no celular) para abrir cápsulas.
7. Use **INVENTÁRIO** para conferir e vender prêmios. O botão **ABRIR CÁPSULA** funciona apenas próximo à máquina.

Para salvar dados durante testes no Studio, publique uma experiência de teste e habilite **Game Settings > Security > Enable Studio Access to API Services**, somente em ambiente de desenvolvimento.

### Sem Rojo

Crie os seguintes scripts manualmente, copiando o conteúdo dos arquivos:
- `ReplicatedStorage/Shared/Items` (ModuleScript)
- `ServerScriptService/MysteryMachineServer` (Script)
- `StarterPlayer/StarterPlayerScripts/MysteryMachineClient` (LocalScript)

## Arquitetura

- `src/shared/Items.lua`: definições, valores, raridades e pesos de sorteio.
- `src/server/init.server.lua`: mundo 3D inicial, economia, abertura, venda e persistência.
- `src/client/init.client.lua`: HUD responsivo e inventário.
- `default.project.json`: projeto Rojo.

## Próximas etapas

- Modelos originais 3D reconhecíveis para cada objeto, em vez de apenas representações no inventário.
- Animação da cápsula e interface com chances numéricas por objeto.
- Missões e recuperação gratuita de moedas (hoje é possível esgotar o saldo).
- Vitrines, melhorias, novas máquinas, rankings e economia balanceada.
- Melhorar consistência das transações e controle de sessão entre servidores antes de publicar.

## Uso de componentes e licença

Este código inicial foi criado para o Mystery Machine, sem copiar arquivos de jogos de terceiros. Não há modelos externos incorporados. Qualquer biblioteca ou asset externo adicionado futuramente deverá ser verificado quanto à licença e à autoria.

## Segurança de publicação

A versão inicial utiliza apenas moedas obtidas dentro do jogo. Não inclui compras com Robux nem apostas. Revise as políticas atuais de Roblox antes de implementar monetização.
