//
//  ViewController.swift
//  Shangwe-Nyota-Lab3
//
//  Created by Shangwe Nyota on 10/8/24.
//

import UIKit

class ViewController: UIViewController {
    
    // Enum to represent the behavior mode (draw, move, erase)
    enum BehaviorMode {
        case draw
        case move
        case erase
    }

    // Enum to represent the selected shape
    enum ShapeType {
        case square
        case triangle
        case circle

    }

    @IBOutlet weak var drawingCanvas: DrawingView!
    
    @IBOutlet weak var colorSelection: UISegmentedControl!
    
    @IBOutlet weak var shapeSelection: UISegmentedControl!
    
    @IBOutlet weak var behaviorSelection: UISegmentedControl!
    
    @IBOutlet var rotationGesture: UIRotationGestureRecognizer! //outlet for rotation
    
    
    @IBOutlet weak var clearButton: UIButton!
    
    @IBOutlet weak var saveButton: UIButton!
    
    var currentRotation: CGFloat = 0 // To track the total rotation of the selected shape

    @IBOutlet weak var sliderValue: UISlider! //outlet for the opacity slider
    
    @IBOutlet weak var backgroundColorButton: UIButton! //outlet for background color
    
    var currentColor: UIColor = .red // Default color
    var currentShape: ShapeType = .square // Default shape
    var currentBehavior: BehaviorMode = .draw // Default behavior mode
    var selectedShape: Shape? // This Keep track of the shape being moved
    var currentOpacity: CGFloat = 1.0 // Default opacity


    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        sliderValue.value = Float(currentOpacity) //set default value
        
        
        //EXTRA CREDIT: Adding observers to handle quick actions
        NotificationCenter.default.addObserver(self, selector: #selector(handleClearCanvasShortcut), name: NSNotification.Name("clearCanvasShangwe"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleSaveDrawingShortcut), name: NSNotification.Name("saveDrawingShangwe"), object: nil)

    }
    
    // Function to handle the "Clear Canvas" shortcut
    @objc func handleClearCanvasShortcut() {
        clearAllItems(self)
        print("Clear Canvas via Shortcut triggered")
    }

    // Function to handle the "Save Drawing" shortcut
    @objc func handleSaveDrawingShortcut() {
        saveDrawingToPhotos()
        print("Save Drawing via Shortcut triggered")
    }


    
    
    //Action for random background button changer
    @IBAction func changeBackgroundColor(_ sender: Any) {
        // Generate a random color
        //Randomc olor docs https://stackoverflow.com/questions/29779128/how-to-make-a-random-color-with-swift
        let randomColor = UIColor(
            red: CGFloat.random(in: 0...1),
            green: CGFloat.random(in: 0...1),
            blue: CGFloat.random(in: 0...1),
            alpha: 1.0
        )
        drawingCanvas.backgroundColor = randomColor // Set the background color to the random color
        print("Background color changed to: \(randomColor)")

    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        currentOpacity = CGFloat(sender.value) // Update the opacity value
        print("opacity changed")
    }
    
    
    //Clear all items from screen
    @IBAction func clearAllItems(_ sender: Any) {
        drawingCanvas.items.removeAll() // Clear the shapes array
        drawingCanvas.setNeedsDisplay() // Redraw the canvas to remove all shapes

    }
    
    
    //Shape rotation
    @IBAction func processRotation(_ sender: UIRotationGestureRecognizer) {
        guard let shape = selectedShape else { return }

        if currentBehavior == .move {
            if sender.state == .changed || sender.state == .began {
                // Update the rotation of the shape
                shape.rotate(by: sender.rotation)
                sender.rotation = 0 // Reset the gesture's rotation to avoid cumulative rotation
                drawingCanvas.setNeedsDisplay() // Redraw the canvas with the new rotation
            }
        }

    }
    
