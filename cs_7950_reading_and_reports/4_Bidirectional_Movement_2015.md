This is a summary of "Visual Analysis of Bi-directional Movement Behavior" by Zheng et al. [1]. The paper is available at http://ieeexplore.ieee.org.dist.lib.usu.edu/xpl/articleDetails.jsp?arnumber=7363802. The source code for the authors' implementation does not appear to readily available.

This paper presents a method of analyzing and visualizing movement in two directions. Our initial interpretation of "compare movements in two direction simultaneously" was incorrect. The word "simultaneously" applies to "compare", not to "movement". Thus, the challenge is to analyze movement from point A to point B, at the same time as analyzing movement from B to A. The larger challenge is simultaneously visualize the analysis results. How should a system present motion in two directions at the same time?

It seems pretty clear that the authors assume the users are not color blind. The visualization methods rely on color variation. Using the wrong colors in such a situation would render the visualizations difficult, if not impossible, for a color blind person to use. There is no indication that the colors can be configured by the user. That, however, is an implementation detail. They also seem to assume that the data sets are not too dense. Too many routes between A and B would clutter the OD-Pair Flow view, and too many travellers on a route would clutter the Isotime Storyline view. Too much clutter makes the graphs useless.

The authors present two case studies to demonstrate their method: taxi driving in Shanghai, China; and turkey vulture migration in North America. There is no clear source of the taxi data. I think the turkey vulture data was retrieved from https://www.datarepository.movebank.org/. The authors cite this URL, but it appears to require an account to retrieve data.

The authors divide their method into two phases: data modelling, and visual analysis. The data modelling phase is not necessarily performed in real-time, but is required for interactive visual analysis. The data modelling phase contains three broad steps:

1. Construct a model of the movement data,
1. Define a degree-of-interest (DoI) function,
1. Extract key nodes from the graph produced by step 1.

The movement model is a graph of the data. Vertices are a set of Voronoi cells, each of which contains "characteristic points" of the source trajectory data. The graph's edges connect vertices for which a trajectory exists; each edge has a weight representing the geographic distance between the vertices. The DoI function is used to identify behavioral patterns between an origin-destination pair (OD-pair). It allows a user to specify the route nodes of interest. The defined function is used in the next step. Key node extraction is an attempt to highlight the important details of a route, thus reducing clutter in the visual analysis. The key node extraction results in a subgraph of step 1, using the DoI function to identify the vertices of interest to the user. This subgraph is then used for visual analysis. The visual analysis step uses three visualizations of the model. The user is presented with a heat map showing areas of dense movement. The user can select a point of interest, and circles are placed over the heat map. The circles represent locations of other graph vertices which connect to the user's selected point. Selecting one of the circles is effectively selecting a route, and view changes to the OD-Pair Flow view. For each route between the two points, this view presents the following information to the user: route length, average time, time variance, route popularity, key nodes along the route. This information is presented for the direction A to B, and B to A. Selecting a route presents the Isotime Storyline view. This graph presents route information for each traveller on the route: time at each key node, speed, average time to each key node for all the travellers. The three visualization methods start from a broad overview, and allow the users to drill down to the details.

The authors' methodology is not compared to other methods of solving the problem. The authors did present their implementation to three domain experts. The experts used the application and provided feedback. For the most part, the feedback was positive; one improvement suggestion was provided. Though subjective, user feedback is generally considered important in software development.

The authors' OD-Pair Flow and Isotime Storyline views both have problems with scalability; large enough data sets will clutter the views, hindering rather than helping visual analysis. Key nodes are visualized using colors, which limits the number of key nodes which can be displayed. The DoI function only considers three aspects of the data. More aspects may be required for other applications of this method.

The OD-Pair Flow and Isotime Storyline views are quite compelling. The way the data are plotted, combining multiple graphs in one display, is pretty clear. I can immediately think of a few improvements, but they're fairly trivial (Z ordering of the OD-Pair Flow key nodes, for example). Overcoming the clutter due to larger data sets seems the most important problem, and would require more thought & investigation.

This method could be applied to any concept which travels: network traffic, air traffic (are some air lanes overcrowded?), disease & outbreak propagation, etc.

1. Y. Zheng et al., "Visual analysis of bi-directional movement behavior," *Big Data (Big Data), 2015 IEEE International Conference on*, Santa Clara, CA, 2015, pp. 581-590. doi: 10.1109/BigData.2015.7363802

---

- [x] The source of the paper using the IEEE reference style (Authors, Paper Title, Journal/Conference Name, Volume Number, Page Number, and Year).
- [x] The URL of the paper and source code if applicable.
- [x] The problem to be solved. Why is the investigated problem interesting?
- [x] The assumptions made by the authors. Explain how the authors use these assumptions in their solution. **What is your prediction on the final results without these assumption?**
- [x] Provide the URL of the source of the data set if mentioned in the paper. If no URL is provided, please indicate a URL to your knowledge for downloading similar data sets.
- [x] The algorithmic overview (i.e. pseudo-code) of the approach proposed in the paper. Please do not copy all the formulas from the paper. Pick out several important formulas for the important steps and **summarize each formula listed in your report in your one sentences.**
- [x] The results compare to others. Qualitatively, what kind of plots or figures are used for comparison? Quantitatively, what kind of performance metric(s) and/or statistical tests are used for comparison?
- [x] Shortcomings of the approach and future improvement **mentioned in the paper.**
- [x] Your evaluation of the paper in terms of the **technical novelty, computational complexity,** and **experimental results.**
- [x] Your suggestions about the possible improvement to solve the problem. **Based on your suggestions, can any assumption be eliminated?**
- [x] Your thoughts about applying the proposed techniques to other applications.
