Phase I - 2016 November 26
---

I have completed the first draft of the presentation slides.

I have implemented the SIFT algorithm used by the authors of the paper. I wrote
a function which runs an image through VLFeat's SIFT function. It then dilates
and erodes the image to generate the additional key point descriptor information
described in the paper.

I have also implemented training the key point classification SVM. The trained
SVM is saved to disk so it can be reused.

Finally, I've implemented key point extraction and classification from a test
image, using the trained SVM.

The data I'm using is from
https://www.sensefly.com/drones/example-datasets.html. The data set is
*Horizontal mapping with Canon G9X RGB*. *IMG_0109.JPG* is the image used to
train the key point classification SVM. *IMG_0086.JPG* is the initial image
used to test the car counting procedure.
