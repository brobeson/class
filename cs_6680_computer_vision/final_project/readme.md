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

Phase II - 2016 December 3
---

### Changes to Phase I Work

I modified my SIFT wrapper to set the edge threshold when running vl_sift(). I
tried setting the peak threshold as well, but any value I tried returned 0 key
points.

I made minor improvements to the functions implemented in phase I. These are
basic software engineering & efficiency improvements.

I attempted to tweak the SVM training as described in the paper. I haven't been
able to correlate the math symbols used in the paper with the SVM training
function options in Matlab, though.

### New Functionality Implemented in Phase II

I implemented training the asphalt segmentation SVM. As with the key point
classification SVM, the asphalt SVM is saved so it doesn't need to be executed
multiple times.

I implemented the key point reduction algorithm. This is the step which removes
key points in the background, keeping only those in the asphalt segments.

I implemented the key point merging algorithm. I also wrote a small unit test to
verify the algorithm.

I've updated my main script to run all the steps. It generates a number of
figures showing intermediate results: asphalt segmentation, extracted key
points, classified key points, etc.

