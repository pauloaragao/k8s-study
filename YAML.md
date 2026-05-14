# YAML
YAML (YAML Ain't Markup Language) é um formato de serialização de dados legível por humanos, usado para configurar e definir recursos em Kubernetes. Ele é amplamente utilizado para criar arquivos de configuração para pods, serviços, deployments e outros recursos do Kubernetes. O YAML é fácil de ler e escrever, e é uma escolha popular para definir a infraestrutura como código em ambientes de orquestração de contêineres. Ele permite que os usuários descrevam a configuração de seus recursos de forma clara e concisa, facilitando a automação e o gerenciamento de clusters Kubernetes.

## Kind
O campo "kind" em um arquivo YAML do Kubernetes é usado para especificar o tipo de recurso que está sendo definido. Ele indica ao Kubernetes qual tipo de objeto está sendo criado ou modificado, como um pod, serviço, deployment, etc. O valor do campo "kind" deve corresponder a um tipo de recurso válido no Kubernetes, e é essencial para que o cluster possa interpretar corretamente a configuração e criar os recursos desejados. O campo "kind" é uma parte fundamental da estrutura do arquivo YAML e é necessário para garantir que os recursos sejam criados corretamente no cluster Kubernetes. Pode ser deployment, service, pod, configmap, secret, etc.

Pod: naked container for debug and local tests
Deployment: gerencia a criação e atualização de pods, garantindo que o número desejado de réplicas esteja sempre em execução.
Service: expõe um conjunto de pods como um serviço de rede, permitindo a comunicação entre os pods e outros recursos dentro do cluster ou externamente.
ConfigMap: armazena dados de configuração em formato de chave-valor, que podem ser usados por pods para configurar suas aplicações.
Secret: armazena informações sensíveis, como senhas, tokens ou chaves de API, de forma segura, permitindo que os pods acessem essas informações sem expô-las diretamente no código ou em arquivos de configuração.

## Restart Policy
A política de reinicialização (Restart Policy) é uma configuração em Kubernetes que determina o comportamento de um pod quando um contêiner dentro dele falha ou é encerrado. Existem três opções principais para a política de reinicialização: Always, OnFailure e Never. A opção Always reinicia o contêiner sempre que ele falha, a opção OnFailure reinicia o contêiner apenas se ele falhar, e a opção Never não reinicia o contêiner, mesmo que ele falhe. A escolha da política de reinicialização depende do caso de uso específico e das necessidades do aplicativo em execução no pod. A política de reinicialização é importante para garantir a disponibilidade e a resiliência dos aplicativos em Kubernetes, permitindo que eles sejam reiniciados automaticamente em caso de falhas, garantindo que os serviços permaneçam disponíveis para os usuários.


## Comamand e Args:
O comando e os argumentos são usados para definir o processo de inicialização do contêiner em um pod. O comando é a instrução principal que será executada quando o contêiner for iniciado, enquanto os argumentos são os parâmetros adicionais que podem ser passados para o comando. Eles são definidos na especificação do contêiner dentro do arquivo de configuração do pod. O comando e os argumentos permitem personalizar o comportamento do contêiner e garantir que ele execute a tarefa desejada quando for iniciado.

## Liviness e Readiness Probes:
As probes de liveliness e readiness são mecanismos de monitoramento em Kubernetes que ajudam a garantir a saúde e a disponibilidade dos pods. A probe de liveliness verifica se o contêiner está vivo e funcionando corretamente, enquanto a probe de readiness verifica se o contêiner está pronto para receber tráfego. Ambas as probes são configuradas na especificação do contêiner e podem ser usadas para reiniciar o contêiner se ele falhar ou para impedir que o tráfego seja enviado para um contêiner que não está pronto. As probes de liveliness e readiness são essenciais para garantir a resiliência e a confiabilidade dos aplicativos em Kubernetes, permitindo que o cluster gerencie automaticamente os pods e garanta que eles estejam sempre disponíveis para os usuários.

