# Architecture

### Rules

<p>
  <img src="https://github.com/arthursobrosa/Education/blob/architecture/README-images/architecture.png" width="500" alt="Architecture image">
</p>

#### - ViewModel does bussiness logics only and is connected to ViewController via a binding Box;
#### - ViewController is injected with a ViewModel and controls any delegate methods from the View;
#### - View is used exclusively to create visual stuff;
#### - View contains a delegate to connect itself to the ViewController;

<p>
  <a href="https://github.com/arthursobrosa/Architecture">Example project</a> with this architecture implemented
</p>

---

### Box

<p>
  <img src="https://github.com/arthursobrosa/Education/blob/architecture/README-images/Box.png" width="400" alt="Box example image">
</p>

#### - A Box is a class that receives a generic type variable as its value. When the value is changed, the box will trigger a closure with this value as the argument;
#### - This class will be used to connect properties from a ViewModel to a ViewController;

---

### ViewCode protocol

<p>
  <img src="https://github.com/arthursobrosa/Education/blob/architecture/README-images/ViewCodeProtocol.png" width="500" alt="ViewCode protocol example image">
</p>

#### - This protocol will be used when setting up the layout of a view;
#### - We can create an extension to a view and subscribe this extension to the ViewCodeProtocol. By doing so, the View will automatically contain a setupUI() method;

---

### Delegate

<p>
  <img src="https://github.com/arthursobrosa/Education/blob/architecture/README-images/ViewControllerDelegate.png" width="500" alt="Delegate example image">
</p>

#### - Delegates will be used to connect a ViewController with a View;
#### - Since a View cannot contain any business logics, it will delegate any non-visual stuff to a ViewController;

---

## MVVM example

### ViewModel

<p>
  <img src="https://github.com/arthursobrosa/Education/blob/architecture/README-images/ViewModel.png" width="400" alt="ViewModel example image">
</p>

#### - The ViewModel will be responsible for any business logics, as seen in the method example above (changeText());
#### - The boxes are created within a ViewModel and are used to keep track of a property's state (just like a @Published property in SwiftUI);

---

### ViewController

<p>
  <img src="https://github.com/arthursobrosa/Education/blob/architecture/README-images/ViewController1.png" width="600" alt="ViewController example 1 image">
</p>

<p>
  <img src="https://github.com/arthursobrosa/Education/blob/architecture/README-images/ViewController2.png" width="600" alt="ViewController example 2 image">
</p>

#### - ViewController has an instance of ViewModel (let viewModel: ViewModel) and sets its value from the initializer;
#### - ViewController also has an instance of View (lazy var myView: View) and sets its delegate inside the closure initializer (myView.delegate = self);
#### - (Make sure the ViewController conforms to the correct delegate protocol);
#### - Inside loadView() method, the ViewController's view is set equal to myView. That automatically makes myView fit perfectly inside the ViewController (no need to set any constraints);
#### - Inside viewDidLoad() method, we create the connection between ViewController and ViewModel by providing an implementation to the closure present inside the ViewModel's box property;
#### - Inside viewWillAppear() method, we change an information inside myView;

---

### View

<p>
  <img src="https://github.com/arthursobrosa/Education/blob/architecture/README-images/View1.png" width="800" alt="View example 1 image">
</p>

<p>
  <img src="https://github.com/arthursobrosa/Education/blob/architecture/README-images/View2.png" width="1000" alt="View example 2 image">
</p>

#### - View has an instance of the ViewController delegate and that's how they are connected to each other;
#### - View contains two subviews (properties), a label (myLabel) and a button (myButton);
#### - setupUI() method is called within View's initializer to set its layout;
#### - View contains a method that serves as the target for when myButton is tapped (@objc onTapMyButton());
#### - When the button is tapped, the View calls its delegate and some logics will be performed by the ViewController. In that case, myLabel's text will be updated;






  
