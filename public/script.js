
// Initial setup
const books = {};
const loginForm = document.getElementById('loginForm');
const signupForm = document.getElementById('signupForm');
const bookApp = document.getElementById('bookApp');
const toggleFormButton = document.getElementById('toggleFormButton');
const bookList = document.getElementById('bookList');
const bookFormContainer = document.getElementById('bookForm');
const apiError = document.getElementById('apiError');

// Helper function to update the UI after login/logout
function updateUI() {
  const authToken = localStorage.getItem('authToken');

  loginForm.style.display = authToken ? 'none' : 'block';
  signupForm.style.display = authToken ? 'none' : 'none';
  bookApp.style.display = authToken ? 'block' : 'none';
  toggleFormButton.style.display = authToken ? 'none' : 'block';
}

// Function to handle login
async function login() {
  const email = document.getElementById('email').value;
  const password = document.getElementById('password').value;
  const response = await fetch('/api/users/sign_in', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ email, password })
  });

  if (response.ok) {
    const data = await response.json();
    localStorage.setItem('authToken', response.headers.get('Authorization'));
    getBooks();
    updateUI();
  } else {
    const errorData = await response.json();
    document.getElementById('loginError').textContent = errorData.message || 'Login failed';
  }
}

// Function to handle signup
async function signup() {
  const email = document.getElementById('signupEmail').value;
  const password = document.getElementById('signupPassword').value;
  const passwordConfirmation = document.getElementById('signupPasswordConfirmation').value;
  const response = await fetch('/api/users', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ email, password, password_confirmation: passwordConfirmation })
  });

  if (response.ok) {
    alert('Sign-up successful! Please log in.');
    updateUI();
  } else {
    const errorData = await response.json();
    document.getElementById('signupError').textContent = errorData.message || 'Sign-up failed';
  }
}

// Function to handle logout
async function logout() {
  const authToken = localStorage.getItem('authToken');
  const response = await fetch('/api/users/sign_out', {
    method: 'DELETE',
    headers: { 'Authorization': authToken }
  });

  if (response.ok) {
    localStorage.removeItem('authToken');
    updateUI();
  } else {
    // handleError(response);
  }
}

// Function to fetch and display books
async function getBooks() {
  const bookList = document.getElementById('bookList');
  bookList.innerHTML = '';

  try {
    const response = await fetch("/api/books", {
      headers: { 'Authorization': localStorage.getItem('authToken') }
    });

    if (response.ok) {

      const fetchedBooks = await response.json();

      if (fetchedBooks.length === 0) {
        // Handle empty book list (optional)
        const listItem = document.createElement('li');
        listItem.textContent = "No books found.";
        bookList.appendChild(listItem);
      } else {
        fetchedBooks.forEach(book => {
          books[book.id] = book;
          displayBook(book);
        });
      }
    } else {
      handleError(response);
    }
  } catch (error) {
    handleError(error);
  }
}


function displayBook(book) {
  const bookList = document.getElementById('bookList');
  const listItem = document.createElement('li');

  // Display each book with its details
  listItem.innerHTML = `
    <strong>Title:</strong> ${book.title}<br>
    <strong>Author:</strong> ${book.author}<br>
    <strong>Genre:</strong> ${book.genre}<br>
    <strong>Year:</strong> ${book.publication_year}<br>
    <strong>Tags:</strong> <span class="math-inline">${book.tags.map(t => t.name).join(', ')}<br\>
    <button onclick="showEditForm(${book.id})">Edit</button>
    <button onclick="deleteBook(${book.id})">Delete</button>
  `;
  bookList.appendChild(listItem);
}

// Function to show the add/edit book form
function showEditForm(bookId = null) {
  const bookForm = document.getElementById('bookForm');
  const bookToEdit = books[bookId];
  bookForm.innerHTML = `
    <h2>${bookToEdit ? 'Edit Book' : 'Add New Book'}</h2>
    <form id="bookFormData">
      <input type="hidden" id="bookId" name="id" value="${bookToEdit ? bookToEdit.id : ''}">
      <div>
        <label for="title">Title:</label>
        <input type="text" id="title" name="title" value="${bookToEdit ? bookToEdit.title : ''}"><br>
      </div>
      <div>
        <label for="author">Author:</label>
        <input type="text" id="author" name="author" value="${bookToEdit ? bookToEdit.author : ''}"><br>
      </div>
      <div>
        <label for="genre">Genre:</label>
        <input type="text" id="genre" name="genre" value="${bookToEdit ? bookToEdit.genre : ''}"><br>
      </div>
      <div>
        <label for="publication_year">Publication Year:</label>
        <input type="number" id="publication_year" name="publication_year" value="${bookToEdit ? bookToEdit.publication_year : ''}"><br>
      </div>
      <div
        <label for="tags">Tags:</label>
        <input type="string" id="tags" name="tags" value="${bookToEdit && bookToEdit.tags  ? bookToEdit.tags.map(t => t.name).join(', '): ''}"><br>

      </div>
      <button type="submit">${bookToEdit ? 'Update Book' : 'Add Book'}</button>
    </form>
  `;

  // Attach event listener to the dynamically created form
  bookForm.querySelector('form').addEventListener('submit', (event) => handleFormSubmit(event, bookToEdit));
}

// Function to handle form submission (add or edit)
async function handleFormSubmit(event, book) {
  event.preventDefault();
  const formData = new FormData(event.target);

  const method = book ? 'PUT' : 'POST';
  const url = book ? `/api/books/${book.id}` : "/api/books";
  const authToken = localStorage.getItem('authToken');

  // Input validation
  const title = formData.get('title').trim();
  const author = formData.get('author').trim();

  if (!title || !author) {
    alert('Please fill in all required fields (Title, Author).');
    return;
  }

  const publicationYear = parseInt(formData.get('publication_year')) || null;
  const tagNames = formData.get('tags').split(',').map(tag => tag.trim()).filter(tag => tag !== '');
  const genre = formData.get('genre').trim();

  try {
    const response = await fetch(url, {
      method: method,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': authToken
      },
      body: JSON.stringify({
        title,
        author,
        genre,
        publication_year: publicationYear,
        tags: tagNames // Include tag names in the request
      })
    });

    if (response.ok) {
      getBooks();
      showEditForm(); // Clear the form after submission
    } else {
      handleError(response);
    }
  } catch (error) {
    handleError(error);
  }
}

// Function to delete a book
async function deleteBook(bookId) {
  try {
    const response = await fetch(`/api/books/${bookId}`, {
      method: 'DELETE',
      headers: { 'Authorization': localStorage.getItem('authToken') }
    });

    if (response.ok) {
      getBooks();
    } else {
      handleError(response);
    }
  } catch (error) {
    handleError(error);
  }
}

// Helper function to handle errors
async function handleError(error) {
  if (error.response) {
    const errorData = await error.response.json();
    if (error.response.status === 429) { // Check for rate limit error
      alert(errorData.message);
    } else {
      const errorData = await error.response.json();
      alert(errorData.message || 'An error occurred.');
    }

  } else {
    console.error('Error:', error);
    alert('An error occurred. Please check the console for details.');
  }
}

document.addEventListener('DOMContentLoaded', () => {
  updateUI();
  toggleFormButton.addEventListener('click', toggleForm);
  document.getElementById('bookFormData').addEventListener('submit', handleFormSubmit); // add an eventlistener for the form submit
});
