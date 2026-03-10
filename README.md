# 🏷️ Tagging Test App

Protótipo Flutter para validação de tagueamento com **Firebase Analytics**.

---

## 📱 Telas

| Tela | Cor | Descrição |
|------|-----|-----------|
| **Tela A** | Azul | Tela inicial com botão de clique e navegação |
| **Tela B** | Verde | Seleção de opções antes de avançar |
| **Tela C** | Laranja | Conclusão do fluxo com relatório de eventos |

---

## 📊 Eventos Tagueados

| Evento | Tela | Parâmetros |
|--------|------|------------|
| `screen_view` | A, B, C | `screen_name`, `firebase_screen_class` |
| `button_click` | A | `button_id`, `click_count`, `screen` |
| `option_selected` | B | `option_id`, `option_label`, `screen` |
| `navigation_click` | A, B | `button_id`, `destination`, `screen` |
| `flow_completed` | C | `button_id`, `selected_option`, `screen` |
| `flow_restart` | C | `button_id`, `total_events`, `screen` |

---

## 🚀 Como rodar

### 1. Pré-requisitos

- Flutter SDK `>=3.2.0`
- Conta no [Firebase Console](https://console.firebase.google.com/)
- FlutterFire CLI instalado:

```bash dart pub global activate flutterfire_cli ```

### 2. Clonar o repositório

```bash git clone https://github.com/seu-usuario/tagging_test_app.git cd tagging_test_app ```

### 3. Configurar Firebase

#### a) Criar projeto no Firebase Console
1. Acesse [console.firebase.google.com](https://console.firebase.google.com/)
2. Clique em **"Adicionar projeto"**
3. Siga o assistente e ative o **Google Analytics**

#### b) Configurar com FlutterFire CLI
```bash flutterfire configure ```
> Isso gera automaticamente o arquivo `lib/firebase_options.dart` #### c) Adicionar arquivos de configuração manualmente (alternativa) **Android** → Baixe `google-services.json` e coloque em `android/app/` **iOS** → Baixe `GoogleService-Info.plist` e coloque em `ios/Runner/` ### 4. Instalar dependências ```bash flutter pub get ``` ### 5. Rodar o app ```bash flutter run ``` --- ## 🔧 Configuração Android No arquivo `android/build.gradle` (nível projeto): ```gradle dependencies { classpath 'com.google.gms:google-services:4.4.0' } ``` No arquivo `android/app/build.gradle` (nível app): ```gradle apply plugin: 'com.google.gms.google-services' ``` --- ## 🔧 Configuração iOS ```bash cd ios && pod install ``` --- ## 📁 Estrutura do Projeto ``` lib/ ├── main.dart # Entry point + Firebase init ├── firebase_options.dart # Gerado pelo FlutterFire CLI ⚠️
├── analytics/
│   └── analytics_service.dart # Serviço de tagueamento ├── screens/ │ ├── screen_a.dart               # Tela A
│   ├── screen_b.dart # Tela B │ └── screen_c.dart               # Tela C
└── widgets/
└── tracked_button.dart # Botão com tagueamento automático ``` 
---

## ⚠️ Arquivos não versionados (segurança)

Por segurança, os arquivos abaixo estão no `.gitignore`:
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`
- `lib/firebase_options.dart`

Cada desenvolvedor deve configurar o Firebase localmente.

---

## 🧪 Verificar eventos no Firebase

1. Acesse o [Firebase Console](https://console.firebase.google.com/)
2. Vá em **Analytics → DebugView**
3. Rode o app com o comando:

```bash # Android adb shell setprop debug.firebase.analytics.app com.example.tagging_test_app # iOS (Simulator) flutter run --dart-define=FIREBASE_DEBUG=true ```
