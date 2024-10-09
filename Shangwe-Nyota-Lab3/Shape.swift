//
//  Shape.swift
//  CSE 438S Lab 3
//
//  Created by Michael Ginn on 5/31/21.
//

import UIKit

/**
 YOU SHOULD MODIFY THIS FILE.
 
 Feel free to implement it however you want, adding properties, methods, etc. Your different shapes might be subclasses of this class, or you could store information in this class about which type of shape it is. Remember that you are partially graded based on object-oriented design. You may ask TAs for an assessment of your implementation.
 */

/// A `DrawingItem` that draws some shape to the screen.
class Shape: DrawingItem {
    var origin: CGPoint
    var color: UIColor
    var radius: CGFloat
    var path: UIBezierPath
    var rotationAngle: CGFloat = 0 // Track the current rotation of the shape
    
    public required init(origin: CGPoint, color: UIColor){
        self.origin = origin
        self.color = color
        self.radius = 50 //default radius, will change on user actions
        self.path = UIBezierPath()
    }

    // Rotate the shape by a given angle
    func rotate(by angle: CGFloat) {
        self.rotationAngle += angle
    }
    
    // Apply the rotation transformation to the shape's path
    func applyRotation(to path: UIBezierPath) {
        let transform = CGAffineTransform(translationX: origin.x, y: origin.y)
            .rotated(by: rotationAngle)
            .translatedBy(x: -origin.x, y: -origin.y)
        path.apply(transform)
    }

    func draw() {
        fatalError("This method should be overridden by subclasses")
    }

    func contains(point: CGPoint) -> Bool {
        return path.contains(point)
    }
}


class Circle: Shape {
    override func draw() {
        self.path = UIBezierPath(arcCenter: origin, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        
        // Apply the rotation transformation
        applyRotation(to: path)
        
        color.setFill()
        path.fill()
    }
}

class Square: Shape {
    override func draw() {
        self.path = UIBezierPath(rect: CGRect(x: origin.x - radius / 2, y: origin.y - radius / 2, width: radius, height: radius))
        
        // Apply the rotation transformation
        applyRotation(to: path)
        
        color.setFill()
        path.fill()
    }
}

class Triangle: Shape {
    override func draw() {
        let path = UIBezierPath()
        
        // The origin represents the center of the triangle
        let height = (sqrt(3) / 2) * radius // Height of an equilateral triangle
        
        // Define the three points of the triangle relative to the origin
        path.move(to: CGPoint(x: origin.x, y: origin.y - radius / 2)) // Top point
        path.addLine(to: CGPoint(x: origin.x + radius / 2, y: origin.y + height / 2)) // Bottom right
        path.addLine(to: CGPoint(x: origin.x - radius / 2, y: origin.y + height / 2)) // Bottom left
        path.close()
        
        // Apply the rotation transformation
        applyRotation(to: path)
        
        color.setFill()
        self.path = path // Assign to the instance's path
        path.fill()
    }
}