    //processes a pinch
    @IBAction func processPitch(_ sender: UIPinchGestureRecognizer) {
        
        guard let shape = selectedShape else { return } //current selected shape to pinch

        if currentBehavior == .move {
            if sender.state == .changed {  // Use 'sender' instead of 'gesture'
                // Adjust the shape's size based on the pinch scale
                shape.radius *= sender.scale
                sender.scale = 1 // Reset the scale (avoiding expontential growth)
                drawingCanvas.setNeedsDisplay() // Redraw the canvas to reflect the new size
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchPoint = touch.location(in: drawingCanvas)
        
        if currentBehavior == .draw {
            var newShape: Shape?
            
            switch currentShape {
            case .circle:
                newShape = Circle(origin: touchPoint, color: currentColor.withAlphaComponent(currentOpacity))
            case .square:
                newShape = Square(origin: touchPoint, color: currentColor.withAlphaComponent(currentOpacity))
            case .triangle:
                newShape = Triangle(origin: touchPoint, color: currentColor.withAlphaComponent(currentOpacity))
            }

            if let shapeToDraw = newShape {
                drawingCanvas.items.append(shapeToDraw)
                drawingCanvas.setNeedsDisplay()
            }
        } else if currentBehavior == .move {
            //Check if the touched point is inside a shape on the drawingCanvas
            print("Moving shape")
            if let shapeToMove = drawingCanvas.itemAtLocation(touchPoint) as? Shape {
                selectedShape = shapeToMove
            }
        } else if currentBehavior == .erase {
            // Check if the touched point is inside a shape
            if let shapeToErase = drawingCanvas.itemAtLocation(touchPoint) as? Shape {
                if let index = drawingCanvas.items.firstIndex(where: { $0 === shapeToErase }) {
                    drawingCanvas.items.remove(at: index) // Remove the shape from the canvas
                    drawingCanvas.setNeedsDisplay() // Redraw the canvas to reflect the change
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchPoint = touch.location(in: drawingCanvas)
        
        // If we're in move mode and a shape is selected, update its position
        if currentBehavior == .move, let shape = selectedShape {
            shape.origin = touchPoint // Update the shape's position
            drawingCanvas.setNeedsDisplay() // Redraw the canvas to show the moved shape
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Clear the selected shape after the move operation is finished
        selectedShape = nil
    }


    @IBAction func colorChanged(_ sender: Any) {
        switch colorSelection.selectedSegmentIndex {
        case 0:
            currentColor = .red
        case 1:
            currentColor = .orange
        case 2:
            currentColor = .yellow
        case 3:
            currentColor = .green
        case 4:
            currentColor = .blue
        case 5:
            currentColor = .purple
        default:
            currentColor = .red
        }
        print("Color changed to: \(currentColor)")
    }
    
    
    @IBAction func shapeChanged(_ sender: Any) {
        switch shapeSelection.selectedSegmentIndex {
        case 0:
            currentShape = .square
        case 1:
            currentShape = .triangle
        case 2:
            currentShape = .circle
        default:
            currentShape = .square
        }
        print("Shape changed to: \(currentShape)")

    }
    
    
    @IBAction func behaviorChanged(_ sender: Any) {
        switch behaviorSelection.selectedSegmentIndex {
        case 0:
            currentBehavior = .draw
        case 1:
            currentBehavior = .move
        case 2:
            currentBehavior = .erase
        default:
            currentBehavior = .draw
        }
        print("Behavior changed to: \(currentBehavior)")

    }
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        print("save button pressed")
        saveDrawingToPhotos()
    }
    // Function to convert the drawingCanvas (DrawingView) to an image
    //Docs for graphics image renderreor https://developer.apple.com/documentation/uikit/uigraphicsimagerenderer
    func saveDrawingToPhotos() {
        // Convert the drawingCanvas (DrawingView) to an image
        let renderer = UIGraphicsImageRenderer(bounds: drawingCanvas.bounds)
        let image = renderer.image { (context) in
            drawingCanvas.layer.render(in: context.cgContext)
        }
        
        // Save the image to the photo library
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        // Show a confirmation to user that the drawing is saved
        let alert = UIAlertController(title: "Saved", message: "Your drawing has been saved to the Photos library.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }


    
}

