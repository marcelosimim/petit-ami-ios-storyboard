# Petit Ami

Esse é um projeto pessoal usado no aprendizado de Swift. 
O app auxilia no estudo de francês. Os exercícios podem ser cadastrados no banco de dados **(Firebase)** e separados por unidades. O progresso do usuário é armazenado e ele sempre pode continuar de onde parou. 

Os exercícios seguem o seguinte formato:
- Leitura, escuta e repetição
- Leitura, escuta e resposta

### Exercício de repetição
Há um áudio relacionado ao exercício e uma resposta pré-definida no banco de dados. Ao clicar no botão do microfone, o usuário pode repetir a frase que já será escutada em francês. Caso esteja certa, irá automaticamente para o próximo exercício.

![Exercício de repetição]( https://drive.google.com/uc?export=view&id=1EwEEfxNGiWpEKNlzjtZLYyT1jrzryQIl)

![Exercício de repetição]( https://drive.google.com/uc?export=view&id=1oTMRVCXNhfm_PYpb_U3M1el1XwgUxhZ8)

### Exercício de resposta (em andamento)
Para exercícios de resposta, também há uma resposta pré-definida no banco de dados. A resposta enviada pelo usuário no banco de texto será comparada com a resposta correta. Caso essa estiver certa, seguirá para o próximo exercício.


## Dependências
O projeto usa as seguintes dependências:
- **Firebase: firestore, storage, authentication**
- **Instant Search Voice Overlay**

