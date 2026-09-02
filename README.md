# Exercicio - Analise de Logs Internos do Sistema

Trabalho da faculdade sobre analise de logs no Linux, usando shell script
(grep, awk, sort, uniq, sed, regex) pra filtrar informacoes dos arquivos
que ficam em /var/log.

## Instrucoes do exercicio

Pra cada desafio:
1. Identificar qual arquivo de log em /var/log e o mais apropriado pra tarefa
2. Criar um script shell que resolva o problema
3. Usar comandos do Linux (grep, awk, sort, uniq etc) e regex pra filtrar e manipular os dados
4. Explicar o raciocinio usado em cada comando/solucao (aqui essa parte ficou
   nesse README em vez de comentario dentro do codigo)

## Feito ate agora (bloco de tentativas de login)

Log usado: `/var/log/auth.log`. E o log onde o sshd, o PAM e o sudo escrevem
tudo que envolve autenticacao no sistema (login certo, login errado, uso de
sudo). Por isso os 4 scripts abaixo usam o mesmo arquivo.

Como aqui nao tenho um servidor linux de verdade pra testar, os scripts
checam se `/var/log/auth.log` existe e, se nao existir, usam o arquivo
`auth.log.sample` (que eu montei simulando entradas reais) so pra
demonstrar que funciona.

### 1_senhas_incorretas.sh
Lista os usuarios que tentaram logar com senha errada e quantas vezes cada
um errou.
- filtra as linhas com "Failed password"
- tira as que tem "invalid user" (usuario que nem existe, isso fica pro
  script 4)
- pega o nome do usuario com awk, procurando o campo que vem depois da
  palavra "for"
- ordena, conta repetidos com uniq -c e reordena do maior pro menor

### 2_logins_sucesso.sh
Mostra todos os logins que deram certo, com usuario e data/hora.
- filtra "Accepted" (cobre tanto login por senha quanto por chave)
- tira data/hora dos 3 primeiros campos da linha (padrao do syslog)
- pega usuario e ip com grep -oE

### 3_auditoria_sudo.sh
Mostra quem usou o sudo, quando e qual comando rodou.
- filtra as linhas que tem "sudo:"
- tira quem tentou e nao tinha permissao (fica pro script 4)
- usuario e extraido com sed, pegando o que vem antes do " : "
- comando e tudo que vem depois de "COMMAND="

### 4_outros_motivos_rejeicao.sh
Mostra login/acesso negado por outro motivo que nao seja senha errada.
- "Invalid user" = tentou logar com usuario que nao existe
- "NOT in sudoers" = usuario existe mas nao tem permissao pra sudo

## Como rodar

```bash
chmod +x *.sh
./1_senhas_incorretas.sh
./2_logins_sucesso.sh
./3_auditoria_sudo.sh
./4_outros_motivos_rejeicao.sh
```

Numa maquina Linux de verdade, provavelmente precisa rodar com sudo pra
conseguir ler o /var/log/auth.log:

```bash
sudo ./1_senhas_incorretas.sh
```

## Falta fazer (resto do exercicio)

Hoje só deu tempo desses 4 (bloco de tentativas de login). O resto da
lista fica pra depois:

**Analise de atividade do sistema**
- 6. Ultimo boot do sistema (log: `journalctl` / `/var/log/wtmp`, comando `who -b`)
- 7. Eventos de shutdown/reinicializacao (`/var/log/wtmp` ou journalctl)
- 8. Servicos que iniciaram/pararam recentemente (journalctl -u ou syslog)

**Analise de pacotes e seguranca interna**
- 11. Pacotes instalados na ultima semana (`/var/log/dpkg.log` ou `/var/log/apt/history.log`)
- 12. Pacotes removidos do sistema (mesmo log do item 11)
- 13. Uso de apt/apt-get/dpkg, quem rodou e qual acao (`/var/log/apt/history.log`)

**Analise de periodos (uptime)**
- 14. Tempo de atividade entre boot e shutdown
- 15. Filtrar eventos entre 14h e 15h de um dia especifico

**Falhas criticas e erros**
- 16. Servico que mais gera log (contar por servico e ordenar decrescente)
- 17. Usuario + metodo de autenticacao em cada login falho (ssh, su, etc)
- 18. Monitorar tentativas de login falho em tempo real (tail -f)
- 19. Buscar error/warning de um servico especifico (ex: sshd, cron)
- 20. Calcular tempo logado de um usuario (login x logout)
