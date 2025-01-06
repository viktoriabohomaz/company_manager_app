# Company Manager API

This project is an API-only Rails application designed to manage companies and their addresses

---

## Table of Contents

- [Features](#features)
- [Project Setup](#project-setup)
- [Endpoints](#endpoints)

---

## Features

1. **Create a Company with Multiple Addresses**
2. **Bulk Import Companies via CSV**
   - Parse CSV files with multiple rows, supporting multiple addresses for a single company
   - Validate uniqueness of `registration_number` and required fields.
   - Handle errors 

---

## Project Setup

- **Ruby**: 3.3
- **Rails**: 8.0
- **Testing Framework**: RSpec

To get started:
1. Clone the repository.
2. Run `bundle install` to install dependencies.
3. Setup the database: `rails db:create db:migrate`.
4. Run tests: `bundle exec rspec`

---

## Endpoints

### **1. GET /api/v1/companies**
- Fetches all companies and their addresses.

### **2. POST /api/v1/companies**
- Creates a new company with multiple addresses.

### **3. POST /api/v1/companies/import**
- Imports companies and addresses from a CSV file.

### **4. GET /api/v1/companies/:id**
- Fetches a specific company and its addresses by ID.

