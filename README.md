# Book Manager API

A RESTful API for managing a personal book collection. Built with Ruby on Rails and the Grape API framework, this project provides essential CRUD (Create, Read, Update, Delete) operations for books and tags, along with user authentication and rate limiting for security.

## Features

- **User Authentication:**
  - Secure sign-up and sign-in using hashed passwords (bcrypt).
  - Token-based authentication for API access.
  - Authentication tokens are securely generated and stored in the database.

- **Book Management (CRUD):**
  - Add new books with title, author, genre, publication year, and tags.
  - Retrieve a list of all books or details of a specific book.
  - Update existing book information, including tags.
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
- **Frontend:**
  - Plain JavaScript (HTML, CSS, and JS files located in the `public` folder)
- **Database:**
  - PostgreSQL
-  **Development and Testing:**
   - RSpec
     - **Testing framework** for behavior-driven development (BDD) to ensure the correctness of the application logic.
   - FactoryBot
     - **Provides a convenient way to create test data** for models, making tests easier to write and maintain.
   - Faker
     - **Generates realistic fake data** for testing purposes, such as random names, email and book titles.
   - rack-test
     - **Simulates HTTP requests in your tests**, allow to test Rack application without needing a web browser.
   - shoulda-matchers
     - **Simplifies the testing of common Rails model validations** with easy-to-use matchers like `validate_presence_of`.

## Setup Instructions

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/kantaphonken/book_manager_api
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

4.  **Start Redis server:** (If you haven't installed Redis yet, install it first)

    ```bash
    redis-server
    ```

5.  **Start the Rails server:**

    ```bash
    rails s
    ```

6.  **Access the frontend:**
    *   Open `public/index.html` in your browser (e.g., `http://localhost:3000`)

## API Endpoints

The API endpoints are available at `http://localhost:3000/api`. You can use a tool like Postman or Insomnia to test them. Refer to the `book_spec.rb` file for examples of how to use the API.


## Security Enhancements

- **Token-Based Authentication:** Prevents unauthorized access to the API.
- **Password Hashing (bcrypt):** Protects user passwords from being stored in plain text.
- **Rate Limiting (Rack::Attack):** Mitigates the risk of denial-of-service (DoS) attacks and abuse.
- **Input Validation:** Protects against common vulnerabilities like SQL injection and cross-site scripting (XSS).
- **Token Expiration:** Tokens expire after 24 hours to enhance security.
- **Manual Token Cleanup:** A rake task is provided to manually clear expired tokens from the database:

> **Note:** While automatic token cleanup (e.g., using a scheduled job) is not implemented in this version, you can periodically run the following rake task to remove expired tokens:

```bash
rake auth:expired_token_cleanup
```

## Testing

This project includes RSpec tests for the API endpoints, model validations, and Rack Attack rate limiting. To run the tests, execute:

```bash
rspec
```
## API Endpoints

| Endpoint             | Method | Description                       | Requires Authentication | Rate Limited (CRUD) |
|----------------------|--------|-----------------------------------|--------------------------|---------------------|
| `/api/users`        | POST   | Create a new user                 | No                      | No                  |
| `/api/users/sign_in` | POST   | Sign in an existing user           | No                      | No                  |
| `/api/users/sign_out`| DELETE | Sign out the current user        | Yes                     | No                  |
| `/api/books`        | GET    | Get a list of all books            | Yes                     | No                  |
| `/api/books/:id`    | GET    | Get details of a specific book     | Yes                     | No                  |
| `/api/books`        | POST   | Create a new book                 | Yes                     | Yes                 |
| `/api/books/:id`    | PUT    | Update an existing book           | Yes                     | Yes                 |
| `/api/books/:id`    | DELETE | Delete a book                     | Yes                     | Yes                 |
| `/api/tags`         | GET    | Get a list of all tags or find/create by name. (Use query param `?name=tagname`)| Yes                     | No                  |

## Sample cURL Commands

```bash
# Sign Up (POST /api/users)
curl -X POST http://localhost:3000/api/users -H 'Content-Type: application/json' -d '{"email": "user@example.com", "password": "password", "password_confirmation": "password"}'

# Sign In (POST /api/users/sign_in)
curl -X POST http://localhost:3000/api/users/sign_in -H 'Content-Type: application/json' -d '{"email": "user@example.com", "password": "password"}'

# Sign Out (DELETE /api/users/sign_out)
curl -X DELETE http://localhost:3000/api/users/sign_out -H 'Authorization: Bearer <your_authentication_token>'

# Get All Books (GET /api/books)
curl -X GET http://localhost:3000/api/books -H 'Authorization: Bearer <your_authentication_token>'

# Get a Specific Book (GET /api/books/:id)
curl -X GET http://localhost:3000/api/books/1 -H 'Authorization: Bearer <your_authentication_token>'

# Create a Book (POST /api/books)
curl -X POST http://localhost:3000/api/books -H 'Content-Type: application/json' -H 'Authorization: Bearer <your_authentication_token>' -d '{"title": "The Hitchhiker's Guide to the Galaxy", "author": "Douglas Adams", "genre": "Science Fiction", "publication_year": 1979, "tags": ["Sci-Fi", "Humor"]}'

# Update a Book (PUT /api/books/:id)
curl -X PUT http://localhost:3000/api/books/1 -H 'Content-Type: application/json' -H 'Authorization: Bearer <your_authentication_token>' -d '{"title": "The Restaurant at the End of the Universe", "author": "Douglas Adams", "genre": "Science Fiction", "publication_year": 1980}'

# Delete a Book (DELETE /api/books/:id)
curl -X DELETE http://localhost:3000/api/books/1 -H 'Authorization: Bearer <your_authentication_token>'
```
