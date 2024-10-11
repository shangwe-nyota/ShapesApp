Shapes App

Creative:
Creative Feature 1: Saving the Current Drawing to the Photos Library
I added a feature to save the current drawing to the user’s photo library. This functionality captures only the drawing without any UI controls, allowing for a clean save of the artwork. To do this, I used the UIGraphicsImageRenderer class to render the drawingCanvas into an image and saved it to the photo library using UIImageWriteToSavedPhotosAlbum(). I also made sure to request the necessary permissions in Info.plist for accessing the photo library. The effor required for this was very high as this required more work than basic drawing functionalities because it involved learning how to use UIGraphicsImageRenderer and managing the app’s permissions properly. This feature allows users to keep a permanent record of their drawings to the photos, which enhances the app’s utility beyond simple functionality.And its meaningful because saving artwork to the photo library gives the app a practical use. Users can save and share their creations with others.

Creative Feature 2:Change Opacity of shapes
I implemented a feature that allows users to control the opacity of the shapes they draw on the canvas. Users can adjust a slider to change the transparency of the shape, providing more artistic flexibility. I accomplished this by adding a UISlider element, which updates the currentOpacity value. Before drawing a shape, I set the color’s alpha component using .withAlphaComponent() to match the opacity selected by the user. The effort required was also high because I needed to ensure the slider interacted properly with the color values and that the opacity changes were reflected dynamically in the drawn shapes. I had to learn about the slider component and adjusting the rgb opacity based on it. This feature enhances the app’s functionality by adding more creative control, allowing users to blend shapes together and create layered effects. It's a meaningful improvement because it opens up new artistic posibilites as users can now make more advanced designs and appear to stack different shapes and colors!

Creative Feature 3: Change background image
For the background color changer, I added a button that, when pressed, randomly changes the canvas’s background color. This adds some fun randomness to the app and allows users to have a different background for each drawing session. To implement this, I used CGFloat.random(in: 0...1) to generate random RGB values and applied the result to the drawingCanvas.backgroundColor. The effort for this was also substatnial as i had to add new functionality to the app such as randomness and a new button and also had to do additionalling testing for potential issues that would come as a result of the randomness. This feature is meaningful because it adds variety to the canvas, allowing users to experiment with different background colors, which can inspire creativity and change the overall feel of their artwork.

Creative Feautre 4: Resizing shapes
I also added two buttons that allow users to resize their shapes directly by increasing or decreasing their size. This feature provides more control over the shapes’ dimensions and makes resizing more intuitive for users. I implemented it by creating two buttons, each linked to functions that either multiply or divide the current shape's radius, then update the canvas with the resized shape. The effort involved in implementing this was also high because it required adding logic to ensure the resizing applied only to shapse existing on the canvas. This feature is meaningful because it offers a practical way to modify the size of shapes after they’ve been drawn, improving the overall user experience and giving users greater flexibility to fine-tune their designs. This is also menaingful as the standard pinch gesture can be default to use especially those with disabilities so this gives a higher rate of accessiblity to make the app more inclusive to tohers! Also the pinch gesture only works for indvidual items wheraas this gesture works for all items on the screen which I think is nice to save time if you want to make some tweaks to the overall app.














Change image opacity

Extra Credit:
Implement at least two Home Screen Actions for your app. See the image below for
an example. (Completed)

