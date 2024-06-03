# Architectural Choices
MVC (Model-View-Controller) Pattern
The application follows the MVC architectural pattern, which separates the application into three interconnected components:

- Model: Represents the data structure and business logic. It manages the data, including fetching from the API and storing it in local storage.
- View: The UI components that display the data. It includes the screens and widgets that the user interacts with.
- Controller: Acts as an intermediary between the Model and the View. It handles user inputs, processes them, and updates the View with data from the Model.
  This separation of concerns enhances maintainability, scalability, and testability of the application.

# Third-Party Libraries
The application uses several third-party libraries to implement its features:

- get: For getx state management.
- connectivity_plus: For check the network connectivity.
- dio:For making API calls.
- sqflite: For storing and retrieving data locally.
- get_storage: For simple key-value storage.
- get_it: For service locator.


# Running the Application
Follow these steps to run the application:

## Clone the Repository:

```bash
  git clone https://github.com/KhilanVitthani/knovator_task.git
```

## Install Dependencies

```bash
  flutter pub get
```
## Run the Application:

```bash
  flutter run
```
