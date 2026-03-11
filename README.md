# 🛍️ E-commerce Tagging App

Protótipo Flutter de e-commerce para validação de tagueamento com **Firebase Analytics**.

---

## 📱 Telas

| Tela | Nome | Descrição |
|------|------|-----------|
| **A** | Home | Lista de produtos com botões de detalhes e compra |
| **B** | Produto | Detalhes do produto com opção de adicionar ao carrinho |
| **C** | Carrinho | Resumo dos itens, valores e checkout |
| **D** | Sucesso | Confirmação da compra com código do pedido |

---

## 📊 Eventos Firebase Analytics

| Evento | Tela | Descrição |
|--------|------|-----------|
| `screen_view` | Todas | Visualização de tela |
| `view_item` | A, B | Visualização de produto |
| `add_to_cart` | A, B | Produto adicionado ao carrinho |
| `remove_from_cart` | C | Produto removido do carrinho |
| `view_cart` | A, C | Visualização do carrinho |
| `begin_checkout` | C | Início do checkout |
| `purchase` | D | Compra finalizada |

---

## 🚀 Como rodar

### 1. Pré-requisitos

```bash # Instalar FlutterFire CLI dart pub global activate flutterfire_cli ```

### 2. Clonar e configurar

```bash git clone https://github.com/seu-usuario/ecommerce_tagging_app.git cd ecommerce_tagging_app flutterfire configure flutter pub get flutter run ```

### 3. Debug Analytics

```bash # Android adb shell setprop debug.firebase.analytics.app com.example.ecommerce_tagging_app # Ver logs adb shell setprop log.tag.FA VERBOSE adb shell setprop log.tag.FA-SVC VERBOSE ```

---

## ⚠️ Arquivos não versionados

- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`
- `lib/firebase_options.dart`

Execute `flutterfire configure` para gerá-los localmente.
