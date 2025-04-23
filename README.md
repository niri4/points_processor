
# 📊 Points Processor API

A lightweight Ruby on Rails API that processes point transactions from external API vendors. Includes endpoints for single and bulk transactions, test coverage, and optional GitHub Actions CI integration.

---

## 🚀 Features

- ✅ Fetch and store a **single** transaction from a mocked external API
- 📦 Fetch and store **bulk** transactions from a mocked external API
- 🧪 Unit & integration tests with RSpec
- 🐘 Uses PostgreSQL for persistence
- ⚙️ Optional GitHub Actions CI setup

---

## 🧰 Tech Stack

- Ruby on Rails (API mode)
- PostgreSQL
- RSpec + FactoryBot + WebMock + database_cleaner-active_record
- HTTParty (for external API requests)

---

## 🖥️ Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/niri4/points_processor.git
cd points-processor
```

### 2. Install Dependencies

```bash
bundle install
```

### 3. Set Up PostgreSQL Database

Ensure PostgreSQL is running locally (default port: 5432).

Create the database:

```bash
rails db:create db:migrate
```

> If needed, edit `config/database.yml` with your local DB credentials.

---

## ▶️ Running the Server

```bash
rails s
```

By default, the app runs at: `http://localhost:3000`

---

## 📬 API Endpoints

### 🔹 1. Single Transaction

**POST** `/api/v1/transactions/single`

**Params:**
```json
{
  "transaction_id": "abc123",
  "points": 50,
  "user_id": "user_1"
}
```

**Example:**
```bash
curl -X POST http://localhost:3000/api/v1/transactions/single   -H "Content-Type: application/json"   -d '{"transaction_id": "abc123", "points": 50, "user_id": "user_1"}'
```

---

### 🔹 2. Bulk Transactions

**POST** `/api/v1/transactions/bulk`

**Params:**
```json
{
  "transaction_id": "abc123",
  "points": 50,
  "user_id": "user_1"
}

```

**Example:**
```bash
curl -X POST http://localhost:3000/api/v1/transactions/bulk -H "Content-Type: application/json"   -d '[{"transaction_id": "abc123", "points": 50, "user_id": "user_1"}]'
```

> No body needed — transactions are fetched from the mocked external vendor.

---

## ✅ Running Tests

```bash
bundle exec rspec
```

Tests include:

- Unit tests for models and services
- Integration tests for API endpoints (with mocked external APIs)

---

## 🔄 Continuous Integration (Optional)

A GitHub Actions workflow is included in `.github/workflows/ci.yml`.

It runs tests on every push and pull request.

---

## 📁 Project Structure

```
app/
├── controllers/api/v1/transactions_controller.rb
├── models/transaction.rb
├── services/external_transaction_service.rb

spec/
├── requests/api/v1/transactions_spec.rb
├── services/external_transaction_service_spec.rb
├── models/transaction_spec.rb
├── factories/transactions.rb


.github/
├──workflows/ci.yml

```

---

## 🧪 Mocking External API

This app expects a mocked external API. You can simulate it using:

- [Mocky.io](https://www.mocky.io/)
- [JSON Server](https://github.com/typicode/json-server)
- [Beeceptor](https://beeceptor.com/)
- A dummy Rails controller if preferred

Update `ExternalTransactionService`'s `base_uri` to match your mock URL. for this procject I am using [Beeceptor](https://beeceptor.com/)

---

## 📜 License

MIT License. Happy hacking!
