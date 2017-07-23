This is a summary of "A Novel Visualization Method of Power Transmission Lines, by Pei et al. [1]. The paper is available at http://ieeexplore.ieee.org.dist.lib.usu.edu/xpl/articleDetails.jsp?arnumber=7153914. The source code for the authors' implementation does not appear to be readily available.

The authors present a new method of visualizing power line connections between electrical system nodes. Current methods must sacrifice geospatial information in order to reduce clutter and make the visualization easier for a person to comprehend. The authors' approach reduces the amount of geospatial distortion, while clearing up the graph visualization.

The authors' only assumption seems to be the size of the data set. I don't thing this visualization method would work well with a large data set.

The authors do not provide a URL for their data source. They do specify that the data is of power transmission lines for Zhangjiajie City, China. It appears that similar data for the United States is available from the U.S. Energy Information Administration (EIA) at https://www.eia.gov/tools/faqs/faq.cfm?id=567&t=3.

The algorithm involves three broad steps: node clustering, node plotting, and edge plotting. Clustering involves selecting a suitable central node; the authors used the dispatch center node. The remaining nodes were grouped into concentric rings around the center node based on their radii. The nodes are plotted in the graph with consistent radius from the center node. For example, all nodes in cluster 1 are plotted *r* units from the center node, all nodes in cluster 2 are plotted *2r* units from the center node, etc. On each ring, all nodes are then separated from neighboring nodes by at least *a* degrees of arc. Finally, edges are plotted between adjacent nodes in a way to minimize overlapping lines. Nodes on the same ring are connected with a curve along the ring. If two arcs would overlap, one is translated to reduce the overlap. Edges between nodes on separate rings are drawn with a combination of a straight line from ring to ring, and an arc along a ring. If the angular difference between the two nodes is less than a set value *B*, then a straight line is simply drawn between the two nodes. Otherwise, a straight line is drawn from the inner node to a point *d* on the outer ring. The angular difference between *d* and the inner node is less than *B*. Then an arc is drawn along the outer ring from *d* to the outer node. This prevents straight lines from crossing the graph, which would add clutter.

The authors do not compare their results to other attempts at solving this problem. They do provide naive visualizations of the same data, maintaining geospatial data at the cost of unbalanced and cluttered graphs. It's clear that the new visualization is an improvement. The authors provide no other way of evaluating their visualization.

The authors do not acknowledge any shortcomings. 

The visualization presented in this paper is interesting and is better than previous work, but I don't think it completely accomplishes the goals. The geospatial relationships are still distorted by this approach, though the distortion is small in the examples provided. In addition, the graphs can still be cluttered. Figure 4b in the paper has such a situation; three edges connect to node 10, and another edge passes in close proximity.

The cluttering that I mentioned (an edge passing near a node) could be solved by comparing the angle to the outer node with the angles the nodes on rings between the origin and destination rings. Nodes could be adjusted if their angular difference is too small.

I think this technique is best for sparse data sets, which need to be presented in a confined visualization space. Long distance rail stations would be an example.

1. S. Pei et al., "A Novel Visualization Method of Power Transmission Lines," *Multimedia Big Data (BigMM)*, 2015 IEEE International Conference on, Beijing, 2015, pp. 358-361. doi: 10.1109/BigMM.2015.11

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
