# Book Manager API

A RESTful API for managing a personal book collection. Built with Ruby on Rails and the Grape API framework, this project provides essential CRUD (Create, Read, Update, Delete) operations for books and tags, along with user authentication and rate limiting for security.

## Features

- **User Authentication:**
  - Secure sign-up and sign-in using hashed passwords (bcrypt).
  - Token-based authentication for API access.
  - Authentication tokens are securely generated and stored in the database.
  - Automatic token generation and expiration for enhanced security.

- **Book Management (CRUD):**
  - Add new books with title, author, genre, and publication year.
  - Retrieve a list of all books or details of a specific book.
  - Update existing book information.
  - Delete books from the collection.

- **Tag Management:**
  - Associate multiple tags with each book.
  - Tags are created automatically if they don't exist.

- **Rate Limiting:**
  - Prevents abuse by limiting the rate of requests to the API.
  - Uses Rack::Attack with Redis for scalable and persistent rate limiting.

## Technology Stack

- **Backend:**
  - Ruby 3.3.0
  - Rails 7.1.3
  - Grape API Framework
  - bcrypt (for password hashing)
  - Rack::Attack (for rate limiting)
  - Redis (for storing rate limit counters)
- **Frontend (Not Included):**
  - This API is designed to be consumed by a separate frontend application (e.g., built with React, Vue.js, or plain JavaScript).
- **Database:**
  - PostgreSQL

## Setup Instructions

1.  **Clone the repository:**

    ```bash
    git clone [invalid URL removed]
    cd book_manager_api
    ```

2.  **Install dependencies:**

    ```bash
    bundle install
    ```

3.  **Set up the database:**

    ```bash
    rails db:create
    rails db:migrate
    ```
4. **Start redis server:**

    ```bash
    redis-server
    ```

4.  **Start the Rails server:**

    ```bash
    rails s
    ```

## API Endpoints

The API endpoints are available at `http://localhost:3000/api`. You can use a tool like Postman or Insomnia to test them. Refer to the `book_spec.rb` file for examples of how to use the API.


## Security Enhancements

- **Token-Based Authentication:** Prevents unauthorized access to the API.
- **Password Hashing (bcrypt):** Protects user passwords from being stored in plain text.
- **Rate Limiting (Rack::Attack):** Mitigates the risk of denial-of-service (DoS) attacks and abuse.
- **Input Validation:** Protects against common vulnerabilities like SQL injection and cross-site scripting (XSS).
- **Token Expiration and Cleanup:** Expired tokens are automatically cleared from the database to prevent long-term unauthorized access.

## Testing

This project includes RSpec tests for both the API endpoints and the model validations. To run the tests, execute:

```bash
rspec
