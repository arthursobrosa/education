# Education

## Architecture 

<p>
  <a href="https://github.com/arthursobrosa/Architecture">Example project</a> with architecture implemented
</p>

---

### Box

<p>
  <img src="https://github.com/arthursobrosa/Education/blob/architecture/README-images/Box.png" width="400" alt="Box example image">
</p>

#### A Box is a class that receives a generic type variable as its value. When the value is changed, the box will trigger a closure with this value as the argument.
#### This class will be used to connect properties from a ViewModel to a ViewController.

---

### ViewCode protocol

<p>
  <img src="https://github.com/arthursobrosa/Education/blob/architecture/README-images/ViewCodeProtocol.png" width="400" alt="ViewCode protocol example image">
</p>

#### This protocol will be used when setting up the layout of a view.
#### We can create an extension to View, for instance, and conform this extension to the ViewCodeProtocol. By doing so, the View will automatically contain a setupUI() method.

---

### Delegate

<p>
  <img src="https://github.com/arthursobrosa/Education/blob/architecture/README-images/ViewControllerDelegate.png" width="400" alt="Delegate example image">
</p>

#### Delegates will be used to connect a ViewController with a View.
#### Since a View cannot contain any business logics, it will delegate any non-visual stuff to a ViewController.

---

## MVVM example

### ViewModel

<p>
  <img src="https://github.com/arthursobrosa/Education/blob/architecture/README-images/ViewModel.png" width="400" alt="ViewCode protocol example image">
</p>

#### The ViewModel will be responsible for any business logics, as seen in its method example (changeText()).
#### The boxes are created within a ViewModel and are used to keep track of a property's state (just like a @Published property in SwiftUI).
  
