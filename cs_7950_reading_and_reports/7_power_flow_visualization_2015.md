This is a summary of "Transmission Line Power Flow Visualization Using 3-Dimensional Circle Diagrams" by Kumar and Singh [1]. The paper is available at http://ieeexplore.ieee.org.dist.lib.usu.edu/xpl/articleDetails.jsp?arnumber=7443375. The source code for the authors' implementation does not appear to be readily available.

The authors present a new method of visualizing variation in current flow through power transmission lines. Current flow is not constant. It can vary based on such parameters as voltage applied at the source node, length of the power lines, and temperature, among others. Current visualization techniques utilize two dimensional circle graphs. The variation in current flow causes the circles to constant move and scale, making the graphs difficult to read.

The authors do not enumerate any assumptions, nor could I infer any from their writing.

The authors do not make their data available, nor do they specify from where their data was obtained. It seems that finding similar data will take considerable time.

The authors briefly describe a circle graph, and what information can be inferred from examining one for power line flow. When the circle is changed, either translated or scaled, the new circle is drawn with a different Z coordinate. Thus, the algorithm builds up a surface. Knowing the optimum flow rates, the circles are colored to indicate suboptimal, optimal, and superoptimal rates. How the Z coordinate is calculated is not provided.

The authors do not compare their work to other options except to provide an example circle diagram. There are no metrics, use case studies, nor verification that their output is correct.

The authors do not mention any shortcomings, nor future work. One shortcoming apparent to me depends on if the implementation is interactive. A 3D visualization, projected onto a 2D screen or paper, hides details; data farther away is covered by closer data. If the implementation is not interactive, the orientation of the graph must be changed, then the user must wait for it render to see those details.

This is definitely an interesting visualization. It's difficult for me to gauge the usefulness, as I'm inexperienced at reading circle diagrams, especially those for electrical power transmission.

3D visualizations can be tricky. I wonder if there are 2D methods to improve the circle diagrams, instead of resorting to 3D.

This technique is applicable to visualize anything which 1) flows, 2) has a varying flow rate, and 3) has a concept of producing at one location and consuming at another. One such application would be free-way traffic. Traffic flows and that flow varies with time of day. Freeway interchanges can be thought as producing (traffic entering the freeway) and consuming (traffic exiting the freeway).

1. P. Kumar and A. K. Singh, "Transmission line power flow visualization using 3-dimensional circle diagrams," *2015 Annual IEEE India Conference (INDICON)*, New Delhi, 2015, pp. 1-6. doi: 10.1109/INDICON.2015.7443375

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
